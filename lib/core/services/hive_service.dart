import 'package:hive_flutter/hive_flutter.dart';

import 'package:biodata_maker/core/config/app_config.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/biodata/data/models/custom_field.dart';
import 'package:biodata_maker/features/biodata/data/models/photo_info.dart';
import 'package:biodata_maker/features/settings/data/models/user_settings.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/features/auth/data/models/user.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  late Box<Biodata> _biodataBox;
  late Box<UserSettings> _settingsBox;
  late Box<ThemeConfig> _templatesBox;
  late Box<User> _authBox;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    Hive.registerAdapter(BiodataAdapter());
    Hive.registerAdapter(CustomFieldAdapter());
    Hive.registerAdapter(PhotoInfoAdapter());
    Hive.registerAdapter(ThemeConfigAdapter());
    Hive.registerAdapter(UserSettingsAdapter());
    Hive.registerAdapter(UserAdapter());
    _biodataBox = await Hive.openBox<Biodata>(AppConfig.hiveBiodataBox);
    _settingsBox = await Hive.openBox<UserSettings>(AppConfig.hiveSettingsBox);
    _templatesBox = await Hive.openBox<ThemeConfig>(AppConfig.hiveTemplatesBox);
    _authBox = await Hive.openBox<User>(AppConfig.hiveAuthBox);
    _initialized = true;
  }

  bool get isInitialized => _initialized;

  Future<void> _ensureInitialized() async {
    if (!_initialized) await init();
  }

  Future<Biodata> saveBiodata(Biodata biodata) async {
    await _ensureInitialized();
    await _biodataBox.put(biodata.id, biodata);
    return biodata;
  }

  Biodata? getBiodata(String id) {
    return _biodataBox.get(id);
  }

  List<Biodata> getAllBiodata() {
    return _biodataBox.values.toList();
  }

  List<Biodata> getActiveBiodata() {
    return _biodataBox.values.where((b) => !b.isArchived).toList();
  }

  List<Biodata> getFavoriteBiodata() {
    return _biodataBox.values.where((b) => b.isFavorite && !b.isArchived).toList();
  }

  List<Biodata> getArchivedBiodata() {
    return _biodataBox.values.where((b) => b.isArchived).toList();
  }

  Future<void> deleteBiodata(String id) async {
    await _ensureInitialized();
    await _biodataBox.delete(id);
  }

  Future<Biodata> toggleFavorite(String id) async {
    await _ensureInitialized();
    final biodata = _biodataBox.get(id);
    if (biodata == null) throw Exception('Biodata not found');
    final updated = biodata.copyWith(
      isFavorite: !biodata.isFavorite,
      updatedAt: DateTime.now(),
    );
    await _biodataBox.put(id, updated);
    return updated;
  }

  Future<Biodata> toggleArchive(String id) async {
    await _ensureInitialized();
    final biodata = _biodataBox.get(id);
    if (biodata == null) throw Exception('Biodata not found');
    final updated = biodata.copyWith(
      isArchived: !biodata.isArchived,
      updatedAt: DateTime.now(),
    );
    await _biodataBox.put(id, updated);
    return updated;
  }

  Future<Biodata> duplicateBiodata(String id) async {
    await _ensureInitialized();
    final original = _biodataBox.get(id);
    if (original == null) throw Exception('Biodata not found');
    final duplicate = original.copyWith(
      id: '${original.id}_copy_${DateTime.now().millisecondsSinceEpoch}',
      name: '${original.name} (Copy)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDraft: true,
      isFavorite: false,
      isArchived: false,
      downloadCount: 0,
    );
    await _biodataBox.put(duplicate.id, duplicate);
    return duplicate;
  }

  List<Biodata> searchBiodata(String query) {
    if (query.isEmpty) return getAllBiodata();
    final lower = query.toLowerCase();
    return _biodataBox.values.where((b) {
      return b.fullName.toLowerCase().contains(lower) ||
          b.occupation.toLowerCase().contains(lower) ||
          b.city.toLowerCase().contains(lower) ||
          b.religion.toLowerCase().contains(lower) ||
          b.caste.toLowerCase().contains(lower);
    }).toList();
  }

  Future<UserSettings> saveSettings(UserSettings settings) async {
    await _ensureInitialized();
    await _settingsBox.put(settings.id, settings);
    return settings;
  }

  UserSettings? getSettings(String id) {
    return _settingsBox.get(id);
  }

  Future<ThemeConfig> saveTemplate(ThemeConfig template) async {
    await _ensureInitialized();
    await _templatesBox.put(template.id, template);
    return template;
  }

  ThemeConfig? getTemplate(String id) {
    return _templatesBox.get(id);
  }

  List<ThemeConfig> getAllTemplates() {
    return _templatesBox.values.toList();
  }

  List<ThemeConfig> getPublishedTemplates() {
    return _templatesBox.values.where((t) => t.isPublished).toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  Future<void> deleteTemplate(String id) async {
    await _ensureInitialized();
    await _templatesBox.delete(id);
  }

  Future<User> saveUser(User user) async {
    await _ensureInitialized();
    await _authBox.put(user.id, user);
    return user;
  }

  User? getUser(String id) {
    return _authBox.get(id);
  }

  Future<void> deleteUser(String id) async {
    await _ensureInitialized();
    await _authBox.delete(id);
  }

  bool isLoggedIn() {
    return _authBox.isNotEmpty;
  }

  List<User> getAllUsers() {
    return _authBox.values.toList();
  }

  Future<void> deleteAllUsers() async {
    await _authBox.clear();
  }

  int totalBiodatas() {
    return _biodataBox.length;
  }

  int totalFavorites() {
    return _biodataBox.values.where((b) => b.isFavorite).length;
  }

  int totalArchived() {
    return _biodataBox.values.where((b) => b.isArchived).length;
  }

  Future<Map<String, dynamic>> backup() async {
    await _ensureInitialized();
    final biodatas = _biodataBox.values.map((b) => b.toJson()).toList();
    final settings = _settingsBox.values.map((s) => s.toJson()).toList();
    final templates = _templatesBox.values.map((t) => t.toJson()).toList();
    return {
      'version': AppConfig.appVersion,
      'timestamp': DateTime.now().toIso8601String(),
      'biodatas': biodatas,
      'settings': settings,
      'templates': templates,
    };
  }

  Future<void> restore(Map<String, dynamic> backupData) async {
    await _ensureInitialized();
    if (backupData['biodatas'] is List) {
      for (final json in backupData['biodatas']) {
        final biodata = Biodata.fromJson(json as Map<String, dynamic>);
        await _biodataBox.put(biodata.id, biodata);
      }
    }
    if (backupData['settings'] is List) {
      for (final json in backupData['settings']) {
        final settings = UserSettings.fromJson(json as Map<String, dynamic>);
        await _settingsBox.put(settings.id, settings);
      }
    }
    if (backupData['templates'] is List) {
      for (final json in backupData['templates']) {
        final template = ThemeConfig.fromJson(json as Map<String, dynamic>);
        await _templatesBox.put(template.id, template);
      }
    }
  }

  Future<void> clearAll() async {
    await _ensureInitialized();
    await _biodataBox.clear();
    await _settingsBox.clear();
    await _templatesBox.clear();
    await _authBox.clear();
  }
}
