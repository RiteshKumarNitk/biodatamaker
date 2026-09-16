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
      isDraft: fields[7] as bool,
      downloadCount: fields[8] as int,
      fullName: fields[9] as String,
      gender: fields[10] as String,
      dateOfBirth: fields[11] as String,
      age: fields[12] as String,
      height: fields[13] as String,
      weight: fields[14] as String,
      religion: fields[15] as String,
      caste: fields[16] as String,
      subCaste: fields[17] as String,
      motherTongue: fields[18] as String,
      maritalStatus: fields[19] as String,
      bloodGroup: fields[20] as String,
      complexion: fields[21] as String,
      manglik: fields[22] as String,
      horoscope: fields[23] as String,
      rashi: fields[24] as String,
      nakshatra: fields[25] as String,
      gotra: fields[26] as String,
      birthPlace: fields[27] as String,
      birthTime: fields[28] as String,
      aboutMe: fields[29] as String,
      qualification: fields[30] as String,
      college: fields[31] as String,
      university: fields[32] as String,
      occupation: fields[33] as String,
      company: fields[34] as String,
      business: fields[35] as String,
      designation: fields[36] as String,
      annualIncome: fields[37] as String,
      fatherName: fields[38] as String,
      fatherOccupation: fields[39] as String,
      motherName: fields[40] as String,
      motherOccupation: fields[41] as String,
      brothers: fields[42] as String,
      sisters: fields[43] as String,
      familyType: fields[44] as String,
      familyValues: fields[45] as String,
      nativePlace: fields[46] as String,
      diet: fields[47] as String,
      smoking: fields[48] as String,
      drinking: fields[49] as String,
      languages: fields[50] as String,
      hobbies: fields[51] as String,
      personality: fields[52] as String,
      mobile: fields[53] as String,
      whatsapp: fields[54] as String,
      email: fields[55] as String,
      address: fields[56] as String,
      city: fields[57] as String,
      state: fields[58] as String,
      country: fields[59] as String,
      preferredAge: fields[60] as String,
      preferredHeight: fields[61] as String,
      preferredEducation: fields[62] as String,
      preferredOccupation: fields[63] as String,
      preferredReligion: fields[64] as String,
      preferredLocation: fields[65] as String,
      expectations: fields[66] as String,
      photos: (fields[67] as List).cast<PhotoInfo>(),
      profilePhotoPath: fields[68] as String,
      customFields: (fields[69] as List).cast<CustomField>(),
      siblings: (fields[70] as List).cast<Sibling>(),
      grandFatherName: fields[71] as String,
      grandFatherOccupation: fields[72] as String,
      grandMotherName: fields[73] as String,
      familyStatus: fields[74] as String,
      familyDescription: fields[75] as String,
      contactPerson: fields[76] as String,
      contactPersonRelation: fields[77] as String,
      alternateNumber: fields[78] as String,
      pinCode: fields[79] as String,
      selectedFontId: fields[80] as String,
      userId: fields[81] == null ? '' : fields[81] as String,
      photoAlignment: fields[82] as String,
      headerIcon: fields[83] as String,
      customHeadingFontSize: fields[84] as double,
      customBodyFontSize: fields[85] as double,
      contentAlignment: fields[86] as String,
      showFooterLine: fields[87] as bool,
      customFieldSpacing: fields[88] as double,
      customSectionSpacing: fields[89] as double,
      customMargin: fields[90] as double,
      customPrimaryColor: fields[91] as int,
      customBackgroundColor: fields[92] as int,
      customPhotoShape: fields[93] as String,
      customPhotoSize: fields[94] as double,
      showPhotoBorder: fields[95] as bool,
      uppercaseHeadings: fields[96] as bool,
      boldLabels: fields[97] as bool,
      showColons: fields[98] as bool,
      customHeaderStyle: fields[99] as String,
      customHeadingAlignment: fields[100] as String,
      language: fields[101] as String,
      sectionOrder: (fields[102] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Biodata obj) {
    writer
      ..writeByte(103)
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
      ..write(obj.isDraft)
      ..writeByte(8)
      ..write(obj.downloadCount)
      ..writeByte(9)
      ..write(obj.fullName)
      ..writeByte(10)
      ..write(obj.gender)
      ..writeByte(11)
      ..write(obj.dateOfBirth)
      ..writeByte(12)
      ..write(obj.age)
      ..writeByte(13)
      ..write(obj.height)
      ..writeByte(14)
      ..write(obj.weight)
      ..writeByte(15)
      ..write(obj.religion)
      ..writeByte(16)
      ..write(obj.caste)
      ..writeByte(17)
      ..write(obj.subCaste)
      ..writeByte(18)
      ..write(obj.motherTongue)
      ..writeByte(19)
      ..write(obj.maritalStatus)
      ..writeByte(20)
      ..write(obj.bloodGroup)
      ..writeByte(21)
      ..write(obj.complexion)
      ..writeByte(22)
      ..write(obj.manglik)
      ..writeByte(23)
      ..write(obj.horoscope)
      ..writeByte(24)
      ..write(obj.rashi)
      ..writeByte(25)
      ..write(obj.nakshatra)
      ..writeByte(26)
      ..write(obj.gotra)
      ..writeByte(27)
      ..write(obj.birthPlace)
      ..writeByte(28)
      ..write(obj.birthTime)
      ..writeByte(29)
      ..write(obj.aboutMe)
      ..writeByte(30)
      ..write(obj.qualification)
      ..writeByte(31)
      ..write(obj.college)
      ..writeByte(32)
      ..write(obj.university)
      ..writeByte(33)
      ..write(obj.occupation)
      ..writeByte(34)
      ..write(obj.company)
      ..writeByte(35)
      ..write(obj.business)
      ..writeByte(36)
      ..write(obj.designation)
      ..writeByte(37)
      ..write(obj.annualIncome)
      ..writeByte(38)
      ..write(obj.fatherName)
      ..writeByte(39)
      ..write(obj.fatherOccupation)
      ..writeByte(40)
      ..write(obj.motherName)
      ..writeByte(41)
      ..write(obj.motherOccupation)
      ..writeByte(42)
      ..write(obj.brothers)
      ..writeByte(43)
      ..write(obj.sisters)
      ..writeByte(44)
      ..write(obj.familyType)
      ..writeByte(45)
      ..write(obj.familyValues)
      ..writeByte(46)
      ..write(obj.nativePlace)
      ..writeByte(47)
      ..write(obj.diet)
      ..writeByte(48)
      ..write(obj.smoking)
      ..writeByte(49)
      ..write(obj.drinking)
      ..writeByte(50)
      ..write(obj.languages)
      ..writeByte(51)
      ..write(obj.hobbies)
      ..writeByte(52)
      ..write(obj.personality)
      ..writeByte(53)
      ..write(obj.mobile)
      ..writeByte(54)
      ..write(obj.whatsapp)
      ..writeByte(55)
      ..write(obj.email)
      ..writeByte(56)
      ..write(obj.address)
      ..writeByte(57)
      ..write(obj.city)
      ..writeByte(58)
      ..write(obj.state)
      ..writeByte(59)
      ..write(obj.country)
      ..writeByte(60)
      ..write(obj.preferredAge)
      ..writeByte(61)
      ..write(obj.preferredHeight)
      ..writeByte(62)
      ..write(obj.preferredEducation)
      ..writeByte(63)
      ..write(obj.preferredOccupation)
      ..writeByte(64)
      ..write(obj.preferredReligion)
      ..writeByte(65)
      ..write(obj.preferredLocation)
      ..writeByte(66)
      ..write(obj.expectations)
      ..writeByte(67)
      ..write(obj.photos)
      ..writeByte(68)
      ..write(obj.profilePhotoPath)
      ..writeByte(69)
      ..write(obj.customFields)
      ..writeByte(70)
      ..write(obj.siblings)
      ..writeByte(71)
      ..write(obj.grandFatherName)
      ..writeByte(72)
      ..write(obj.grandFatherOccupation)
      ..writeByte(73)
      ..write(obj.grandMotherName)
      ..writeByte(74)
      ..write(obj.familyStatus)
      ..writeByte(75)
      ..write(obj.familyDescription)
      ..writeByte(76)
      ..write(obj.contactPerson)
      ..writeByte(77)
      ..write(obj.contactPersonRelation)
      ..writeByte(78)
      ..write(obj.alternateNumber)
      ..writeByte(79)
      ..write(obj.pinCode)
      ..writeByte(80)
      ..write(obj.selectedFontId)
      ..writeByte(81)
      ..write(obj.userId)
      ..writeByte(82)
      ..write(obj.photoAlignment)
      ..writeByte(83)
      ..write(obj.headerIcon)
      ..writeByte(84)
      ..write(obj.customHeadingFontSize)
      ..writeByte(85)
      ..write(obj.customBodyFontSize)
      ..writeByte(86)
      ..write(obj.contentAlignment)
      ..writeByte(87)
      ..write(obj.showFooterLine)
      ..writeByte(88)
      ..write(obj.customFieldSpacing)
      ..writeByte(89)
      ..write(obj.customSectionSpacing)
      ..writeByte(90)
      ..write(obj.customMargin)
      ..writeByte(91)
      ..write(obj.customPrimaryColor)
      ..writeByte(92)
      ..write(obj.customBackgroundColor)
      ..writeByte(93)
      ..write(obj.customPhotoShape)
      ..writeByte(94)
      ..write(obj.customPhotoSize)
      ..writeByte(95)
      ..write(obj.showPhotoBorder)
      ..writeByte(96)
      ..write(obj.uppercaseHeadings)
      ..writeByte(97)
      ..write(obj.boldLabels)
      ..writeByte(98)
      ..write(obj.showColons)
      ..writeByte(99)
      ..write(obj.customHeaderStyle)
      ..writeByte(100)
      ..write(obj.customHeadingAlignment)
      ..writeByte(101)
      ..write(obj.language)
      ..writeByte(102)
      ..write(obj.sectionOrder);
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
      isDraft: json['isDraft'] as bool? ?? true,
      downloadCount: (json['downloadCount'] as num?)?.toInt() ?? 0,
      fullName: json['fullName'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      age: json['age'] as String? ?? '',
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
          const <PhotoInfo>[],
      profilePhotoPath: json['profilePhotoPath'] as String? ?? '',
      customFields: (json['customFields'] as List<dynamic>?)
              ?.map((e) => CustomField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CustomField>[],
      siblings: (json['siblings'] as List<dynamic>?)
              ?.map((e) => Sibling.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Sibling>[],
      grandFatherName: json['grandFatherName'] as String? ?? '',
      grandFatherOccupation: json['grandFatherOccupation'] as String? ?? '',
      grandMotherName: json['grandMotherName'] as String? ?? '',
      familyStatus: json['familyStatus'] as String? ?? '',
      familyDescription: json['familyDescription'] as String? ?? '',
      contactPerson: json['contactPerson'] as String? ?? '',
      contactPersonRelation: json['contactPersonRelation'] as String? ?? '',
      alternateNumber: json['alternateNumber'] as String? ?? '',
      pinCode: json['pinCode'] as String? ?? '',
      selectedFontId: json['selectedFontId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      photoAlignment: json['photoAlignment'] as String? ?? 'left',
      headerIcon: json['headerIcon'] as String? ?? 'none',
      customHeadingFontSize:
          (json['customHeadingFontSize'] as num?)?.toDouble() ?? 0.0,
      customBodyFontSize:
          (json['customBodyFontSize'] as num?)?.toDouble() ?? 0.0,
      contentAlignment: json['contentAlignment'] as String? ?? 'left',
      showFooterLine: json['showFooterLine'] as bool? ?? false,
      customFieldSpacing:
          (json['customFieldSpacing'] as num?)?.toDouble() ?? 0.0,
      customSectionSpacing:
          (json['customSectionSpacing'] as num?)?.toDouble() ?? 0.0,
      customMargin: (json['customMargin'] as num?)?.toDouble() ?? 0.0,
      customPrimaryColor: (json['customPrimaryColor'] as num?)?.toInt() ?? 0,
      customBackgroundColor:
          (json['customBackgroundColor'] as num?)?.toInt() ?? 0,
      customPhotoShape: json['customPhotoShape'] as String? ?? '',
      customPhotoSize: (json['customPhotoSize'] as num?)?.toDouble() ?? 1.0,
      showPhotoBorder: json['showPhotoBorder'] as bool? ?? false,
      uppercaseHeadings: json['uppercaseHeadings'] as bool? ?? false,
      boldLabels: json['boldLabels'] as bool? ?? false,
      showColons: json['showColons'] as bool? ?? true,
      customHeaderStyle: json['customHeaderStyle'] as String? ?? '',
      customHeadingAlignment: json['customHeadingAlignment'] as String? ?? '',
      language: json['language'] as String? ?? 'en',
      sectionOrder: (json['sectionOrder'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['personal', 'family', 'contact', 'education', 'additional'],
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
      'isDraft': instance.isDraft,
      'downloadCount': instance.downloadCount,
      'fullName': instance.fullName,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth,
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
      'siblings': instance.siblings,
      'grandFatherName': instance.grandFatherName,
      'grandFatherOccupation': instance.grandFatherOccupation,
      'grandMotherName': instance.grandMotherName,
      'familyStatus': instance.familyStatus,
      'familyDescription': instance.familyDescription,
      'contactPerson': instance.contactPerson,
      'contactPersonRelation': instance.contactPersonRelation,
      'alternateNumber': instance.alternateNumber,
      'pinCode': instance.pinCode,
      'selectedFontId': instance.selectedFontId,
      'userId': instance.userId,
      'photoAlignment': instance.photoAlignment,
      'headerIcon': instance.headerIcon,
      'customHeadingFontSize': instance.customHeadingFontSize,
      'customBodyFontSize': instance.customBodyFontSize,
      'contentAlignment': instance.contentAlignment,
      'showFooterLine': instance.showFooterLine,
      'customFieldSpacing': instance.customFieldSpacing,
      'customSectionSpacing': instance.customSectionSpacing,
      'customMargin': instance.customMargin,
      'customPrimaryColor': instance.customPrimaryColor,
      'customBackgroundColor': instance.customBackgroundColor,
      'customPhotoShape': instance.customPhotoShape,
      'customPhotoSize': instance.customPhotoSize,
      'showPhotoBorder': instance.showPhotoBorder,
      'uppercaseHeadings': instance.uppercaseHeadings,
      'boldLabels': instance.boldLabels,
      'showColons': instance.showColons,
      'customHeaderStyle': instance.customHeaderStyle,
      'customHeadingAlignment': instance.customHeadingAlignment,
      'language': instance.language,
      'sectionOrder': instance.sectionOrder,
    };
