import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _isInitialized = false;

  /// Test ad unit IDs (replace with real IDs for production).
  /// These are Google's official test IDs and are safe to use in development.
  static String get bannerAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'  // Android test banner
          : 'ca-app-pub-3940256099942544/2934735716'; // iOS test banner
    }
    // TODO: Replace with your actual ad unit IDs
    return Platform.isAndroid
        ? 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX'
        : 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'  // Android test interstitial
          : 'ca-app-pub-3940256099942544/4411468910'; // iOS test interstitial
    }
    return Platform.isAndroid
        ? 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX'
        : 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    await MobileAds.instance.initialize();
    _isInitialized = true;
  }

  BannerAd createBannerAd({
    AdSize size = AdSize.banner,
    VoidCallback? onLoaded,
    VoidCallback? onFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded?.call(),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onFailedToLoad?.call();
        },
      ),
    );
  }
}
