import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biodata_maker/data/models/models.dart';
import 'package:biodata_maker/presentation/providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          _SectionHeader(title: 'Appearance'),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Theme',
                  subtitle: _getThemeLabel(settings.themeMode),
                  onTap: () => _showThemeDialog(context, ref, settings),
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: settings.language == 'en' ? 'English' : settings.language,
                  onTap: () {
                    // TODO: Implement language picker
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // PDF Section
          _SectionHeader(title: 'PDF Export'),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.high_quality,
                  title: 'PDF Quality',
                  subtitle: settings.pdfQuality.toUpperCase(),
                  onTap: () => _showQualityDialog(context, ref, settings),
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Page Size',
                  subtitle: settings.pdfPageSize,
                  onTap: () => _showPageSizeDialog(context, ref, settings),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Data Section
          _SectionHeader(title: 'Data'),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.backup_outlined,
                  title: 'Backup',
                  subtitle: 'Export all biodatas as JSON',
                  onTap: () {
                    // TODO: Implement backup
                  },
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.restore,
                  title: 'Restore',
                  subtitle: 'Import from backup file',
                  onTap: () {
                    // TODO: Implement restore
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.cloud_outlined),
                  title: const Text('Auto Save'),
                  subtitle: const Text('Save changes automatically'),
                  value: settings.autoSave,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .updateSettings(settings.copyWith(autoSave: value));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // About Section
          _SectionHeader(title: 'About'),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'Version 1.0.0',
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: 'Biodata Maker',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(
                      Icons.favorite,
                      size: 32,
                      color: Colors.red,
                    ),
                  ),
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.star_outline,
                  title: 'Rate App',
                  subtitle: 'Rate us on the app store',
                  onTap: () {
                    // TODO: Implement rating
                  },
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.share_outlined,
                  title: 'Share App',
                  subtitle: 'Share with friends and family',
                  onTap: () {
                    // TODO: Implement sharing
                  },
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'View our privacy policy',
                  onTap: () {
                    // TODO: Implement privacy policy
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _getThemeLabel(String mode) {
    switch (mode) {
      case 'light':
        return 'Light Mode';
      case 'dark':
        return 'Dark Mode';
      default:
        return 'System Default';
    }
  }

  void _showThemeDialog(
      BuildContext context, WidgetRef ref, UserSettings settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('System Default'),
              value: 'system',
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).toggleThemeMode(value);
                }
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Light Mode'),
              value: 'light',
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).toggleThemeMode(value);
                }
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Dark Mode'),
              value: 'dark',
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).toggleThemeMode(value);
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQualityDialog(
      BuildContext context, WidgetRef ref, UserSettings settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PDF Quality'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('High'),
              value: 'high',
              groupValue: settings.pdfQuality,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setPdfQuality(value);
                }
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Medium'),
              value: 'medium',
              groupValue: settings.pdfQuality,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setPdfQuality(value);
                }
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Low'),
              value: 'low',
              groupValue: settings.pdfQuality,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setPdfQuality(value);
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPageSizeDialog(
      BuildContext context, WidgetRef ref, UserSettings settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Page Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('A4'),
              value: 'A4',
              groupValue: settings.pdfPageSize,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).updateSettings(
                        settings.copyWith(pdfPageSize: value),
                      );
                }
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Letter'),
              value: 'Letter',
              groupValue: settings.pdfPageSize,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).updateSettings(
                        settings.copyWith(pdfPageSize: value),
                      );
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
      ),
      onTap: onTap,
    );
  }
}
