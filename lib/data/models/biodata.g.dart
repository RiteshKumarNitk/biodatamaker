// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biodata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BiodataAdapter extends TypeAdapter<Biodata> {
  @override
  final int typeId = 0;

  @override
  Biodata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Biodata(
      id: fields[0] as String,
      name: fields[1] as String,
      createdAt: fields[2] as DateTime,
      updatedAt: fields[3] as DateTime,
      templateId: fields[4] as String,
      isFavorite: fields[5] as bool,
      isArchived: fields[6] as bool,
      fullName: fields[7] as String,
      gender: fields[8] as String,
      dateOfBirth: fields[9] as DateTime?,
      age: fields[10] as int,
      height: fields[11] as String,
      weight: fields[12] as String,
      religion: fields[13] as String,
      caste: fields[14] as String,
      subCaste: fields[15] as String,
      motherTongue: fields[16] as String,
      maritalStatus: fields[17] as String,
      bloodGroup: fields[18] as String,
      complexion: fields[19] as String,
      manglik: fields[20] as String,
      horoscope: fields[21] as String,
      rashi: fields[22] as String,
      nakshatra: fields[23] as String,
      gotra: fields[24] as String,
      birthPlace: fields[25] as String,
      birthTime: fields[26] as String,
      aboutMe: fields[27] as String,
      qualification: fields[28] as String,
      college: fields[29] as String,
      university: fields[30] as String,
      occupation: fields[31] as String,
      company: fields[32] as String,
      business: fields[33] as String,
      designation: fields[34] as String,
      annualIncome: fields[35] as String,
      fatherName: fields[36] as String,
      fatherOccupation: fields[37] as String,
      motherName: fields[38] as String,
      motherOccupation: fields[39] as String,
      brothers: fields[40] as String,
      sisters: fields[41] as String,
      familyType: fields[42] as String,
      familyValues: fields[43] as String,
      nativePlace: fields[44] as String,
      diet: fields[45] as String,
      smoking: fields[46] as String,
      drinking: fields[47] as String,
      languages: fields[48] as String,
      hobbies: fields[49] as String,
      personality: fields[50] as String,
      mobile: fields[51] as String,
      whatsapp: fields[52] as String,
      email: fields[53] as String,
      address: fields[54] as String,
      city: fields[55] as String,
      state: fields[56] as String,
      country: fields[57] as String,
      preferredAge: fields[58] as String,
      preferredHeight: fields[59] as String,
      preferredEducation: fields[60] as String,
      preferredOccupation: fields[61] as String,
      preferredReligion: fields[62] as String,
      preferredLocation: fields[63] as String,
      expectations: fields[64] as String,
      photos: (fields[65] as List).cast<PhotoInfo>(),
      profilePhotoPath: fields[66] as String,
      customFields: (fields[67] as List).cast<CustomField>(),
    );
  }

  @override
  void write(BinaryWriter writer, Biodata obj) {
    writer
      ..writeByte(68)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.templateId)
      ..writeByte(5)
      ..write(obj.isFavorite)
      ..writeByte(6)
      ..write(obj.isArchived)
      ..writeByte(7)
      ..write(obj.fullName)
      ..writeByte(8)
      ..write(obj.gender)
      ..writeByte(9)
      ..write(obj.dateOfBirth)
      ..writeByte(10)
      ..write(obj.age)
      ..writeByte(11)
      ..write(obj.height)
      ..writeByte(12)
      ..write(obj.weight)
      ..writeByte(13)
      ..write(obj.religion)
      ..writeByte(14)
      ..write(obj.caste)
      ..writeByte(15)
      ..write(obj.subCaste)
      ..writeByte(16)
      ..write(obj.motherTongue)
      ..writeByte(17)
      ..write(obj.maritalStatus)
      ..writeByte(18)
      ..write(obj.bloodGroup)
      ..writeByte(19)
      ..write(obj.complexion)
      ..writeByte(20)
      ..write(obj.manglik)
      ..writeByte(21)
      ..write(obj.horoscope)
      ..writeByte(22)
      ..write(obj.rashi)
      ..writeByte(23)
      ..write(obj.nakshatra)
      ..writeByte(24)
      ..write(obj.gotra)
      ..writeByte(25)
      ..write(obj.birthPlace)
      ..writeByte(26)
      ..write(obj.birthTime)
      ..writeByte(27)
      ..write(obj.aboutMe)
      ..writeByte(28)
      ..write(obj.qualification)
      ..writeByte(29)
      ..write(obj.college)
      ..writeByte(30)
      ..write(obj.university)
      ..writeByte(31)
      ..write(obj.occupation)
      ..writeByte(32)
      ..write(obj.company)
      ..writeByte(33)
      ..write(obj.business)
      ..writeByte(34)
      ..write(obj.designation)
      ..writeByte(35)
      ..write(obj.annualIncome)
      ..writeByte(36)
      ..write(obj.fatherName)
      ..writeByte(37)
      ..write(obj.fatherOccupation)
      ..writeByte(38)
      ..write(obj.motherName)
      ..writeByte(39)
      ..write(obj.motherOccupation)
      ..writeByte(40)
      ..write(obj.brothers)
      ..writeByte(41)
      ..write(obj.sisters)
      ..writeByte(42)
      ..write(obj.familyType)
      ..writeByte(43)
      ..write(obj.familyValues)
      ..writeByte(44)
      ..write(obj.nativePlace)
      ..writeByte(45)
      ..write(obj.diet)
      ..writeByte(46)
      ..write(obj.smoking)
      ..writeByte(47)
      ..write(obj.drinking)
      ..writeByte(48)
      ..write(obj.languages)
      ..writeByte(49)
      ..write(obj.hobbies)
      ..writeByte(50)
      ..write(obj.personality)
      ..writeByte(51)
      ..write(obj.mobile)
      ..writeByte(52)
      ..write(obj.whatsapp)
      ..writeByte(53)
      ..write(obj.email)
      ..writeByte(54)
      ..write(obj.address)
      ..writeByte(55)
      ..write(obj.city)
      ..writeByte(56)
      ..write(obj.state)
      ..writeByte(57)
      ..write(obj.country)
      ..writeByte(58)
      ..write(obj.preferredAge)
      ..writeByte(59)
      ..write(obj.preferredHeight)
      ..writeByte(60)
      ..write(obj.preferredEducation)
      ..writeByte(61)
      ..write(obj.preferredOccupation)
      ..writeByte(62)
      ..write(obj.preferredReligion)
      ..writeByte(63)
      ..write(obj.preferredLocation)
      ..writeByte(64)
      ..write(obj.expectations)
      ..writeByte(65)
      ..write(obj.photos)
      ..writeByte(66)
      ..write(obj.profilePhotoPath)
      ..writeByte(67)
      ..write(obj.customFields);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BiodataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BiodataImpl _$$BiodataImplFromJson(Map<String, dynamic> json) =>
    _$BiodataImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      templateId: json['templateId'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      fullName: json['fullName'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      age: (json['age'] as num?)?.toInt() ?? 0,
      height: json['height'] as String? ?? '',
      weight: json['weight'] as String? ?? '',
      religion: json['religion'] as String? ?? '',
      caste: json['caste'] as String? ?? '',
      subCaste: json['subCaste'] as String? ?? '',
      motherTongue: json['motherTongue'] as String? ?? '',
      maritalStatus: json['maritalStatus'] as String? ?? '',
      bloodGroup: json['bloodGroup'] as String? ?? '',
      complexion: json['complexion'] as String? ?? '',
      manglik: json['manglik'] as String? ?? '',
      horoscope: json['horoscope'] as String? ?? '',
      rashi: json['rashi'] as String? ?? '',
      nakshatra: json['nakshatra'] as String? ?? '',
      gotra: json['gotra'] as String? ?? '',
      birthPlace: json['birthPlace'] as String? ?? '',
      birthTime: json['birthTime'] as String? ?? '',
      aboutMe: json['aboutMe'] as String? ?? '',
      qualification: json['qualification'] as String? ?? '',
      college: json['college'] as String? ?? '',
      university: json['university'] as String? ?? '',
      occupation: json['occupation'] as String? ?? '',
      company: json['company'] as String? ?? '',
      business: json['business'] as String? ?? '',
      designation: json['designation'] as String? ?? '',
      annualIncome: json['annualIncome'] as String? ?? '',
      fatherName: json['fatherName'] as String? ?? '',
      fatherOccupation: json['fatherOccupation'] as String? ?? '',
      motherName: json['motherName'] as String? ?? '',
      motherOccupation: json['motherOccupation'] as String? ?? '',
      brothers: json['brothers'] as String? ?? '',
      sisters: json['sisters'] as String? ?? '',
      familyType: json['familyType'] as String? ?? '',
      familyValues: json['familyValues'] as String? ?? '',
      nativePlace: json['nativePlace'] as String? ?? '',
      diet: json['diet'] as String? ?? '',
      smoking: json['smoking'] as String? ?? '',
      drinking: json['drinking'] as String? ?? '',
      languages: json['languages'] as String? ?? '',
      hobbies: json['hobbies'] as String? ?? '',
      personality: json['personality'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      whatsapp: json['whatsapp'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      country: json['country'] as String? ?? '',
      preferredAge: json['preferredAge'] as String? ?? '',
      preferredHeight: json['preferredHeight'] as String? ?? '',
      preferredEducation: json['preferredEducation'] as String? ?? '',
      preferredOccupation: json['preferredOccupation'] as String? ?? '',
      preferredReligion: json['preferredReligion'] as String? ?? '',
      preferredLocation: json['preferredLocation'] as String? ?? '',
      expectations: json['expectations'] as String? ?? '',
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => PhotoInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      profilePhotoPath: json['profilePhotoPath'] as String? ?? '',
      customFields: (json['customFields'] as List<dynamic>?)
              ?.map((e) => CustomField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BiodataImplToJson(_$BiodataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'templateId': instance.templateId,
      'isFavorite': instance.isFavorite,
      'isArchived': instance.isArchived,
      'fullName': instance.fullName,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'age': instance.age,
      'height': instance.height,
      'weight': instance.weight,
      'religion': instance.religion,
      'caste': instance.caste,
      'subCaste': instance.subCaste,
      'motherTongue': instance.motherTongue,
      'maritalStatus': instance.maritalStatus,
      'bloodGroup': instance.bloodGroup,
      'complexion': instance.complexion,
      'manglik': instance.manglik,
      'horoscope': instance.horoscope,
      'rashi': instance.rashi,
      'nakshatra': instance.nakshatra,
      'gotra': instance.gotra,
      'birthPlace': instance.birthPlace,
      'birthTime': instance.birthTime,
      'aboutMe': instance.aboutMe,
      'qualification': instance.qualification,
      'college': instance.college,
      'university': instance.university,
      'occupation': instance.occupation,
      'company': instance.company,
      'business': instance.business,
      'designation': instance.designation,
      'annualIncome': instance.annualIncome,
      'fatherName': instance.fatherName,
      'fatherOccupation': instance.fatherOccupation,
      'motherName': instance.motherName,
      'motherOccupation': instance.motherOccupation,
      'brothers': instance.brothers,
      'sisters': instance.sisters,
      'familyType': instance.familyType,
      'familyValues': instance.familyValues,
      'nativePlace': instance.nativePlace,
      'diet': instance.diet,
      'smoking': instance.smoking,
      'drinking': instance.drinking,
      'languages': instance.languages,
      'hobbies': instance.hobbies,
      'personality': instance.personality,
      'mobile': instance.mobile,
      'whatsapp': instance.whatsapp,
      'email': instance.email,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'preferredAge': instance.preferredAge,
      'preferredHeight': instance.preferredHeight,
      'preferredEducation': instance.preferredEducation,
      'preferredOccupation': instance.preferredOccupation,
      'preferredReligion': instance.preferredReligion,
      'preferredLocation': instance.preferredLocation,
      'expectations': instance.expectations,
      'photos': instance.photos,
      'profilePhotoPath': instance.profilePhotoPath,
      'customFields': instance.customFields,
    };
