// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sibling.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SiblingAdapter extends TypeAdapter<Sibling> {
  @override
  final int typeId = 6;

  @override
  Sibling read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sibling(
      id: fields[0] as String,
      relationship: fields[1] as String,
      name: fields[2] as String,
      occupation: fields[3] as String,
      maritalStatus: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Sibling obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.relationship)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.occupation)
      ..writeByte(4)
      ..write(obj.maritalStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SiblingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SiblingImpl _$$SiblingImplFromJson(Map<String, dynamic> json) =>
    _$SiblingImpl(
      id: json['id'] as String,
      relationship: json['relationship'] as String? ?? 'Brother',
      name: json['name'] as String? ?? '',
      occupation: json['occupation'] as String? ?? '',
      maritalStatus: json['maritalStatus'] as String? ?? '',
    );

Map<String, dynamic> _$$SiblingImplToJson(_$SiblingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'relationship': instance.relationship,
      'name': instance.name,
      'occupation': instance.occupation,
      'maritalStatus': instance.maritalStatus,
    };
