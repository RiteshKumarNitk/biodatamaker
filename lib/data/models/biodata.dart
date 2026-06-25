import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'custom_field.dart';
import 'photo_info.dart';

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

    // Personal
    @HiveField(7) @Default('') String fullName,
    @HiveField(8) @Default('') String gender,
    @HiveField(9) DateTime? dateOfBirth,
    @HiveField(10) @Default(0) int age,
    @HiveField(11) @Default('') String height,
    @HiveField(12) @Default('') String weight,
    @HiveField(13) @Default('') String religion,
    @HiveField(14) @Default('') String caste,
    @HiveField(15) @Default('') String subCaste,
    @HiveField(16) @Default('') String motherTongue,
    @HiveField(17) @Default('') String maritalStatus,
    @HiveField(18) @Default('') String bloodGroup,
    @HiveField(19) @Default('') String complexion,
    @HiveField(20) @Default('') String manglik,
    @HiveField(21) @Default('') String horoscope,
    @HiveField(22) @Default('') String rashi,
    @HiveField(23) @Default('') String nakshatra,
    @HiveField(24) @Default('') String gotra,
    @HiveField(25) @Default('') String birthPlace,
    @HiveField(26) @Default('') String birthTime,
    @HiveField(27) @Default('') String aboutMe,

    // Education
    @HiveField(28) @Default('') String qualification,
    @HiveField(29) @Default('') String college,
    @HiveField(30) @Default('') String university,
    @HiveField(31) @Default('') String occupation,
    @HiveField(32) @Default('') String company,
    @HiveField(33) @Default('') String business,
    @HiveField(34) @Default('') String designation,
    @HiveField(35) @Default('') String annualIncome,

    // Family
    @HiveField(36) @Default('') String fatherName,
    @HiveField(37) @Default('') String fatherOccupation,
    @HiveField(38) @Default('') String motherName,
    @HiveField(39) @Default('') String motherOccupation,
    @HiveField(40) @Default('') String brothers,
    @HiveField(41) @Default('') String sisters,
    @HiveField(42) @Default('') String familyType,
    @HiveField(43) @Default('') String familyValues,
    @HiveField(44) @Default('') String nativePlace,

    // Lifestyle
    @HiveField(45) @Default('') String diet,
    @HiveField(46) @Default('') String smoking,
    @HiveField(47) @Default('') String drinking,
    @HiveField(48) @Default('') String languages,
    @HiveField(49) @Default('') String hobbies,
    @HiveField(50) @Default('') String personality,

    // Contact
    @HiveField(51) @Default('') String mobile,
    @HiveField(52) @Default('') String whatsapp,
    @HiveField(53) @Default('') String email,
    @HiveField(54) @Default('') String address,
    @HiveField(55) @Default('') String city,
    @HiveField(56) @Default('') String state,
    @HiveField(57) @Default('') String country,

    // Partner Preference
    @HiveField(58) @Default('') String preferredAge,
    @HiveField(59) @Default('') String preferredHeight,
    @HiveField(60) @Default('') String preferredEducation,
    @HiveField(61) @Default('') String preferredOccupation,
    @HiveField(62) @Default('') String preferredReligion,
    @HiveField(63) @Default('') String preferredLocation,
    @HiveField(64) @Default('') String expectations,

    // Photos
    @HiveField(65) @Default([]) List<PhotoInfo> photos,
    @HiveField(66) @Default('') String profilePhotoPath,

    // Custom Fields
    @HiveField(67) @Default([]) List<CustomField> customFields,
  }) = _Biodata;

  factory Biodata.fromJson(Map<String, dynamic> json) =>
      _$BiodataFromJson(json);
}
