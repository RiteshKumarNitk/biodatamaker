import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
@HiveType(typeId: 5)
class User with _$User {
  const factory User({
    @HiveField(0) required String id,
    @HiveField(1) @Default('') String name,
    @HiveField(2) @Default('') String email,
    @HiveField(3) @Default('') String phone,
    @HiveField(4) @Default('') String photoUrl,
    @HiveField(5) @Default(false) bool isGuest,
    @HiveField(6) required DateTime createdAt,
    @HiveField(7) required DateTime lastLoginAt,
    @HiveField(8) @Default(0) int loginCount,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
