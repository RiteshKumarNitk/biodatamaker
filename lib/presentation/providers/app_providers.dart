import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biodata_maker/core/services/hive_service.dart';
import 'package:biodata_maker/data/models/models.dart';

/// Provider for the HiveService instance
final hiveServiceProvider = Provider<HiveService>((ref) {
  throw UnimplementedError('hiveServiceProvider must be overridden at startup');
});

/// Provider that watches for biodata changes
final biodataListProvider = Provider<List<Biodata>>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return hiveService.getActiveBiodatas();
});

/// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Filtered biodatas based on search
final filteredBiodataProvider = Provider<List<Biodata>>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  final query = ref.watch(searchQueryProvider);
  return hiveService.searchBiodatas(query);
});

/// User settings provider
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, UserSettings>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return SettingsNotifier(hiveService);
});

class SettingsNotifier extends StateNotifier<UserSettings> {
  final HiveService _hiveService;

  SettingsNotifier(this._hiveService) : super(_hiveService.getSettings());

  void updateSettings(UserSettings settings) {
    state = settings;
    _hiveService.saveSettings(settings);
  }

  void toggleThemeMode(String mode) {
    state = state.copyWith(themeMode: mode);
    _hiveService.saveSettings(state);
  }

  void setLanguage(String language) {
    state = state.copyWith(language: language);
    _hiveService.saveSettings(state);
  }

  void setPdfQuality(String quality) {
    state = state.copyWith(pdfQuality: quality);
    _hiveService.saveSettings(state);
  }
}

/// Selected bottom nav index provider
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

/// Stats provider
final statsProvider = Provider<Map<String, int>>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return {
    'total': hiveService.totalBiodatas,
    'favorites': hiveService.totalFavorites,
    'archived': hiveService.totalArchived,
  };
});
