import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

@freezed
@HiveType(typeId: 2)
class UserSettings with _$UserSettings {
  const factory UserSettings({
    @HiveField(0) required String id,
    @HiveField(1) @Default('system') String themeMode,
    @HiveField(2) @Default('en') String language,
    @HiveField(3) @Default('high') String pdfQuality,
    @HiveField(4) @Default('A4') String pdfPageSize,
    @HiveField(5) @Default(true) bool autoSave,
    @HiveField(6) @Default(false) bool cloudBackupEnabled,
    @HiveField(7) @Default('') String lastBackupId,
    @HiveField(8) @Default(0) int totalBiodatasCreated,
    @HiveField(9) @Default('free') String subscriptionTier,
    @HiveField(10) DateTime? subscriptionExpiresAt,
    @HiveField(11) @Default(false) bool isWatermarkRemoved,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) => _$UserSettingsFromJson(json);
}
