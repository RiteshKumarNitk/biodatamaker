class AppConfig {
  AppConfig._();

  static const String appName = 'VivahBio';
  static const String appVersion = '1.0.0';

  static const String hiveBiodataBox = 'biodata_box';
  static const String hiveSettingsBox = 'settings_box';
  static const String hiveTemplatesBox = 'templates_box';
  static const String hiveAuthBox = 'auth_box';

  static const int biodataTypeId = 0;
  static const int themeConfigTypeId = 1;
  static const int userSettingsTypeId = 2;
  static const int customFieldTypeId = 3;
  static const int photoInfoTypeId = 4;
  static const int userTypeId = 5;

  static const Duration shortAnim = Duration(milliseconds: 200);
  static const Duration mediumAnim = Duration(milliseconds: 350);
  static const Duration longAnim = Duration(milliseconds: 500);

  static const int defaultPageSize = 20;
  static const int maxFreeBiodatas = 3;
}
