import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'custom_field.freezed.dart';
part 'custom_field.g.dart';

@freezed
@HiveType(typeId: 3)
class CustomField with _$CustomField {
  const factory CustomField({
    @HiveField(0) required String id,
    @HiveField(1) required String section,
    @HiveField(2) required String label,
    @HiveField(3) @Default('') String value,
    @HiveField(4) @Default(0) int order,
    @HiveField(5) @Default(false) bool isPremium,
  }) = _CustomField;

  factory CustomField.fromJson(Map<String, dynamic> json) => _$CustomFieldFromJson(json);
}
