import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'sibling.freezed.dart';
part 'sibling.g.dart';

@freezed
@HiveType(typeId: 6)
class Sibling with _$Sibling {
  const factory Sibling({
    @HiveField(0) required String id,
    @HiveField(1) @Default('Brother') String relationship,
    @HiveField(2) @Default('') String name,
    @HiveField(3) @Default('') String occupation,
    @HiveField(4) @Default('') String maritalStatus,
  }) = _Sibling;

  factory Sibling.fromJson(Map<String, dynamic> json) => _$SiblingFromJson(json);
}
