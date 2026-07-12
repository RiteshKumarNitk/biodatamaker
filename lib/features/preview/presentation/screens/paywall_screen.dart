import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/settings/data/repositories/settings_repository.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  final SettingsRepository _settingsRepo = sl<SettingsRepository>();
  String _selectedPlan = 'yearly';
  bool _isProcessing = false;

  void _subscribe(String tier) async {
    setState(() => _isProcessing = true);
    try {
      DateTime? expiresAt;
      if (tier == 'monthly') {
        expiresAt = DateTime.now().add(const Duration(days: 30));
      } else if (tier == 'yearly') {
        expiresAt = DateTime.now().add(const Duration(days: 365));
      }
      _settingsRepo.setSubscriptionTier(tier, expiresAt: expiresAt);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Welcome to Premium!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _restorePurchases() async {
    setState(() => _isProcessing = true);
    try {
      final currentTier = _settingsRepo.getSettings().subscriptionTier;
      if (currentTier != 'free') {
        _settingsRepo.setSubscriptionTier(currentTier);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Purchases restored successfully')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No previous purchases found')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restore failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = _settingsRepo.isPremium;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Premium')),
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
                        'You are already a Premium member!',
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
              'Go Premium',
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Unlock all features and create beautiful biodatas',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            _buildBenefitRow(
                Icons.dashboard_customize, 'All templates unlocked', colorScheme),
            const SizedBox(height: 16),
            _buildBenefitRow(
                Icons.water_drop, 'No watermark on PDF', colorScheme),
            const SizedBox(height: 16),
            _buildBenefitRow(
                Icons.all_inclusive, 'Unlimited biodatas', colorScheme),
            const SizedBox(height: 16),
            _buildBenefitRow(
                Icons.edit_note, 'Custom fields support', colorScheme),
            const SizedBox(height: 32),
            _buildPlanCard(
              'Monthly',
              '₹149',
              '/month',
              'monthly',
              colorScheme,
              isPremium,
            ),
            const SizedBox(height: 12),
            _buildPlanCard(
              'Yearly',
              '₹499',
              '/year',
              'yearly',
              colorScheme,
              isPremium,
              isBestValue: true,
            ),
            const SizedBox(height: 12),
            _buildPlanCard(
              'Lifetime',
              '₹799',
              ' one-time',
              'lifetime',
              colorScheme,
              isPremium,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed:
                    isPremium ? null : () => _subscribe(_selectedPlan),
                child: Text(
                    isPremium ? 'Already Premium' : 'Continue'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: _isProcessing ? null : _restorePurchases,
                child: const Text('Restore Purchases'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
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
      onTap: isPremium ? null : () => setState(() => _selectedPlan = value),
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
                          AnimatedOpacity(
                            opacity: isSelected ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: cs.tertiary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Best Value',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: cs.onTertiary,
                                  fontWeight: FontWeight.w600,
                                ),
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
