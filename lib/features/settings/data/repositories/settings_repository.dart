import 'package:biodata_maker/core/services/hive_service.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/settings/data/models/user_settings.dart';

class SettingsRepository {
  final HiveService _hiveService;
  static const _settingsId = 'default_settings';

  SettingsRepository({HiveService? hiveService})
      : _hiveService = hiveService ?? sl<HiveService>();

  UserSettings getSettings() {
    return _hiveService.getSettings(_settingsId) ??
        UserSettings(id: _settingsId);
  }

  Future<void> updateSettings(UserSettings settings) async {
    await _hiveService.saveSettings(settings);
  }

  Future<void> setThemeMode(String mode) async {
    final settings = getSettings();
    await _hiveService.saveSettings(settings.copyWith(themeMode: mode));
  }

  Future<void> setLanguage(String lang) async {
    final settings = getSettings();
    await _hiveService.saveSettings(settings.copyWith(language: lang));
  }

  Future<void> setPdfQuality(String q) async {
    final settings = getSettings();
    await _hiveService.saveSettings(settings.copyWith(pdfQuality: q));
  }

  Future<void> setPdfPageSize(String s) async {
    final settings = getSettings();
    await _hiveService.saveSettings(settings.copyWith(pdfPageSize: s));
  }

  Future<void> incrementBiodataCount() async {
    final settings = getSettings();
    await _hiveService.saveSettings(
      settings.copyWith(
        totalBiodatasCreated: settings.totalBiodatasCreated + 1,
      ),
    );
  }

  Future<void> setSubscriptionTier(String tier, {DateTime? expiresAt}) async {
    final settings = getSettings();
    await _hiveService.saveSettings(
      settings.copyWith(
        subscriptionTier: tier,
        subscriptionExpiresAt: expiresAt,
      ),
    );
  }

  bool get isPremium {
    final settings = getSettings();
    if (settings.subscriptionTier == 'free') return false;
    if (settings.subscriptionExpiresAt == null) return true;
    return settings.subscriptionExpiresAt!.isAfter(DateTime.now());
  }
}
