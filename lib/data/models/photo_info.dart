import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'photo_info.freezed.dart';
part 'photo_info.g.dart';

@freezed
@HiveType(typeId: 4)
class PhotoInfo with _$PhotoInfo {
  const factory PhotoInfo({
    @HiveField(0) required String id,
    @HiveField(1) required String path,
    @HiveField(2) @Default(0) int order,
    @HiveField(3) @Default(false) bool isProfilePhoto,
  }) = _PhotoInfo;

  factory PhotoInfo.fromJson(Map<String, dynamic> json) =>
      _$PhotoInfoFromJson(json);
}
