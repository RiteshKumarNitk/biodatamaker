// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhotoInfoAdapter extends TypeAdapter<PhotoInfo> {
  @override
  final int typeId = 4;

  @override
  PhotoInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhotoInfo(
      id: fields[0] as String,
      path: fields[1] as String,
      order: fields[2] as int,
      isProfilePhoto: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PhotoInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.order)
      ..writeByte(3)
      ..write(obj.isProfilePhoto);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhotoInfoImpl _$$PhotoInfoImplFromJson(Map<String, dynamic> json) =>
    _$PhotoInfoImpl(
      id: json['id'] as String,
      path: json['path'] as String,
      order: (json['order'] as num?)?.toInt() ?? 0,
      isProfilePhoto: json['isProfilePhoto'] as bool? ?? false,
    );

Map<String, dynamic> _$$PhotoInfoImplToJson(_$PhotoInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'order': instance.order,
      'isProfilePhoto': instance.isProfilePhoto,
    };
