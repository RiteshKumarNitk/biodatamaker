import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import 'photo_info.dart';
import 'custom_field.dart';
import 'sibling.dart';

part 'biodata.freezed.dart';
part 'biodata.g.dart';

@freezed
@HiveType(typeId: 0)
class Biodata with _$Biodata {
  const factory Biodata({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required DateTime createdAt,
    @HiveField(3) required DateTime updatedAt,
    @HiveField(4) @Default('') String templateId,
    @HiveField(5) @Default(false) bool isFavorite,
    @HiveField(6) @Default(false) bool isArchived,
    @HiveField(7) @Default(true) bool isDraft,
    @HiveField(8) @Default(0) int downloadCount,
    @HiveField(9) @Default('') String fullName,
    @HiveField(10) @Default('') String gender,
    @HiveField(11) @Default('') String dateOfBirth,
    @HiveField(12) @Default('') String age,
    @HiveField(13) @Default('') String height,
    @HiveField(14) @Default('') String weight,
    @HiveField(15) @Default('') String religion,
    @HiveField(16) @Default('') String caste,
    @HiveField(17) @Default('') String subCaste,
    @HiveField(18) @Default('') String motherTongue,
    @HiveField(19) @Default('') String maritalStatus,
    @HiveField(20) @Default('') String bloodGroup,
    @HiveField(21) @Default('') String complexion,
    @HiveField(22) @Default('') String manglik,
    @HiveField(23) @Default('') String horoscope,
    @HiveField(24) @Default('') String rashi,
    @HiveField(25) @Default('') String nakshatra,
    @HiveField(26) @Default('') String gotra,
    @HiveField(27) @Default('') String birthPlace,
    @HiveField(28) @Default('') String birthTime,
    @HiveField(29) @Default('') String aboutMe,
    @HiveField(30) @Default('') String qualification,
    @HiveField(31) @Default('') String college,
    @HiveField(32) @Default('') String university,
    @HiveField(33) @Default('') String occupation,
    @HiveField(34) @Default('') String company,
    @HiveField(35) @Default('') String business,
    @HiveField(36) @Default('') String designation,
    @HiveField(37) @Default('') String annualIncome,
    @HiveField(38) @Default('') String fatherName,
    @HiveField(39) @Default('') String fatherOccupation,
    @HiveField(40) @Default('') String motherName,
    @HiveField(41) @Default('') String motherOccupation,
    @HiveField(42) @Default('') String brothers,
    @HiveField(43) @Default('') String sisters,
    @HiveField(44) @Default('') String familyType,
    @HiveField(45) @Default('') String familyValues,
    @HiveField(46) @Default('') String nativePlace,
    @HiveField(47) @Default('') String diet,
    @HiveField(48) @Default('') String smoking,
    @HiveField(49) @Default('') String drinking,
    @HiveField(50) @Default('') String languages,
    @HiveField(51) @Default('') String hobbies,
    @HiveField(52) @Default('') String personality,
    @HiveField(53) @Default('') String mobile,
    @HiveField(54) @Default('') String whatsapp,
    @HiveField(55) @Default('') String email,
    @HiveField(56) @Default('') String address,
    @HiveField(57) @Default('') String city,
    @HiveField(58) @Default('') String state,
    @HiveField(59) @Default('') String country,
    @HiveField(60) @Default('') String preferredAge,
    @HiveField(61) @Default('') String preferredHeight,
    @HiveField(62) @Default('') String preferredEducation,
    @HiveField(63) @Default('') String preferredOccupation,
    @HiveField(64) @Default('') String preferredReligion,
    @HiveField(65) @Default('') String preferredLocation,
    @HiveField(66) @Default('') String expectations,
    @HiveField(67) @Default(<PhotoInfo>[]) List<PhotoInfo> photos,
    @HiveField(68) @Default('') String profilePhotoPath,
    @HiveField(69) @Default(<CustomField>[]) List<CustomField> customFields,
    @HiveField(70) @Default(<Sibling>[]) List<Sibling> siblings,
    @HiveField(71) @Default('') String grandFatherName,
    @HiveField(72) @Default('') String grandFatherOccupation,
    @HiveField(73) @Default('') String grandMotherName,
    @HiveField(74) @Default('') String familyStatus,
    @HiveField(75) @Default('') String familyDescription,
    @HiveField(76) @Default('') String contactPerson,
    @HiveField(77) @Default('') String contactPersonRelation,
    @HiveField(78) @Default('') String alternateNumber,
    @HiveField(79) @Default('') String pinCode,
    @HiveField(80) @Default('') String selectedFontId,
    /// Owning user's id (empty for data created before multi-user support or
    /// by a guest who has since signed out). biodatas with an empty userId are
    /// treated as owned by everyone (legacy data), so nobody loses their
    /// biodatas after upgrading.
    @HiveField(81) @Default('') String userId,
  }) = _Biodata;

  factory Biodata.fromJson(Map<String, dynamic> json) => _$BiodataFromJson(json);
}
