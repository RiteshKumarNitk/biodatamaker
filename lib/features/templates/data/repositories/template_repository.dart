import 'package:biodata_maker/core/services/hive_service.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/features/templates/data/models/theme_engine.dart';

class TemplateRepository {
  final HiveService _hiveService;

  TemplateRepository({HiveService? hiveService})
      : _hiveService = hiveService ?? sl<HiveService>();

  Future<void> save(ThemeConfig template) async {
    await _hiveService.saveTemplate(template);
  }

  ThemeConfig? getById(String id) {
    return _hiveService.getTemplate(id);
  }

  List<ThemeConfig> getAll() {
    return _hiveService.getAllTemplates();
  }

  List<ThemeConfig> getPublished() {
    return _hiveService.getPublishedTemplates();
  }

  List<ThemeConfig> getByCategory(String category) {
    return _hiveService
        .getAllTemplates()
        .where((t) => t.category == category)
        .toList();
  }

  List<ThemeConfig> getFreeTemplates() {
    return _hiveService
        .getAllTemplates()
        .where((t) => !t.isPremium)
        .toList();
  }

  List<ThemeConfig> getPremiumTemplates() {
    return _hiveService
        .getAllTemplates()
        .where((t) => t.isPremium)
        .toList();
  }

  List<String> getCategories() {
    return _hiveService
        .getAllTemplates()
        .map((t) => t.category)
        .toSet()
        .toList();
  }

  Future<void> delete(String id) async {
    await _hiveService.deleteTemplate(id);
  }

  Future<void> loadDefaultTemplates() async {
    final templates = ThemeEngine.defaultTemplates;
    for (final template in templates) {
      await _hiveService.saveTemplate(template);
    }
  }
}
