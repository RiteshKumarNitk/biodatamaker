import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:biodata_maker/core/config/app_config.dart';
import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/core/services/hive_service.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/settings/data/models/user_settings.dart';
import 'package:biodata_maker/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:biodata_maker/features/settings/presentation/bloc/settings_event.dart';
import 'package:biodata_maker/features/settings/presentation/bloc/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Uses the app-root SettingsBloc (provided in main.dart) rather than a
    // local instance, so theme/language changes propagate to MaterialApp's
    // themeMode and locale immediately instead of only after a restart.
    return const _SettingsView();
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.tr('Settings'))),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: state is SettingsSaving
                ? const Center(
                    key: ValueKey('saving'),
                    child: CircularProgressIndicator(),
                  )
                : state is SettingsLoaded
                    ? _SettingsContent(
                        key: const ValueKey('content'),
                        settings: state.settings,
                      )
                    : const SizedBox(key: ValueKey('empty')),
          );
        },
      ),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  final UserSettings settings;

  const _SettingsContent({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _SectionHeader(title: Strings.tr('Appearance')).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, duration: 400.ms),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(Strings.tr('Theme'),
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                        value: 'system', label: Text(Strings.tr('System'))),
                    ButtonSegment(
                        value: 'light', label: Text(Strings.tr('Light'))),
                    ButtonSegment(
                        value: 'dark', label: Text(Strings.tr('Dark'))),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (selected) {
                    context
                        .read<SettingsBloc>()
                        .add(UpdateThemeMode(selected.first));
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Text(Strings.tr('Language'),
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600)),
                    const Spacer(),
                    DropdownButton<String>(
                      value: (settings.language == 'en' ||
                              settings.language == 'hi')
                          ? settings.language
                          : 'en',
                      items: [
                        DropdownMenuItem(
                            value: 'en', child: Text(Strings.tr('English'))),
                        const DropdownMenuItem(
                            value: 'hi',
                            child: Text('हिन्दी')),
                        const DropdownMenuItem(
                            value: 'gu',
                            enabled: false,
                            child: Text('ગુજરાતી (Coming Soon)')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          // Apply immediately app-wide; persistence happens in
                          // the bloc (same path used at the next launch).
                          Strings.set(value);
                          context
                              .read<SettingsBloc>()
                              .add(UpdateLanguage(value));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, duration: 400.ms),
        _SectionHeader(title: Strings.tr('PDF Export')).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, duration: 400.ms),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(Strings.tr('Quality'),
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600)),
                    const Spacer(),
                    DropdownButton<String>(
                      value: settings.pdfQuality,
                      items: [
                        DropdownMenuItem(
                            value: 'high',
                            child: Text(Strings.tr('High'))),
                        DropdownMenuItem(
                            value: 'medium',
                            child: Text(Strings.tr('Medium'))),
                        DropdownMenuItem(
                            value: 'low',
                            child: Text(Strings.tr('Low'))),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<SettingsBloc>()
                              .add(UpdatePdfQuality(value));
                        }
                      },
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    Text(Strings.tr('Page Size'),
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600)),
                    const Spacer(),
                    DropdownButton<String>(
                      value: settings.pdfPageSize,
                      items: const [
                        DropdownMenuItem(value: 'A4', child: Text('A4')),
                        DropdownMenuItem(value: 'Letter', child: Text('Letter')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<SettingsBloc>()
                              .add(UpdatePdfPageSize(value));
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, duration: 400.ms),
        _SectionHeader(title: Strings.tr('Data')).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, duration: 400.ms),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          // Transparent Material so the tiles' ink ripples paint correctly
          // instead of being hidden by the decorated card background.
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(Strings.tr('Auto Save')),
                  subtitle: Text(Strings.tr('Automatically save biodata changes')),
                  value: settings.autoSave,
                  onChanged: (_) {
                    context.read<SettingsBloc>().add(const ToggleAutoSave());
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.backup_outlined),
                  title: Text(Strings.tr('Backup')),
                  subtitle: Text(Strings.tr('Export all biodata as JSON')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _performBackup(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.restore_outlined),
                  title: Text(Strings.tr('Restore')),
                  subtitle: Text(Strings.tr('Import biodata from JSON file')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _performRestore(context),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, duration: 400.ms),
        _SectionHeader(title: Strings.tr('About')).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, duration: 400.ms),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.star_outline),
                  title: Text(Strings.tr('Rate App')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _rateApp(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.share_outlined),
                  title: Text(Strings.tr('Share App')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    SharePlus.instance.share(
                      ShareParams(text: Strings.tr('Check out Biodata Maker app!')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(Strings.tr('Privacy Policy')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/privacy-policy'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(Strings.tr('App Version')),
                  trailing: Text(
                    AppConfig.appVersion,
                    style: GoogleFonts.poppins(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, duration: 400.ms),
        const SizedBox(height: 32),
      ],
    );
  }

  /// Opens the store listing page so the user can rate the app. No-ops
  /// gracefully (with a message) when no store app is available.
  Future<void> _rateApp(BuildContext context) async {
    const androidUrl = 'https://play.google.com/store/apps/details?id=com.example.biodata_maker';
    final uri = Uri.parse(androidUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Strings.tr('Could not open the store app'))),
      );
    }
  }

  Future<void> _performBackup(BuildContext context) async {
    try {
      final hiveService = sl<HiveService>();
      final backupData = await hiveService.backup();
      final json = const JsonEncoder.withIndent('  ').convert(backupData);
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${dir.path}/biodata_backup_$timestamp.json');
      await file.writeAsString(json);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.tr('Backup saved to')}: ${file.path}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.tr('Backup failed')}: $e')),
        );
      }
    }
  }

  Future<void> _performRestore(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result == null || result.files.isEmpty) return;
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;
      final hiveService = sl<HiveService>();
      await hiveService.restore(data);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Strings.tr('Data restored successfully'))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.tr('Restore failed')}: $e')),
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
