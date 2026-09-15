// ignore_for_file: implementation_imports
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/src/binary/binary_reader_impl.dart';
import 'package:hive/src/binary/binary_writer_impl.dart';
import 'package:hive/src/hive_impl.dart';

import 'package:biodata_maker/features/biodata/data/models/biodata.dart';

/// Regression test for the post-splash freeze.
///
/// Rows persisted before `userId` (HiveField 81) was added contain only
/// fields 0..80. Deserializing such a row with the current adapter used to
/// throw `type 'Null' is not a subtype of type 'String'`, which crashed
/// `Hive.openBox()` in `main()` and froze the app on the splash screen.
/// With `defaultValue: ''` on the field, the generated adapter maps the
/// missing field to `''` instead.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Encodes a Biodata exactly like the pre-userId app version did:
  /// numOfFields = 81, field indices 0..80, and NO field 81.
  void writeLegacyFrame(BinaryWriterImpl writer, Biodata obj) {
    writer
      ..writeByte(81) // number of fields (0..80)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.name)
      ..writeByte(2)..write(obj.createdAt)
      ..writeByte(3)..write(obj.updatedAt)
      ..writeByte(4)..write(obj.templateId)
      ..writeByte(5)..write(obj.isFavorite)
      ..writeByte(6)..write(obj.isArchived)
      ..writeByte(7)..write(obj.isDraft)
      ..writeByte(8)..write(obj.downloadCount)
      ..writeByte(9)..write(obj.fullName)
      ..writeByte(10)..write(obj.gender)
      ..writeByte(11)..write(obj.dateOfBirth)
      ..writeByte(12)..write(obj.age)
      ..writeByte(13)..write(obj.height)
      ..writeByte(14)..write(obj.weight)
      ..writeByte(15)..write(obj.religion)
      ..writeByte(16)..write(obj.caste)
      ..writeByte(17)..write(obj.subCaste)
      ..writeByte(18)..write(obj.motherTongue)
      ..writeByte(19)..write(obj.maritalStatus)
      ..writeByte(20)..write(obj.bloodGroup)
      ..writeByte(21)..write(obj.complexion)
      ..writeByte(22)..write(obj.manglik)
      ..writeByte(23)..write(obj.horoscope)
      ..writeByte(24)..write(obj.rashi)
      ..writeByte(25)..write(obj.nakshatra)
      ..writeByte(26)..write(obj.gotra)
      ..writeByte(27)..write(obj.birthPlace)
      ..writeByte(28)..write(obj.birthTime)
      ..writeByte(29)..write(obj.aboutMe)
      ..writeByte(30)..write(obj.qualification)
      ..writeByte(31)..write(obj.college)
      ..writeByte(32)..write(obj.university)
      ..writeByte(33)..write(obj.occupation)
      ..writeByte(34)..write(obj.company)
      ..writeByte(35)..write(obj.business)
      ..writeByte(36)..write(obj.designation)
      ..writeByte(37)..write(obj.annualIncome)
      ..writeByte(38)..write(obj.fatherName)
      ..writeByte(39)..write(obj.fatherOccupation)
      ..writeByte(40)..write(obj.motherName)
      ..writeByte(41)..write(obj.motherOccupation)
      ..writeByte(42)..write(obj.brothers)
      ..writeByte(43)..write(obj.sisters)
      ..writeByte(44)..write(obj.familyType)
      ..writeByte(45)..write(obj.familyValues)
      ..writeByte(46)..write(obj.nativePlace)
      ..writeByte(47)..write(obj.diet)
      ..writeByte(48)..write(obj.smoking)
      ..writeByte(49)..write(obj.drinking)
      ..writeByte(50)..write(obj.languages)
      ..writeByte(51)..write(obj.hobbies)
      ..writeByte(52)..write(obj.personality)
      ..writeByte(53)..write(obj.mobile)
      ..writeByte(54)..write(obj.whatsapp)
      ..writeByte(55)..write(obj.email)
      ..writeByte(56)..write(obj.address)
      ..writeByte(57)..write(obj.city)
      ..writeByte(58)..write(obj.state)
      ..writeByte(59)..write(obj.country)
      ..writeByte(60)..write(obj.preferredAge)
      ..writeByte(61)..write(obj.preferredHeight)
      ..writeByte(62)..write(obj.preferredEducation)
      ..writeByte(63)..write(obj.preferredOccupation)
      ..writeByte(64)..write(obj.preferredReligion)
      ..writeByte(65)..write(obj.preferredLocation)
      ..writeByte(66)..write(obj.expectations)
      ..writeByte(67)..write(obj.photos)
      ..writeByte(68)..write(obj.profilePhotoPath)
      ..writeByte(69)..write(obj.customFields)
      ..writeByte(70)..write(obj.siblings)
      ..writeByte(71)..write(obj.grandFatherName)
      ..writeByte(72)..write(obj.grandFatherOccupation)
      ..writeByte(73)..write(obj.grandMotherName)
      ..writeByte(74)..write(obj.familyStatus)
      ..writeByte(75)..write(obj.familyDescription)
      ..writeByte(76)..write(obj.contactPerson)
      ..writeByte(77)..write(obj.contactPersonRelation)
      ..writeByte(78)..write(obj.alternateNumber)
      ..writeByte(79)..write(obj.pinCode)
      ..writeByte(80)..write(obj.selectedFontId);
    // Field 81 (userId) intentionally NOT written — pre-userId rows end here.
  }

  test('pre-userId frame deserializes with the current adapter (userId = "")',
      () async {
    final biodata = Biodata(
      id: 'legacy-1',
      name: 'Legacy Row',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 2),
      fullName: 'Legacy User',
      selectedFontId: 'classic',
    );

    // Simulate a row written by the old app version.
    final writer = BinaryWriterImpl(HiveImpl());
    writeLegacyFrame(writer, biodata);

    // Read it with the CURRENT generated adapter — what happens on app
    // start when openBox() deserializes the existing database.
    final legacyBytes = writer.toBytes();
    final decoded =
        BiodataAdapter().read(BinaryReaderImpl(legacyBytes, HiveImpl()));

    expect(decoded.id, 'legacy-1');
    expect(decoded.fullName, 'Legacy User');
    expect(decoded.selectedFontId, 'classic');
    expect(
      decoded.userId,
      '',
      reason: 'A pre-userId row must deserialize with an empty userId, '
          'not crash with a TypeError',
    );
  });

  test('current frame round-trips with userId intact', () async {
    final biodata = Biodata(
      id: 'new-1',
      name: 'New Row',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 2),
      userId: 'user-42',
    );

    final writer = BinaryWriterImpl(HiveImpl());
    BiodataAdapter().write(writer, biodata);
    final newBytes = writer.toBytes();
    final decoded =
        BiodataAdapter().read(BinaryReaderImpl(newBytes, HiveImpl()));

    expect(decoded.userId, 'user-42');
  });
}
