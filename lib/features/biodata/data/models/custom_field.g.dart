// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_field.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomFieldAdapter extends TypeAdapter<CustomField> {
  @override
  final int typeId = 3;

  @override
  CustomField read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomField(
      id: fields[0] as String,
      section: fields[1] as String,
      label: fields[2] as String,
      value: fields[3] as String,
      order: fields[4] as int,
      isPremium: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CustomField obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.section)
      ..writeByte(2)
      ..write(obj.label)
      ..writeByte(3)
      ..write(obj.value)
      ..writeByte(4)
      ..write(obj.order)
      ..writeByte(5)
      ..write(obj.isPremium);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomFieldAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomFieldImpl _$$CustomFieldImplFromJson(Map<String, dynamic> json) =>
    _$CustomFieldImpl(
      id: json['id'] as String,
      section: json['section'] as String,
      label: json['label'] as String,
      value: json['value'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      isPremium: json['isPremium'] as bool? ?? false,
    );

Map<String, dynamic> _$$CustomFieldImplToJson(_$CustomFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'section': instance.section,
      'label': instance.label,
      'value': instance.value,
      'order': instance.order,
      'isPremium': instance.isPremium,
    };
