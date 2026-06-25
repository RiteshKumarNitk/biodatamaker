import 'package:hive_flutter/hive_flutter.dart';
import 'package:biodata_maker/core/config/app_config.dart';
import 'package:biodata_maker/data/models/models.dart';

class HiveService {
  late Box<Biodata> _biodataBox;
  late Box<UserSettings> _settingsBox;
  late Box<ThemeConfig> _templatesBox;

  Box<Biodata> get biodataBox => _biodataBox;
  Box<UserSettings> get settingsBox => _settingsBox;
  Box<ThemeConfig> get templatesBox => _templatesBox;

  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters (inner types first, then types that contain them)
    Hive.registerAdapter(CustomFieldAdapter());
    Hive.registerAdapter(PhotoInfoAdapter());
    Hive.registerAdapter(BiodataAdapter());
    Hive.registerAdapter(ThemeConfigAdapter());
    Hive.registerAdapter(UserSettingsAdapter());

    // Open boxes
    _biodataBox = await Hive.openBox<Biodata>(AppConfig.hiveBoxName);
    _settingsBox = await Hive.openBox<UserSettings>(AppConfig.settingsBoxName);
    _templatesBox = await Hive.openBox<ThemeConfig>(AppConfig.templatesBoxName);
  }

  // ─── Biodata Operations ────────────────────────────────────────
  Future<void> saveBiodata(Biodata biodata) async {
    await _biodataBox.put(biodata.id, biodata);
  }

  Biodata? getBiodata(String id) {
    return _biodataBox.get(id);
  }

  List<Biodata> getAllBiodatas() {
    return _biodataBox.values.toList();
  }

  List<Biodata> getActiveBiodatas() {
    return _biodataBox.values
        .where((b) => !b.isArchived)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  List<Biodata> getFavoriteBiodatas() {
    return _biodataBox.values
        .where((b) => b.isFavorite && !b.isArchived)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  List<Biodata> getArchivedBiodatas() {
    return _biodataBox.values
        .where((b) => b.isArchived)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> deleteBiodata(String id) async {
    await _biodataBox.delete(id);
  }

  Future<void> toggleFavorite(String id) async {
    final biodata = _biodataBox.get(id);
    if (biodata != null) {
      await _biodataBox.put(
        id,
        biodata.copyWith(
          isFavorite: !biodata.isFavorite,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> toggleArchive(String id) async {
    final biodata = _biodataBox.get(id);
    if (biodata != null) {
      await _biodataBox.put(
        id,
        biodata.copyWith(
          isArchived: !biodata.isArchived,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> duplicateBiodata(String id) async {
    final original = _biodataBox.get(id);
    if (original != null) {
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      final duplicate = original.copyWith(
        id: newId,
        name: '${original.name} (Copy)',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isFavorite: false,
        isArchived: false,
      );
      await _biodataBox.put(newId, duplicate);
    }
  }

  // ─── Settings Operations ───────────────────────────────────────
  Future<void> saveSettings(UserSettings settings) async {
    await _settingsBox.put('settings', settings);
  }

  UserSettings getSettings() {
    return _settingsBox.get('settings') ?? const UserSettings();
  }

  // ─── Template Operations ───────────────────────────────────────
  Future<void> saveTemplate(ThemeConfig template) async {
    await _templatesBox.put(template.id, template);
  }

  ThemeConfig? getTemplate(String id) {
    return _templatesBox.get(id);
  }

  List<ThemeConfig> getAllTemplates() {
    return _templatesBox.values.toList();
  }

  Future<void> deleteTemplate(String id) async {
    await _templatesBox.delete(id);
  }

  // ─── Search ────────────────────────────────────────────────────
  List<Biodata> searchBiodatas(String query) {
    if (query.isEmpty) return getActiveBiodatas();
    final lowerQuery = query.toLowerCase();
    return _biodataBox.values.where((b) {
      return b.fullName.toLowerCase().contains(lowerQuery) ||
          b.name.toLowerCase().contains(lowerQuery) ||
          b.occupation.toLowerCase().contains(lowerQuery) ||
          b.city.toLowerCase().contains(lowerQuery) ||
          b.religion.toLowerCase().contains(lowerQuery);
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  // ─── Statistics ────────────────────────────────────────────────
  int get totalBiodatas => _biodataBox.length;
  int get totalFavorites =>
      _biodataBox.values.where((b) => b.isFavorite).length;
  int get totalArchived =>
      _biodataBox.values.where((b) => b.isArchived).length;
}
