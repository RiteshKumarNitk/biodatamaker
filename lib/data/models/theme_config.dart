import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'theme_config.freezed.dart';
part 'theme_config.g.dart';

@freezed
@HiveType(typeId: 1)
class ThemeConfig with _$ThemeConfig {
  const factory ThemeConfig({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String category,

    // Colors
    @HiveField(3) @Default(0xFFC62828) int primaryColor,
    @HiveField(4) @Default(0xFFFFB300) int secondaryColor,
    @HiveField(5) @Default(0xFFFFFFFF) int backgroundColor,
    @HiveField(6) @Default(0xFF212121) int textColor,
    @HiveField(7) @Default(0xFF757575) int subtitleColor,

    // Fonts
    @HiveField(8) @Default('Playfair Display') String headingFont,
    @HiveField(9) @Default('Poppins') String bodyFont,
    @HiveField(10) @Default(24.0) double headingFontSize,
    @HiveField(11) @Default(14.0) double bodyFontSize,

    // Layout
    @HiveField(12) @Default('circle') String photoShape,
    @HiveField(13) @Default('ornate') String borderStyle,
    @HiveField(14) @Default(16.0) double sectionSpacing,
    @HiveField(15) @Default(8.0) double fieldSpacing,
    @HiveField(16) @Default(20.0) double margin,

    // Decorations
    @HiveField(17) @Default('mandala') String headerDecoration,
    @HiveField(18) @Default('floral') String footerDecoration,
    @HiveField(19) @Default('minimal') String dividerStyle,
    @HiveField(20) @Default(false) bool showWatermark,
    @HiveField(21) @Default('') String watermarkText,

    // Section order
    @HiveField(22)
    @Default([
      'personal',
      'education',
      'family',
      'lifestyle',
      'contact',
      'partner_preference',
    ])
    List<String> sectionOrder,

    // Hidden fields
    @HiveField(23) @Default([]) List<String> hiddenFields,

    // Custom label overrides
    @HiveField(24) @Default({}) Map<String, String> labelOverrides,

    // Icon style
    @HiveField(25) @Default('outline') String iconStyle,
  }) = _ThemeConfig;

  factory ThemeConfig.fromJson(Map<String, dynamic> json) =>
      _$ThemeConfigFromJson(json);
}
