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
      id: fields[0] as String,
      themeMode: fields[1] as String,
      language: fields[2] as String,
      pdfQuality: fields[3] as String,
      pdfPageSize: fields[4] as String,
      autoSave: fields[5] as bool,
      cloudBackupEnabled: fields[6] as bool,
      lastBackupId: fields[7] as String,
      totalBiodatasCreated: fields[8] as int,
      subscriptionTier: fields[9] as String,
      subscriptionExpiresAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.themeMode)
      ..writeByte(2)
      ..write(obj.language)
      ..writeByte(3)
      ..write(obj.pdfQuality)
      ..writeByte(4)
      ..write(obj.pdfPageSize)
      ..writeByte(5)
      ..write(obj.autoSave)
      ..writeByte(6)
      ..write(obj.cloudBackupEnabled)
      ..writeByte(7)
      ..write(obj.lastBackupId)
      ..writeByte(8)
      ..write(obj.totalBiodatasCreated)
      ..writeByte(9)
      ..write(obj.subscriptionTier)
      ..writeByte(10)
      ..write(obj.subscriptionExpiresAt);
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
      id: json['id'] as String,
      themeMode: json['themeMode'] as String? ?? 'system',
      language: json['language'] as String? ?? 'en',
      pdfQuality: json['pdfQuality'] as String? ?? 'high',
      pdfPageSize: json['pdfPageSize'] as String? ?? 'A4',
      autoSave: json['autoSave'] as bool? ?? true,
      cloudBackupEnabled: json['cloudBackupEnabled'] as bool? ?? false,
      lastBackupId: json['lastBackupId'] as String? ?? '',
      totalBiodatasCreated:
          (json['totalBiodatasCreated'] as num?)?.toInt() ?? 0,
      subscriptionTier: json['subscriptionTier'] as String? ?? 'free',
      subscriptionExpiresAt: json['subscriptionExpiresAt'] == null
          ? null
          : DateTime.parse(json['subscriptionExpiresAt'] as String),
    );

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'themeMode': instance.themeMode,
      'language': instance.language,
      'pdfQuality': instance.pdfQuality,
      'pdfPageSize': instance.pdfPageSize,
      'autoSave': instance.autoSave,
      'cloudBackupEnabled': instance.cloudBackupEnabled,
      'lastBackupId': instance.lastBackupId,
      'totalBiodatasCreated': instance.totalBiodatasCreated,
      'subscriptionTier': instance.subscriptionTier,
      'subscriptionExpiresAt':
          instance.subscriptionExpiresAt?.toIso8601String(),
    };
