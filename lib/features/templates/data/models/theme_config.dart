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
    @HiveField(3) @Default(false) bool isPremium,
    @HiveField(4) @Default(0xFFC62828) int primaryColor,
    @HiveField(5) @Default(0xFFFFB300) int secondaryColor,
    @HiveField(6) @Default(0xFFFFFFFF) int backgroundColor,
    @HiveField(7) @Default(0xFF212121) int textColor,
    @HiveField(8) @Default(0xFF757575) int subtitleColor,
    @HiveField(9) @Default('Playfair Display') String headingFont,
    @HiveField(10) @Default('Poppins') String bodyFont,
    @HiveField(11) @Default(24.0) double headingFontSize,
    @HiveField(12) @Default(14.0) double bodyFontSize,
    @HiveField(13) @Default('circle') String photoShape,
    @HiveField(14) @Default('ornate') String borderStyle,
    @HiveField(15) @Default(16.0) double sectionSpacing,
    @HiveField(16) @Default(8.0) double fieldSpacing,
    @HiveField(17) @Default(20.0) double margin,
    @HiveField(18) @Default('mandala') String headerDecoration,
    @HiveField(19) @Default('floral') String footerDecoration,
    @HiveField(20) @Default('minimal') String dividerStyle,
    @HiveField(21) @Default(false) bool showWatermark,
    @HiveField(22) @Default('') String watermarkText,
    @HiveField(23) @Default(<String>['personal','education','family','lifestyle','contact','partner_preference']) List<String> sectionOrder,
    @HiveField(24) @Default(<String>[]) List<String> hiddenFields,
    @HiveField(25) @Default(<String, String>{}) Map<String, String> labelOverrides,
    @HiveField(26) @Default('outline') String iconStyle,
    @HiveField(27) @Default('') String backgroundImage,
    @HiveField(28) @Default('') String borderImage,
    @HiveField(29) @Default('') String watermarkImage,
    @HiveField(30) @Default(true) bool isPublished,
    @HiveField(31) @Default(0) int displayOrder,
    // --- Image-based background template layout (only consulted when
    // backgroundImage is non-empty; see lib/shared/widgets/biodata_renderer.dart) ---
    @HiveField(32) @Default('reuse') String continuationBackgroundMode, // 'none' | 'reuse' | 'separate'
    @HiveField(33) @Default('') String continuationBackgroundImage,
    @HiveField(34) @Default(40.0) double photoRectLeft,
    @HiveField(35) @Default(40.0) double photoRectTop,
    @HiveField(36) @Default(100.0) double photoRectWidth,
    @HiveField(37) @Default(120.0) double photoRectHeight,
    @HiveField(38) @Default(40.0) double contentAreaLeft,
    @HiveField(39) @Default(160.0) double contentAreaTop,
    @HiveField(40) @Default(40.0) double contentAreaRight,
    @HiveField(41) @Default(40.0) double contentAreaBottom,
    
    // --- Phase 1 Layout Engine Configs ---
    @HiveField(42) @Default('traditional_row') String layoutStyle, // 'traditional_row' | 'centered_block' | 'split_columns'
    @HiveField(43) @Default('left') String headingAlignment, // 'left' | 'center' | 'right'
    @HiveField(44) @Default(40.0) double continuationContentAreaTop, // Prevents page 2 overlap
    @HiveField(45) @Default(10.0) double minFontSize,
    @HiveField(46) @Default(24.0) double maxFontSize,
    
    // --- Phase 2 Header & Data Representation Configs ---
    @HiveField(47) @Default(true) bool showColon,
    @HiveField(48) @Default('center') String headerAlignment, // 'left' | 'center' | 'right'
    @HiveField(49) @Default(0.0) double headerPaddingLeft, // Pushes header text to the right of the photo
    @HiveField(50) @Default(0.0) double headerHeight, // Ensures content clears the photo vertically
  }) = _ThemeConfig;

  factory ThemeConfig.fromJson(Map<String, dynamic> json) => _$ThemeConfigFromJson(json);
}
