class AppConfig {
  AppConfig._();

  static const String appName = 'Biodata Maker';
  static const String appVersion = '1.0.0';
  static const String hiveBoxName = 'biodata_box';
  static const String settingsBoxName = 'settings_box';
  static const String templatesBoxName = 'templates_box';

  // Hive Type Adapters
  static const int biodataTypeId = 0;
  static const int themeConfigTypeId = 1;
  static const int userSettingsTypeId = 2;
  static const int customFieldTypeId = 3;
  static const int photoInfoTypeId = 4;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Pagination
  static const int defaultPageSize = 20;
}
