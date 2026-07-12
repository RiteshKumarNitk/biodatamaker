import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Privacy Policy',
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last updated: January 2025',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          _section(
            'What We Store',
            'All your biodata, personal information, photos, and preferences are stored locally on your device. We do not upload, sync, or transmit your data to any external servers. Your information remains entirely under your control.',
            cs,
          ),
          _section(
            'Photos',
            'Photos you add to biodatas are stored locally on your device. We do not access, collect, or transmit your photos. You have full control over your images.',
            cs,
          ),
          _section(
            'Exporting & Sharing',
            'When you export a biodata as a PDF or share it with others, the generated file contains the data you have entered. This action is performed locally and we do not monitor or store any shared content.',
            cs,
          ),
          _section(
            'Subscriptions',
            'If you purchase a premium subscription, payment processing is handled by the respective app store (Google Play or Apple App Store). We do not collect or store any payment information.',
            cs,
          ),
          _section(
            'Your Control',
            'You can delete all your data at any time by clearing the app data or uninstalling the app. All locally stored data will be permanently removed.',
            cs,
          ),
          _section(
            'Contact',
            'If you have any questions about this privacy policy, please contact us at support@biodatamaker.app',
            cs,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _section(String title, String content, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: cs.onSurface,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
