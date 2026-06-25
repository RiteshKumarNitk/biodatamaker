// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingsAdapter extends TypeAdapter<UserSettings> {
  @override
  final int typeId = 2;

  @override
  UserSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettings(
      themeMode: fields[0] as String,
      language: fields[1] as String,
      pdfQuality: fields[2] as String,
      pdfPageSize: fields[3] as String,
      autoSave: fields[4] as bool,
      cloudBackupEnabled: fields[5] as bool,
      lastBackupId: fields[6] as String,
      totalBiodatasCreated: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.themeMode)
      ..writeByte(1)
      ..write(obj.language)
      ..writeByte(2)
      ..write(obj.pdfQuality)
      ..writeByte(3)
      ..write(obj.pdfPageSize)
      ..writeByte(4)
      ..write(obj.autoSave)
      ..writeByte(5)
      ..write(obj.cloudBackupEnabled)
      ..writeByte(6)
      ..write(obj.lastBackupId)
      ..writeByte(7)
      ..write(obj.totalBiodatasCreated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSettingsImpl _$$UserSettingsImplFromJson(Map<String, dynamic> json) =>
    _$UserSettingsImpl(
      themeMode: json['themeMode'] as String? ?? 'system',
      language: json['language'] as String? ?? 'en',
      pdfQuality: json['pdfQuality'] as String? ?? 'high',
      pdfPageSize: json['pdfPageSize'] as String? ?? 'A4',
      autoSave: json['autoSave'] as bool? ?? true,
      cloudBackupEnabled: json['cloudBackupEnabled'] as bool? ?? false,
      lastBackupId: json['lastBackupId'] as String? ?? '',
      totalBiodatasCreated:
          (json['totalBiodatasCreated'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'themeMode': instance.themeMode,
      'language': instance.language,
      'pdfQuality': instance.pdfQuality,
      'pdfPageSize': instance.pdfPageSize,
      'autoSave': instance.autoSave,
      'cloudBackupEnabled': instance.cloudBackupEnabled,
      'lastBackupId': instance.lastBackupId,
      'totalBiodatasCreated': instance.totalBiodatasCreated,
    };
