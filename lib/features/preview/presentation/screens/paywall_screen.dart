import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/core/services/purchase_service.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/settings/data/repositories/settings_repository.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  final SettingsRepository _settingsRepo = sl<SettingsRepository>();
  final PurchaseService _purchases = sl<PurchaseService>();

  String _selectedPlan = 'yearly';
  bool _isProcessing = false;
  bool _storeReady = false;
  String? _storeMessage;

  @override
  void initState() {
    super.initState();
    _initStore();
    // React to stream-driven phase changes (pending/success/error).
    _purchases.phase.addListener(_onPhaseChanged);
  }

  @override
  void dispose() {
    _purchases.phase.removeListener(_onPhaseChanged);
    super.dispose();
  }

  Future<void> _initStore() async {
    setState(() => _isProcessing = true);
    final ok = await _purchases.init();
    if (!mounted) return;
    setState(() {
      _storeReady = ok;
      _isProcessing = false;
      _storeMessage = ok
          ? null
          : Strings.tr(
              'Store unavailable. Premium is activated automatically once your purchase is processed by the store.');
    });
  }

  void _onPhaseChanged() {
    if (!mounted) return;
    switch (_purchases.phase.value) {
      case PurchasePhase.success:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Strings.tr('Welcome to Premium!'))),
        );
        Navigator.of(context).pop();
        break;
      case PurchasePhase.error:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_purchases.errorMessage.value ??
                Strings.tr('Purchase failed')),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      default:
        break;
    }
    if (mounted) setState(() {}); // refresh button states
  }

  void _subscribe(String tier) async {
    if (!_storeReady) return;
    setState(() => _isProcessing = true);
    final started = await _purchases.buy(tier);
    // The purchase stream drives the rest (pending/success/error).
    if (mounted && !started) {
      setState(() => _isProcessing = false);
    }
  }

  void _restorePurchases() async {
    if (!_storeReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Strings.tr(
              'Store unavailable. Connect to the internet and try again.')),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _isProcessing = true);
    await _purchases.restore();
    if (mounted) setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = _settingsRepo.isPremium;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(Strings.tr('Premium'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (isPremium)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: colorScheme.tertiary, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        Strings.tr('You are already a Premium member!'),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 48,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              Strings.tr('Go Premium'),
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Strings.tr('Unlock all features and create beautiful biodatas'),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            _buildBenefitRow(
                Icons.dashboard_customize, Strings.tr('All templates unlocked'), colorScheme),
            const SizedBox(height: 16),
            _buildBenefitRow(
                Icons.water_drop, Strings.tr('No watermark on PDF'), colorScheme),
            const SizedBox(height: 16),
            _buildBenefitRow(
                Icons.all_inclusive, Strings.tr('Unlimited biodatas'), colorScheme),
            const SizedBox(height: 16),
            _buildBenefitRow(
                Icons.edit_note, Strings.tr('Custom fields support'), colorScheme),
            const SizedBox(height: 32),
            if (_storeMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 20, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _storeMessage!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            _buildPlanCard(
              Strings.tr('Monthly'),
              _priceFor('monthly', '₹149'),
              '/month',
              'monthly',
              colorScheme,
              isPremium,
            ),
            const SizedBox(height: 12),
            _buildPlanCard(
              Strings.tr('Yearly'),
              _priceFor('yearly', '₹499'),
              '/year',
              'yearly',
              colorScheme,
              isPremium,
              isBestValue: true,
            ),
            const SizedBox(height: 12),
            _buildPlanCard(
              Strings.tr('Lifetime'),
              _priceFor('lifetime', '₹799'),
              ' one-time',
              'lifetime',
              colorScheme,
              isPremium,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: isPremium || _isProcessing || !_storeReady
                    ? null
                    : () => _subscribe(_selectedPlan),
                child: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(isPremium
                        ? Strings.tr('Already Premium')
                        : (_purchases.phase.value == PurchasePhase.pending
                            ? Strings.tr('Processing...')
                            : Strings.tr('Continue'))),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: _isProcessing ? null : _restorePurchases,
                child: Text(Strings.tr('Restore Purchases')),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Live store price when available; static fallback otherwise.
  String _priceFor(String tier, String fallback) {
    final product = _purchases.productFor(tier);
    return product?.price ?? fallback;
  }

  Widget _buildBenefitRow(IconData icon, String text, ColorScheme cs) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: cs.primary, size: 22),
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildPlanCard(
    String title,
    String price,
    String period,
    String value,
    ColorScheme cs,
    bool isPremium, {
    bool isBestValue = false,
  }) {
    final isSelected = _selectedPlan == value;

    return GestureDetector(
      onTap: isPremium || !_storeReady
          ? null
          : () => setState(() => _selectedPlan = value),
      child: AnimatedScale(
        scale: isSelected ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? cs.primary.withValues(alpha: 0.05)
                : cs.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? cs.primary : cs.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isBestValue) ...[
                          const SizedBox(width: 8),
                          // Always visible when selected OR always shown as a
                          // badge — previously it only appeared after tapping,
                          // which defeated its purpose.
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: cs.tertiary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              Strings.tr('Best Value'),
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: cs.onTertiary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: cs.primary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3, left: 4),
                          child: Text(
                            period,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: cs.primary, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
