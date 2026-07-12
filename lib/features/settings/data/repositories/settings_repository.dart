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

  void setThemeMode(String mode) {
    final settings = getSettings();
    _hiveService.saveSettings(settings.copyWith(themeMode: mode));
  }

  void setLanguage(String lang) {
    final settings = getSettings();
    _hiveService.saveSettings(settings.copyWith(language: lang));
  }

  void setPdfQuality(String q) {
    final settings = getSettings();
    _hiveService.saveSettings(settings.copyWith(pdfQuality: q));
  }

  void setPdfPageSize(String s) {
    final settings = getSettings();
    _hiveService.saveSettings(settings.copyWith(pdfPageSize: s));
  }

  void incrementBiodataCount() {
    final settings = getSettings();
    _hiveService.saveSettings(
      settings.copyWith(
        totalBiodatasCreated: settings.totalBiodatasCreated + 1,
      ),
    );
  }

  void setSubscriptionTier(String tier, {DateTime? expiresAt}) {
    final settings = getSettings();
    _hiveService.saveSettings(
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
