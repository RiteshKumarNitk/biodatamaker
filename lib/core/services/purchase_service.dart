import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:biodata_maker/features/settings/data/repositories/settings_repository.dart';
import 'package:biodata_maker/core/services/service_locator.dart';

/// Product ids as configured in Google Play Console / App Store Connect.
/// Keep these in sync with the store listings.
abstract final class IapProductIds {
  static const monthly = 'vivahbio_premium_monthly';
  static const yearly = 'vivahbio_premium_yearly';
  static const lifetime = 'vivahbio_premium_lifetime';

  static const Set<String> all = {monthly, yearly, lifetime};

  static String tierFor(String productId) {
    if (productId == monthly) return 'monthly';
    if (productId == yearly) return 'yearly';
    return 'lifetime';
  }

  /// Expiry for subscription tiers; lifetime (non-consumable) never expires.
  static DateTime? expiresAtFor(String productId) {
    switch (tierFor(productId)) {
      case 'monthly':
        return DateTime.now().add(const Duration(days: 30));
      case 'yearly':
        return DateTime.now().add(const Duration(days: 365));
      default:
        return null;
    }
  }
}

enum PurchasePhase {
  idle,
  storeUnavailable,
  loading,
  ready,
  pending,
  success,
  error,
}

/// Wraps `in_app_purchase` and delivers premium entitlements to
/// [SettingsRepository] when a purchase completes or is restored.
///
/// The store may be unavailable (sideloaded builds, emulators without Play,
/// desktop). In that case [loadProducts] reports it and the paywall shows a
/// clear message instead of a fake purchase path.
class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final List<ProductDetails> _products = [];

  final ValueNotifier<PurchasePhase> phase =
      ValueNotifier<PurchasePhase>(PurchasePhase.idle);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  List<ProductDetails> get products => List.unmodifiable(_products);
  ProductDetails? productFor(String tier) {
    final id = switch (tier) {
      'monthly' => IapProductIds.monthly,
      'yearly' => IapProductIds.yearly,
      _ => IapProductIds.lifetime,
    };
    for (final p in _products) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// Subscribes to the purchase stream and refreshes products. Safe to call
  /// multiple times (e.g. every time the paywall opens).
  Future<bool> init() async {
    _subscription ??= _iap.purchaseStream.listen(
      _onPurchases,
      onError: (Object e) {
        phase.value = PurchasePhase.error;
        errorMessage.value = e.toString();
      },
    );
    try {
      final available = await _iap.isAvailable();
      if (!available) {
        phase.value = PurchasePhase.storeUnavailable;
        return false;
      }
      await loadProducts();
      return _products.isNotEmpty;
    } catch (e) {
      debugPrint('IAP init failed: $e');
      phase.value = PurchasePhase.storeUnavailable;
      return false;
    }
  }

  Future<void> loadProducts() async {
    phase.value = PurchasePhase.loading;
    errorMessage.value = null;
    final response = await _iap.queryProductDetails(IapProductIds.all);
    // `notFoundIDs` is non-empty whenever the store console is missing some
    // products; that is fine as long as at least one product resolves.
    _products
      ..clear()
      ..addAll(response.productDetails);
    phase.value =
        _products.isNotEmpty ? PurchasePhase.ready : PurchasePhase.storeUnavailable;
    if (_products.isEmpty) {
      errorMessage.value =
          'No products found in the store. Check the product IDs and store setup.';
    }
  }

  /// Launches the store purchase flow for [tier]. Returns false when the
  /// flow could not be started (product missing / store error).
  Future<bool> buy(String tier) async {
    final product = productFor(tier);
    if (product == null) {
      errorMessage.value = 'Product not available right now.';
      return false;
    }
    try {
      final param = PurchaseParam(productDetails: product);
      // Monthly/yearly are auto-renewing subscriptions; lifetime is a
      // non-consumable one-time purchase. All are handled by buyNonConsumable.
      return await _iap.buyNonConsumable(purchaseParam: param);
    } catch (e) {
      debugPrint('buy($tier) failed: $e');
      errorMessage.value = e.toString();
      return false;
    }
  }

  /// Asks the store to re-deliver existing entitlements; results arrive on
  /// the purchase stream and are handled by [_onPurchases].
  Future<void> restore() async {
    try {
      await _iap.restorePurchases();
    } catch (e) {
      debugPrint('restore failed: $e');
      errorMessage.value = e.toString();
    }
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          phase.value = PurchasePhase.pending;
          break;
        case PurchaseStatus.error:
          phase.value = PurchasePhase.error;
          errorMessage.value = purchase.error?.message ?? 'Purchase failed';
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final valid = await verifyPurchase(purchase);
          if (valid) {
            await _deliver(purchase);
            phase.value = PurchasePhase.success;
          } else {
            phase.value = PurchasePhase.error;
            errorMessage.value = 'Purchase could not be verified.';
          }
          break;
        case PurchaseStatus.canceled:
          phase.value = PurchasePhase.idle;
          break;
      }
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  /// Local entitlement verification. A production app should additionally
  /// verify receipts against your server; without a backend this checks that
  /// the purchase came from the store stream for one of our known product ids.
  Future<bool> verifyPurchase(PurchaseDetails purchase) async {
    return IapProductIds.all.contains(purchase.productID);
  }

  Future<void> _deliver(PurchaseDetails purchase) async {
    final tier = IapProductIds.tierFor(purchase.productID);
    final expiresAt = IapProductIds.expiresAtFor(purchase.productID);
    await sl<SettingsRepository>().setSubscriptionTier(
      tier,
      expiresAt: expiresAt,
    );
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
