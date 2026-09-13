// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeConfigAdapter extends TypeAdapter<ThemeConfig> {
  @override
  final int typeId = 1;

  @override
  ThemeConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeConfig(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      isPremium: fields[3] as bool,
      primaryColor: fields[4] as int,
      secondaryColor: fields[5] as int,
      backgroundColor: fields[6] as int,
      textColor: fields[7] as int,
      subtitleColor: fields[8] as int,
      headingFont: fields[9] as String,
      bodyFont: fields[10] as String,
      headingFontSize: fields[11] as double,
      bodyFontSize: fields[12] as double,
      photoShape: fields[13] as String,
      borderStyle: fields[14] as String,
      sectionSpacing: fields[15] as double,
      fieldSpacing: fields[16] as double,
      margin: fields[17] as double,
      headerDecoration: fields[18] as String,
      footerDecoration: fields[19] as String,
      dividerStyle: fields[20] as String,
      showWatermark: fields[21] as bool,
      watermarkText: fields[22] as String,
      sectionOrder: (fields[23] as List).cast<String>(),
      hiddenFields: (fields[24] as List).cast<String>(),
      labelOverrides: (fields[25] as Map).cast<String, String>(),
      iconStyle: fields[26] as String,
      backgroundImage: fields[27] as String,
      borderImage: fields[28] as String,
      watermarkImage: fields[29] as String,
      isPublished: fields[30] as bool,
      displayOrder: fields[31] as int,
      // Fields 32+ were added later; tolerate records saved by older app
      // versions that never wrote them (null -> default).
      continuationBackgroundMode: fields[32] as String? ?? 'reuse',
      continuationBackgroundImage: fields[33] as String? ?? '',
      photoRectLeft: fields[34] as double? ?? 40.0,
      photoRectTop: fields[35] as double? ?? 40.0,
      photoRectWidth: fields[36] as double? ?? 100.0,
      photoRectHeight: fields[37] as double? ?? 120.0,
      contentAreaLeft: fields[38] as double? ?? 40.0,
      contentAreaTop: fields[39] as double? ?? 160.0,
      contentAreaRight: fields[40] as double? ?? 40.0,
      contentAreaBottom: fields[41] as double? ?? 40.0,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeConfig obj) {
    writer
      ..writeByte(42)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.isPremium)
      ..writeByte(4)
      ..write(obj.primaryColor)
      ..writeByte(5)
      ..write(obj.secondaryColor)
      ..writeByte(6)
      ..write(obj.backgroundColor)
      ..writeByte(7)
      ..write(obj.textColor)
      ..writeByte(8)
      ..write(obj.subtitleColor)
      ..writeByte(9)
      ..write(obj.headingFont)
      ..writeByte(10)
      ..write(obj.bodyFont)
      ..writeByte(11)
      ..write(obj.headingFontSize)
      ..writeByte(12)
      ..write(obj.bodyFontSize)
      ..writeByte(13)
      ..write(obj.photoShape)
      ..writeByte(14)
      ..write(obj.borderStyle)
      ..writeByte(15)
      ..write(obj.sectionSpacing)
      ..writeByte(16)
      ..write(obj.fieldSpacing)
      ..writeByte(17)
      ..write(obj.margin)
      ..writeByte(18)
      ..write(obj.headerDecoration)
      ..writeByte(19)
      ..write(obj.footerDecoration)
      ..writeByte(20)
      ..write(obj.dividerStyle)
      ..writeByte(21)
      ..write(obj.showWatermark)
      ..writeByte(22)
      ..write(obj.watermarkText)
      ..writeByte(23)
      ..write(obj.sectionOrder)
      ..writeByte(24)
      ..write(obj.hiddenFields)
      ..writeByte(25)
      ..write(obj.labelOverrides)
      ..writeByte(26)
      ..write(obj.iconStyle)
      ..writeByte(27)
      ..write(obj.backgroundImage)
      ..writeByte(28)
      ..write(obj.borderImage)
      ..writeByte(29)
      ..write(obj.watermarkImage)
      ..writeByte(30)
      ..write(obj.isPublished)
      ..writeByte(31)
      ..write(obj.displayOrder)
      ..writeByte(32)
      ..write(obj.continuationBackgroundMode)
      ..writeByte(33)
      ..write(obj.continuationBackgroundImage)
      ..writeByte(34)
      ..write(obj.photoRectLeft)
      ..writeByte(35)
      ..write(obj.photoRectTop)
      ..writeByte(36)
      ..write(obj.photoRectWidth)
      ..writeByte(37)
      ..write(obj.photoRectHeight)
      ..writeByte(38)
      ..write(obj.contentAreaLeft)
      ..writeByte(39)
      ..write(obj.contentAreaTop)
      ..writeByte(40)
      ..write(obj.contentAreaRight)
      ..writeByte(41)
      ..write(obj.contentAreaBottom);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThemeConfigImpl _$$ThemeConfigImplFromJson(Map<String, dynamic> json) =>
    _$ThemeConfigImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      isPremium: json['isPremium'] as bool? ?? false,
      primaryColor: (json['primaryColor'] as num?)?.toInt() ?? 0xFFC62828,
      secondaryColor: (json['secondaryColor'] as num?)?.toInt() ?? 0xFFFFB300,
      backgroundColor: (json['backgroundColor'] as num?)?.toInt() ?? 0xFFFFFFFF,
      textColor: (json['textColor'] as num?)?.toInt() ?? 0xFF212121,
      subtitleColor: (json['subtitleColor'] as num?)?.toInt() ?? 0xFF757575,
      headingFont: json['headingFont'] as String? ?? 'Playfair Display',
      bodyFont: json['bodyFont'] as String? ?? 'Poppins',
      headingFontSize: (json['headingFontSize'] as num?)?.toDouble() ?? 24.0,
      bodyFontSize: (json['bodyFontSize'] as num?)?.toDouble() ?? 14.0,
      photoShape: json['photoShape'] as String? ?? 'circle',
      borderStyle: json['borderStyle'] as String? ?? 'ornate',
      sectionSpacing: (json['sectionSpacing'] as num?)?.toDouble() ?? 16.0,
      fieldSpacing: (json['fieldSpacing'] as num?)?.toDouble() ?? 8.0,
      margin: (json['margin'] as num?)?.toDouble() ?? 20.0,
      headerDecoration: json['headerDecoration'] as String? ?? 'mandala',
      footerDecoration: json['footerDecoration'] as String? ?? 'floral',
      dividerStyle: json['dividerStyle'] as String? ?? 'minimal',
      showWatermark: json['showWatermark'] as bool? ?? false,
      watermarkText: json['watermarkText'] as String? ?? '',
      sectionOrder: (json['sectionOrder'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[
            'personal',
            'education',
            'family',
            'lifestyle',
            'contact',
            'partner_preference'
          ],
      hiddenFields: (json['hiddenFields'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      labelOverrides: (json['labelOverrides'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      iconStyle: json['iconStyle'] as String? ?? 'outline',
      backgroundImage: json['backgroundImage'] as String? ?? '',
      borderImage: json['borderImage'] as String? ?? '',
      watermarkImage: json['watermarkImage'] as String? ?? '',
      isPublished: json['isPublished'] as bool? ?? true,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      continuationBackgroundMode:
          json['continuationBackgroundMode'] as String? ?? 'reuse',
      continuationBackgroundImage:
          json['continuationBackgroundImage'] as String? ?? '',
      photoRectLeft: (json['photoRectLeft'] as num?)?.toDouble() ?? 40.0,
      photoRectTop: (json['photoRectTop'] as num?)?.toDouble() ?? 40.0,
      photoRectWidth: (json['photoRectWidth'] as num?)?.toDouble() ?? 100.0,
      photoRectHeight: (json['photoRectHeight'] as num?)?.toDouble() ?? 120.0,
      contentAreaLeft: (json['contentAreaLeft'] as num?)?.toDouble() ?? 40.0,
      contentAreaTop: (json['contentAreaTop'] as num?)?.toDouble() ?? 160.0,
      contentAreaRight: (json['contentAreaRight'] as num?)?.toDouble() ?? 40.0,
      contentAreaBottom:
          (json['contentAreaBottom'] as num?)?.toDouble() ?? 40.0,
    );

Map<String, dynamic> _$$ThemeConfigImplToJson(_$ThemeConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'isPremium': instance.isPremium,
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
      'backgroundColor': instance.backgroundColor,
      'textColor': instance.textColor,
      'subtitleColor': instance.subtitleColor,
      'headingFont': instance.headingFont,
      'bodyFont': instance.bodyFont,
      'headingFontSize': instance.headingFontSize,
      'bodyFontSize': instance.bodyFontSize,
      'photoShape': instance.photoShape,
      'borderStyle': instance.borderStyle,
      'sectionSpacing': instance.sectionSpacing,
      'fieldSpacing': instance.fieldSpacing,
      'margin': instance.margin,
      'headerDecoration': instance.headerDecoration,
      'footerDecoration': instance.footerDecoration,
      'dividerStyle': instance.dividerStyle,
      'showWatermark': instance.showWatermark,
      'watermarkText': instance.watermarkText,
      'sectionOrder': instance.sectionOrder,
      'hiddenFields': instance.hiddenFields,
      'labelOverrides': instance.labelOverrides,
      'iconStyle': instance.iconStyle,
      'backgroundImage': instance.backgroundImage,
      'borderImage': instance.borderImage,
      'watermarkImage': instance.watermarkImage,
      'isPublished': instance.isPublished,
      'displayOrder': instance.displayOrder,
      'continuationBackgroundMode': instance.continuationBackgroundMode,
      'continuationBackgroundImage': instance.continuationBackgroundImage,
      'photoRectLeft': instance.photoRectLeft,
      'photoRectTop': instance.photoRectTop,
      'photoRectWidth': instance.photoRectWidth,
      'photoRectHeight': instance.photoRectHeight,
      'contentAreaLeft': instance.contentAreaLeft,
      'contentAreaTop': instance.contentAreaTop,
      'contentAreaRight': instance.contentAreaRight,
      'contentAreaBottom': instance.contentAreaBottom,
    };
