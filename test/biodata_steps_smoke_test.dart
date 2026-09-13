import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/core/services/hive_service.dart';
import 'package:biodata_maker/core/services/pdf_service.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/biodata/data/models/custom_field.dart';
import 'package:biodata_maker/features/biodata/data/models/photo_info.dart';
import 'package:biodata_maker/features/biodata/data/models/sibling.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/additional_details_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/basic_details_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/contact_partner_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/family_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/template_step.dart';
import 'package:biodata_maker/features/settings/data/models/user_settings.dart';
import 'package:biodata_maker/features/settings/data/repositories/settings_repository.dart';
import 'package:biodata_maker/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:biodata_maker/features/settings/presentation/bloc/settings_event.dart';
import 'package:biodata_maker/features/settings/presentation/bloc/settings_state.dart';
import 'package:biodata_maker/features/settings/presentation/screens/settings_screen.dart';
import 'package:biodata_maker/features/templates/data/models/theme_engine.dart';
import 'package:biodata_maker/shared/widgets/biodata_renderer.dart';

Biodata _sampleBiodata() {
  final now = DateTime.now();
  return Biodata(
    id: 'test-1',
    name: 'Saurabh Kumar Singh',
    fullName: 'Saurabh Kumar Singh',
    createdAt: now,
    updatedAt: now,
    // Legacy values that must not crash converted dropdowns.
    height: '5\'9"',
    complexion: 'Very Dark',
    religion: 'Hindu',
    gender: 'Male',
    maritalStatus: 'Never Married',
    bloodGroup: 'B+',
    manglik: 'No',
    motherTongue: 'Hindi',
    languages: 'Hindi, English',
    dateOfBirth: '04/05/1997',
    age: '28',
    birthPlace: 'Delhi',
    birthTime: '10:30 AM',
    rashi: 'Simha (Leo)',
    nakshatra: 'Ashwini',
    gotra: 'Kashyap',
    occupation: '',
    designation: '',
    company: '',
    annualIncome: '',
    fatherName: 'Rajendra Singh',
    fatherOccupation: 'Businessman',
    motherName: 'Sunita Singh',
    motherOccupation: 'Homemaker',
    grandFatherName: 'Ram Singh',
    grandFatherOccupation: 'Retired',
    grandMotherName: 'Shanti Devi',
    familyType: 'Nuclear Family',
    familyValues: 'Moderate',
    familyStatus: 'Upper Middle Class',
    nativePlace: 'Jaipur, Rajasthan',
    familyDescription: 'Close-knit family with traditional values.',
    diet: 'Vegetarian',
    smoking: 'No',
    drinking: 'No',
    hobbies: 'Reading, Cricket',
    aboutMe: 'A software engineer based in Delhi.',
    contactPerson: 'Rajendra Singh',
    contactPersonRelation: 'Father',
    mobile: '+91 9876543210',
    alternateNumber: '+91 9123456780',
    whatsapp: '+91 9876543210',
    email: 'saurabh@example.com',
    address: '12, MG Road',
    city: 'Delhi',
    state: 'Delhi',
    pinCode: '110001',
    country: 'India',
    preferredAge: '',
    siblings: const [
      Sibling(
        id: 's1',
        relationship: 'Brother',
        name: 'Abhinav Singh',
        occupation: 'Software Engineer',
        maritalStatus: 'Unmarried',
      ),
      Sibling(
        id: 's2',
        relationship: 'Brother',
        name: 'Rohit Singh',
        occupation: 'CA',
        maritalStatus: 'Married',
      ),
      Sibling(
        id: 's3',
        relationship: 'Sister',
        name: 'Priya Singh',
        maritalStatus: 'Unmarried',
      ),
    ],
    customFields: const [
      CustomField(id: 'c1', section: 'personal', label: 'Blood Group', value: 'B+'),
      CustomField(id: 'c2', section: 'family', label: 'Family Business', value: 'Textile Manufacturing'),
      CustomField(id: 'c3', section: 'contact', label: 'Preferred Contact Time', value: 'Evening 6-9 PM'),
    ],
  );
}

/// In-memory settings store so a SettingsBloc can run in tests without Hive.
class _MemorySettingsRepo extends SettingsRepository {
  _MemorySettingsRepo() : super(hiveService: HiveService());

  UserSettings current = UserSettings(id: 'default_settings');

  @override
  UserSettings getSettings() => current;

  @override
  Future<void> updateSettings(UserSettings settings) async {
    current = settings;
  }
}

void main() {
  Future<void> pumpStep(WidgetTester tester, Widget step) async {
    // Tall viewport so lazy ListViews build their full content.
    tester.view.physicalSize = const Size(900, 10000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: step),
    ));
    await tester.pump();
  }

  testWidgets('Personal (BasicDetails) step renders legacy + new data', (tester) async {
    final b = _sampleBiodata();
    await pumpStep(tester, BasicDetailsStep(biodata: b, onUpdate: (_) {}));
    expect(find.text('Personal Details'), findsOneWidget);
    expect(find.text('Saurabh Kumar Singh'), findsOneWidget);
    expect(find.text('Hindi, English'), findsOneWidget);
    // + Add More Fields button is present
    expect(find.text('Add More Fields'), findsOneWidget);
    // Open the add dialog
    await tester.tap(find.text('Add More Fields'));
    await tester.pumpAndSettle();
    expect(find.text('Field Label'), findsOneWidget);
  });

  testWidgets('Family step renders grandparents, siblings and custom fields', (tester) async {
    final b = _sampleBiodata();
    await pumpStep(tester, FamilyStep(biodata: b, onUpdate: (_) {}));
    expect(find.text("Grandfather's Name"), findsOneWidget);
    expect(find.text('Ram Singh'), findsOneWidget);
    expect(find.text('Abhinav Singh'), findsOneWidget);
    expect(find.text('Rohit Singh'), findsOneWidget);
    expect(find.text('Priya Singh'), findsOneWidget);
    expect(find.text('Add Sibling'), findsOneWidget);
  });

  testWidgets('Contact step renders contact person, PIN and custom fields', (tester) async {
    final b = _sampleBiodata();
    await pumpStep(tester, ContactPartnerStep(biodata: b, onUpdate: (_) {}));
    expect(find.text('Contact Person'), findsOneWidget);
    expect(find.text('PIN Code'), findsOneWidget);
    expect(find.text('Add More Fields'), findsOneWidget);
  });

  testWidgets('Template step shows a live preview of the selected template', (tester) async {
    String? selectedId;
    await pumpStep(
      tester,
      TemplateStep(
        biodata: _sampleBiodata(),
        onUpdate: (b) => selectedId = b.templateId,
      ),
    );

    // Real renderer preview is present (falls back to built-in templates).
    expect(find.byKey(const ValueKey('templateLivePreview')), findsOneWidget);
    // Filled data shows inside the preview: name (header + Full Name row)
    // and a plain field row rendered from the sample data.
    expect(find.text('Saurabh Kumar Singh'), findsWidgets);
    expect(find.text('Height'), findsOneWidget);

    // Tapping a template card fires onUpdate with that template's id.
    // (In tests the repository is unavailable, so the step falls back to the
    // built-in templates; the preview mirrors the selection either way.)
    final templates = ThemeEngine.defaultTemplates;
    expect(templates.length, greaterThan(1));
    await tester.tap(
      find.byKey(ValueKey('templateCard-${templates[1].id}')),
      warnIfMissed: false,
    );
    await tester.pump();
    expect(selectedId, templates[1].id);
  });

  testWidgets('Theme toggle in Settings reaches the root bloc immediately', (tester) async {
    final repo = _MemorySettingsRepo();
    final bloc = SettingsBloc(repository: repo)..add(const LoadSettings());

    await tester.pumpWidget(MultiBlocProvider(
      providers: [BlocProvider<SettingsBloc>.value(value: bloc)],
      child: const MaterialApp(home: Scaffold(body: SettingsScreen())),
    ));
    await tester.pumpAndSettle();

    // SettingsScreen must consume the app-root bloc (no shadowing instance),
    // so toggling theme updates the very bloc that drives MaterialApp.themeMode.
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();

    final loaded = bloc.state as SettingsLoaded;
    expect(loaded.settings.themeMode, 'light');
    expect(repo.current.themeMode, 'light');
  });

  testWidgets('Lifestyle step renders', (tester) async {
    final b = _sampleBiodata();
    await pumpStep(tester, AdditionalDetailsStep(biodata: b, onUpdate: (_) {}));
    expect(find.text('Food Preference'), findsOneWidget);
    expect(find.text('About Me'), findsWidgets); // card title + field label
    expect(find.text('Reading, Cricket'), findsOneWidget);
  });

  testWidgets('Renderer shows filled sections only, with siblings', (tester) async {
    final b = _sampleBiodata();
    await pumpStep(
      tester,
      BiodataRenderer(
        biodata: b,
        theme: ThemeEngine.getById('modern_minimal') ?? ThemeEngine.defaultTemplates.first,
      ),
    );
    expect(find.text('Personal Details'), findsOneWidget);
    expect(find.text('Family Details'), findsOneWidget);
    expect(find.text('Contact Information'), findsOneWidget);
    expect(find.text('Lifestyle & Interests'), findsOneWidget);
    // Sibling rows with de-duplicated labels
    expect(find.text('Brother 1'), findsOneWidget);
    expect(find.text('Brother 2'), findsOneWidget);
    expect(find.text('Sister'), findsOneWidget);
    // Custom fields appear inside their sections
    expect(find.text('Textile Manufacturing'), findsOneWidget);
    // Empty sections (Education & Career, Partner Preference) are hidden
    expect(find.text('Education & Career'), findsNothing);
    expect(find.text('Partner Preference'), findsNothing);
  });

  testWidgets('Renderer shows an edit button per visible section heading when requested', (tester) async {
    final b = _sampleBiodata();
    final captured = <String>[];
    await pumpStep(
      tester,
      BiodataRenderer(
        biodata: b,
        theme: ThemeEngine.getById('modern_minimal') ?? ThemeEngine.defaultTemplates.first,
        onEditSection: captured.add,
      ),
    );
    // The header always gets one, plus About, Personal, Family, Lifestyle and
    // Contact sections; Education and Partner Preference stay hidden.
    expect(find.byKey(const ValueKey('editSection-photo')), findsOneWidget);
    expect(find.byKey(const ValueKey('editSection-about')), findsOneWidget);
    expect(find.byKey(const ValueKey('editSection-personal')), findsOneWidget);
    expect(find.byKey(const ValueKey('editSection-education')), findsNothing);
    expect(find.byKey(const ValueKey('editSection-family')), findsOneWidget);
    expect(find.byKey(const ValueKey('editSection-lifestyle')), findsOneWidget);
    expect(find.byKey(const ValueKey('editSection-contact')), findsOneWidget);
    expect(find.byKey(const ValueKey('editSection-partner_preference')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('editSection-photo')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('editSection-family')));
    await tester.pump();
    expect(captured, ['photo', 'family']);
  });

  testWidgets('Renderer has no edit buttons when onEditSection is not provided', (tester) async {
    final b = _sampleBiodata();
    await pumpStep(
      tester,
      BiodataRenderer(
        biodata: b,
        theme: ThemeEngine.getById('modern_minimal') ?? ThemeEngine.defaultTemplates.first,
      ),
    );
    expect(find.byIcon(Icons.edit_outlined), findsNothing);
  });

  test('Hindi strings translate known UI copy and fall back to English', () {
    Strings.set(Strings.en);
    expect(Strings.tr('Personal Details'), 'Personal Details');
    Strings.set(Strings.hi);
    expect(Strings.tr('Personal Details'), 'व्यक्तिगत विवरण');
    expect(Strings.tr('Full Name *'), 'पूरा नाम *');
    expect(Strings.tr('Add Sibling'), 'भाई-बहन जोड़ें');
    // Unknown keys (e.g. user-entered labels) stay as authored.
    expect(Strings.tr('Some untranslated string'), 'Some untranslated string');
    Strings.set(Strings.en);
  });

  testWidgets('Renderer headings switch to Hindi when the language is Hindi', (tester) async {
    Strings.set(Strings.hi);
    addTearDown(() => Strings.set(Strings.en));
    final b = _sampleBiodata();
    await pumpStep(
      tester,
      BiodataRenderer(
        biodata: b,
        theme: ThemeEngine.getById('modern_minimal') ?? ThemeEngine.defaultTemplates.first,
      ),
    );
    expect(find.text('व्यक्तिगत विवरण'), findsOneWidget);
    expect(find.text('पारिवारिक विवरण'), findsOneWidget);
    expect(find.text('Personal Details'), findsNothing);
  });

  test('PDF generation succeeds with siblings and custom fields', () async {
    final b = _sampleBiodata();
    final theme =
        ThemeEngine.getById('modern_minimal') ?? ThemeEngine.defaultTemplates.first;
    final bytes = await PdfService().generatePdf(b, theme);
    expect(bytes.length, greaterThan(1000));
  });

  /// Number of pages in a saved PDF, read from the pages-tree /Count entry.
  int pdfPageCount(List<int> bytes) {
    final ascii = String.fromCharCodes(bytes);
    final counts = RegExp(r'/Count\s+(\d+)')
        .allMatches(ascii)
        .map((m) => int.parse(m.group(1)!))
        .toList();
    expect(counts, isNotEmpty, reason: 'PDF page-tree /Count not found in output');
    return counts.reduce((a, b) => a > b ? a : b);
  }

  Biodata longBiodata() {
    final b = _sampleBiodata();
    final paragraph = List.filled(40, 'This is a sample line of text used to make the biodata long enough to overflow a single A4 page.').join('\n\n');
    final extraCustom = <CustomField>[
      for (var i = 0; i < 12; i++)
        CustomField(id: 'x$i', section: 'personal', label: 'Personal Detail ${i + 1}', value: 'Some longer descriptive value for field number ${i + 1} that spans multiple words.'),
      for (var i = 0; i < 8; i++)
        CustomField(id: 'y$i', section: 'family', label: 'Family Detail ${i + 1}', value: 'Extra family information value number ${i + 1} with enough words to wrap.'),
      for (var i = 0; i < 6; i++)
        CustomField(id: 'z$i', section: 'contact', label: 'Contact Detail ${i + 1}', value: 'Additional contact reference ${i + 1} with details.'),
      for (var i = 0; i < 4; i++)
        CustomField(id: 'o$i', section: 'other', label: 'Misc Detail ${i + 1}', value: 'Orphan custom field value ${i + 1}.'),
    ];
    final extraSiblings = <Sibling>[
      for (var i = 0; i < 14; i++)
        Sibling(
          id: 'sib-$i',
          relationship: i.isEven ? 'Brother' : 'Sister',
          name: 'Relative Name ${i + 1}',
          occupation: 'Occupation title ${i + 1} with a fairly long description of the work',
          maritalStatus: i % 3 == 0 ? 'Married' : 'Unmarried',
        ),
    ];
    return b.copyWith(
      aboutMe: paragraph,
      familyDescription: paragraph,
      address: '$paragraph\nFlat 42, Sunrise Apartments, Sector 62, Noida, Uttar Pradesh, India',
      occupation: 'Senior Software Engineer at a large technology company',
      hobbies: paragraph,
      siblings: [...b.siblings, ...extraSiblings],
      customFields: [...b.customFields, ...extraCustom],
    );
  }

  test('PDF flows very long biodata across multiple pages', () async {
    final b = longBiodata();
    final theme =
        ThemeEngine.getById('modern_minimal') ?? ThemeEngine.defaultTemplates.first;
    final bytes = await PdfService().generatePdf(b, theme);
    expect(bytes.length, greaterThan(20000));
    expect(pdfPageCount(bytes), greaterThanOrEqualTo(2));
  });

  test('PDF page background, frame and numbering do not throw for any theme', () async {
    final b = longBiodata();
    for (final theme in ThemeEngine.defaultTemplates) {
      final bytes = await PdfService().generatePdf(b, theme);
      expect(pdfPageCount(bytes), greaterThanOrEqualTo(2),
          reason: 'theme ${theme.name} should paginate');
    }
  });

  test('PDF favors fitting borderline content on one page via compact spacing', () async {
    // A minimal biodata (only Personal/Family/Contact filled, matching the
    // spec's own "should fit on one page" example) genuinely spills onto a
    // second page at normal spacing on ivory_mandala (its large decorative
    // header leaves less usable height) — confirmed empirically before
    // writing this test. PdfService's compact retry should bring it back to
    // one page rather than leaving it stranded on two.
    final theme = ThemeEngine.getById('ivory_mandala') ?? ThemeEngine.defaultTemplates.first;
    final now = DateTime.now();
    final b = Biodata(
      id: 'minimal', name: 'Test', fullName: 'Ritesh Sharma', createdAt: now, updatedAt: now,
      gender: 'Male', dateOfBirth: '04/05/1997', age: '28', height: '5\'9"', religion: 'Hindu',
      maritalStatus: 'Never Married',
      fatherName: 'Rajendra Sharma', fatherOccupation: 'Business', motherName: 'Sunita Sharma',
      motherOccupation: 'Homemaker', familyType: 'Nuclear Family',
      mobile: '+91 9876543210', email: 'ritesh@example.com', city: 'Delhi', state: 'Delhi', country: 'India',
    );

    expect(pdfPageCount(await PdfService().generatePdf(b, theme)), 1);
  });

  test('PDF leaves genuinely long content unchanged (still paginates normally)', () async {
    final b = longBiodata();
    final theme = ThemeEngine.getById('modern_minimal') ?? ThemeEngine.defaultTemplates.first;
    final bytes = await PdfService().generatePdf(b, theme);
    expect(pdfPageCount(bytes), greaterThanOrEqualTo(2));
  });

  test('Hive round-trip persists siblings and new family fields', () async {
    final dir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(dir.path);
    Hive.registerAdapter(BiodataAdapter());
    Hive.registerAdapter(PhotoInfoAdapter());
    Hive.registerAdapter(CustomFieldAdapter());
    Hive.registerAdapter(SiblingAdapter());

    try {
      final box = await Hive.openBox<Biodata>('biodata_test');
      final b = _sampleBiodata();
      await box.put(b.id, b);

      final loaded = box.get(b.id)!;
      expect(loaded.fullName, 'Saurabh Kumar Singh');
      expect(loaded.siblings.length, 3);
      expect(loaded.siblings[1].relationship, 'Brother');
      expect(loaded.grandFatherName, 'Ram Singh');
      expect(loaded.familyStatus, 'Upper Middle Class');
      expect(loaded.pinCode, '110001');
      expect(loaded.contactPersonRelation, 'Father');
      expect(loaded.customFields.length, 3);

      await box.close();
    } finally {
      await Hive.deleteFromDisk();
      try {
        await dir.delete(recursive: true);
      } catch (_) {}
    }
  });
}
