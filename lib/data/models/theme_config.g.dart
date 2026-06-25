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
      primaryColor: fields[3] as int,
      secondaryColor: fields[4] as int,
      backgroundColor: fields[5] as int,
      textColor: fields[6] as int,
      subtitleColor: fields[7] as int,
      headingFont: fields[8] as String,
      bodyFont: fields[9] as String,
      headingFontSize: fields[10] as double,
      bodyFontSize: fields[11] as double,
      photoShape: fields[12] as String,
      borderStyle: fields[13] as String,
      sectionSpacing: fields[14] as double,
      fieldSpacing: fields[15] as double,
      margin: fields[16] as double,
      headerDecoration: fields[17] as String,
      footerDecoration: fields[18] as String,
      dividerStyle: fields[19] as String,
      showWatermark: fields[20] as bool,
      watermarkText: fields[21] as String,
      sectionOrder: (fields[22] as List).cast<String>(),
      hiddenFields: (fields[23] as List).cast<String>(),
      labelOverrides: (fields[24] as Map).cast<String, String>(),
      iconStyle: fields[25] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeConfig obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.primaryColor)
      ..writeByte(4)
      ..write(obj.secondaryColor)
      ..writeByte(5)
      ..write(obj.backgroundColor)
      ..writeByte(6)
      ..write(obj.textColor)
      ..writeByte(7)
      ..write(obj.subtitleColor)
      ..writeByte(8)
      ..write(obj.headingFont)
      ..writeByte(9)
      ..write(obj.bodyFont)
      ..writeByte(10)
      ..write(obj.headingFontSize)
      ..writeByte(11)
      ..write(obj.bodyFontSize)
      ..writeByte(12)
      ..write(obj.photoShape)
      ..writeByte(13)
      ..write(obj.borderStyle)
      ..writeByte(14)
      ..write(obj.sectionSpacing)
      ..writeByte(15)
      ..write(obj.fieldSpacing)
      ..writeByte(16)
      ..write(obj.margin)
      ..writeByte(17)
      ..write(obj.headerDecoration)
      ..writeByte(18)
      ..write(obj.footerDecoration)
      ..writeByte(19)
      ..write(obj.dividerStyle)
      ..writeByte(20)
      ..write(obj.showWatermark)
      ..writeByte(21)
      ..write(obj.watermarkText)
      ..writeByte(22)
      ..write(obj.sectionOrder)
      ..writeByte(23)
      ..write(obj.hiddenFields)
      ..writeByte(24)
      ..write(obj.labelOverrides)
      ..writeByte(25)
      ..write(obj.iconStyle);
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
          const [
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
          const [],
      labelOverrides: (json['labelOverrides'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      iconStyle: json['iconStyle'] as String? ?? 'outline',
    );

Map<String, dynamic> _$$ThemeConfigImplToJson(_$ThemeConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
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
    };
