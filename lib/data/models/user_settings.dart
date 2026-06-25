import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

@freezed
@HiveType(typeId: 2)
class UserSettings with _$UserSettings {
  const factory UserSettings({
    @HiveField(0) @Default('system') String themeMode,
    @HiveField(1) @Default('en') String language,
    @HiveField(2) @Default('high') String pdfQuality,
    @HiveField(3) @Default('A4') String pdfPageSize,
    @HiveField(4) @Default(true) bool autoSave,
    @HiveField(5) @Default(false) bool cloudBackupEnabled,
    @HiveField(6) @Default('') String lastBackupId,
    @HiveField(7) @Default(0) int totalBiodatasCreated,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}
