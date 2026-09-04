import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/biodata/data/models/sibling.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';

class FieldConfig {
  final String label;
  final String Function(Biodata b) value;
  const FieldConfig({required this.label, required this.value});
}

class SectionConfig {
  final String key;
  final String title;
  final List<FieldConfig> fields;
  const SectionConfig({required this.key, required this.title, required this.fields});
}

final List<SectionConfig> kSections = [
  SectionConfig(key: 'personal', title: 'Personal Details', fields: [
    FieldConfig(label: 'Full Name', value: (b) => b.fullName),
    FieldConfig(label: 'Gender', value: (b) => b.gender),
    FieldConfig(label: 'Date of Birth', value: (b) => b.dateOfBirth),
    FieldConfig(label: 'Age', value: (b) => b.age),
    FieldConfig(label: 'Height', value: (b) => b.height),
    FieldConfig(label: 'Weight', value: (b) => b.weight),
    FieldConfig(label: 'Religion', value: (b) => b.religion),
    FieldConfig(label: 'Caste', value: (b) => b.caste),
    FieldConfig(label: 'Sub Caste', value: (b) => b.subCaste),
    FieldConfig(label: 'Mother Tongue', value: (b) => b.motherTongue),
    FieldConfig(label: 'Languages Known', value: (b) => b.languages),
    FieldConfig(label: 'Marital Status', value: (b) => b.maritalStatus),
    FieldConfig(label: 'Blood Group', value: (b) => b.bloodGroup),
    FieldConfig(label: 'Complexion', value: (b) => b.complexion),
    FieldConfig(label: 'Manglik', value: (b) => b.manglik),
    FieldConfig(label: 'Horoscope', value: (b) => b.horoscope),
    FieldConfig(label: 'Rashi', value: (b) => b.rashi),
    FieldConfig(label: 'Nakshatra', value: (b) => b.nakshatra),
    FieldConfig(label: 'Gotra', value: (b) => b.gotra),
    FieldConfig(label: 'Birth Place', value: (b) => b.birthPlace),
    FieldConfig(label: 'Birth Time', value: (b) => b.birthTime),
  ]),
  SectionConfig(key: 'education', title: 'Education & Career', fields: [
    FieldConfig(label: 'Qualification', value: (b) => b.qualification),
    FieldConfig(label: 'College', value: (b) => b.college),
    FieldConfig(label: 'University', value: (b) => b.university),
    FieldConfig(label: 'Occupation', value: (b) => b.occupation),
    FieldConfig(label: 'Company', value: (b) => b.company),
    FieldConfig(label: 'Designation', value: (b) => b.designation),
    FieldConfig(label: 'Annual Income', value: (b) => b.annualIncome),
  ]),
  SectionConfig(key: 'family', title: 'Family Details', fields: [
    FieldConfig(label: "Grandfather's Name", value: (b) => b.grandFatherName),
    FieldConfig(label: "Grandfather's Occupation", value: (b) => b.grandFatherOccupation),
    FieldConfig(label: "Grandmother's Name", value: (b) => b.grandMotherName),
    FieldConfig(label: 'Father', value: (b) => b.fatherName),
    FieldConfig(label: "Father's Occupation", value: (b) => b.fatherOccupation),
    FieldConfig(label: 'Mother', value: (b) => b.motherName),
    FieldConfig(label: "Mother's Occupation", value: (b) => b.motherOccupation),
    FieldConfig(label: 'Brothers', value: (b) => b.brothers),
    FieldConfig(label: 'Sisters', value: (b) => b.sisters),
    FieldConfig(label: 'Family Type', value: (b) => b.familyType),
    FieldConfig(label: 'Family Values', value: (b) => b.familyValues),
    FieldConfig(label: 'Family Status', value: (b) => b.familyStatus),
    FieldConfig(label: 'Native Place', value: (b) => b.nativePlace),
    FieldConfig(label: 'Family Description', value: (b) => b.familyDescription),
  ]),
  SectionConfig(key: 'lifestyle', title: 'Lifestyle & Interests', fields: [
    FieldConfig(label: 'Diet', value: (b) => b.diet),
    FieldConfig(label: 'Smoking', value: (b) => b.smoking),
    FieldConfig(label: 'Drinking', value: (b) => b.drinking),
    FieldConfig(label: 'Hobbies', value: (b) => b.hobbies),
    FieldConfig(label: 'Personality', value: (b) => b.personality),
  ]),
  SectionConfig(key: 'contact', title: 'Contact Information', fields: [
    FieldConfig(label: 'Contact Person', value: (b) => b.contactPerson),
    FieldConfig(label: 'Relationship', value: (b) => b.contactPersonRelation),
    FieldConfig(label: 'Mobile', value: (b) => b.mobile),
    FieldConfig(label: 'Alternate Number', value: (b) => b.alternateNumber),
    FieldConfig(label: 'WhatsApp', value: (b) => b.whatsapp),
    FieldConfig(label: 'Email', value: (b) => b.email),
    FieldConfig(label: 'Address', value: (b) => b.address),
    FieldConfig(label: 'City', value: (b) => b.city),
    FieldConfig(label: 'State', value: (b) => b.state),
    FieldConfig(label: 'Country', value: (b) => b.country),
    FieldConfig(label: 'PIN Code', value: (b) => b.pinCode),
  ]),
  SectionConfig(key: 'partner_preference', title: 'Partner Preference', fields: [
    FieldConfig(label: 'Preferred Age', value: (b) => b.preferredAge),
    FieldConfig(label: 'Preferred Height', value: (b) => b.preferredHeight),
    FieldConfig(label: 'Preferred Education', value: (b) => b.preferredEducation),
    FieldConfig(label: 'Preferred Occupation', value: (b) => b.preferredOccupation),
    FieldConfig(label: 'Preferred Religion', value: (b) => b.preferredReligion),
    FieldConfig(label: 'Preferred Location', value: (b) => b.preferredLocation),
    FieldConfig(label: 'Expectations', value: (b) => b.expectations),
  ]),
];

/// Per-sibling display: a unique label ("Brother", "Brother 2", ...) and a
/// single-line summary value combining name, occupation and marital status.
({String label, String value}) _siblingDisplay(Sibling sibling, List<Sibling> all) {
  final sameRelation = all.where((s) => s.relationship == sibling.relationship).toList();
  final position = sameRelation.indexWhere((s) => s.id == sibling.id);
  final label = sameRelation.length > 1 && position >= 0
      ? '${sibling.relationship} ${position + 1}'
      : sibling.relationship;

  final name = sibling.name.trim();
  final extras = [
    sibling.occupation.trim(),
    sibling.maritalStatus.trim(),
  ].where((s) => s.isNotEmpty).toList();

  // ASCII separators only: the PDF renderer uses Helvetica, which has no
  // Unicode glyphs for decorative dashes/dots.
  final value = extras.isEmpty
      ? name
      : (name.isEmpty ? extras.join(', ') : '$name - ${extras.join(', ')}');
  return (label: label, value: value);
}

class BiodataRenderer extends StatelessWidget {
  final Biodata biodata;
  final ThemeConfig theme;

  /// When provided, each section heading in the on-screen review/preview gains
  /// a small edit button that invokes this callback with the section key
  /// ("personal", "family", "about", ...). The caller decides where to jump.
  final void Function(String sectionKey)? onEditSection;

  const BiodataRenderer({
    super.key,
    required this.biodata,
    required this.theme,
    this.onEditSection,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Color(theme.primaryColor);
    final text = Color(theme.textColor);
    final subtitle = Color(theme.subtitleColor);

    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        color: Color(theme.backgroundColor),
        padding: EdgeInsets.all(theme.margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildFlutterSections(context, biodata, theme, primary, text, subtitle, onEditSection),
        ),
      ),
    );
  }

  static List<Widget> _buildFlutterSections(
    BuildContext context,
    Biodata biodata,
    ThemeConfig theme,
    Color primary,
    Color text,
    Color subtitle,
    void Function(String sectionKey)? onEditSection,
  ) {
    final widgets = <Widget>[];
    final displayName = biodata.fullName.isNotEmpty ? biodata.fullName : biodata.name;

    // Header (photo + name block); gains an edit button in review mode
    final header = _buildFlutterHeader(biodata, theme, primary, text, subtitle, displayName);
    widgets.add(onEditSection == null
        ? header
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: header),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: _flutterEditIcon(context, 'photo', 'Photo', primary, onEditSection),
              ),
            ],
          ));
    widgets.add(SizedBox(height: theme.sectionSpacing));

    // About Me
    if (biodata.aboutMe.isNotEmpty) {
      widgets.add(_flutterSectionHeading(context, 'about', 'About Me', primary, theme, onEditSection));
      widgets.add(SizedBox(height: theme.fieldSpacing));
      widgets.add(Padding(
        padding: EdgeInsets.only(bottom: theme.sectionSpacing),
        child: Text(biodata.aboutMe, style: GoogleFonts.poppins(fontSize: theme.bodyFontSize, color: text)),
      ));
    }

    // Sections from config
    for (final section in kSections) {
      final sectionFields = section.fields.where((f) => f.value(biodata).isNotEmpty).toList();
      final sectionCustom = biodata.customFields.where((c) => c.section == section.key && c.value.isNotEmpty).toList();
      final showSiblings = section.key == 'family' &&
          biodata.siblings.any((s) => s.name.trim().isNotEmpty || s.occupation.trim().isNotEmpty || s.maritalStatus.trim().isNotEmpty);
      if (sectionFields.isEmpty && sectionCustom.isEmpty && !showSiblings) continue;

      widgets.add(_flutterSectionHeading(context, section.key, section.title, primary, theme, onEditSection));
      widgets.add(SizedBox(height: theme.fieldSpacing));

      for (final field in sectionFields) {
        widgets.add(_flutterFieldRow(field.label, field.value(biodata), subtitle, text, theme));
      }

      // Dynamic sibling rows inside the Family Details section
      if (showSiblings) {
        for (final sibling in biodata.siblings) {
          final display = _siblingDisplay(sibling, biodata.siblings);
          if (display.value.isEmpty) continue;
          widgets.add(_flutterFieldRow(display.label, display.value, subtitle, text, theme, translateLabel: false));
        }
      }

      for (final cf in sectionCustom) {
        widgets.add(_flutterFieldRow(cf.label, cf.value, subtitle, text, theme, translateLabel: false));
      }

      widgets.add(SizedBox(height: theme.sectionSpacing));
    }

    // Additional Details section for orphan custom fields
    final orphanCustomFields = biodata.customFields.where((c) => c.value.isNotEmpty && !kSections.any((s) => s.key == c.section)).toList();
    if (orphanCustomFields.isNotEmpty) {
      widgets.add(_flutterSectionHeading(context, 'additional', 'Additional Details', primary, theme, onEditSection));
      widgets.add(SizedBox(height: theme.fieldSpacing));
      for (final cf in orphanCustomFields) {
        widgets.add(_flutterFieldRow(cf.label, cf.value, subtitle, text, theme, translateLabel: false));
      }
      widgets.add(SizedBox(height: theme.sectionSpacing));
    }

    // Footer
    if (theme.footerDecoration == 'mandala_image_style') {
      widgets.add(SizedBox(height: theme.sectionSpacing));
      widgets.add(Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: primary, width: 4),
            top: BorderSide(color: primary, width: 1),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_border, color: primary, size: 16),
              const SizedBox(width: 8),
              Icon(Icons.star, color: primary, size: 24),
              const SizedBox(width: 8),
              Icon(Icons.star_border, color: primary, size: 16),
            ],
          ),
        ),
      ));
    } else {
      widgets.add(Container(
        height: 1.5,
        color: primary.withValues(alpha: 0.3),
        margin: EdgeInsets.only(top: theme.sectionSpacing),
      ));
    }
    widgets.add(SizedBox(height: 8));
    widgets.add(Center(
      child: Text('Created with Biodata Maker', style: GoogleFonts.poppins(fontSize: 10, color: subtitle)),
    ));

    return widgets;
  }

  static Widget _buildFlutterHeader(
    Biodata biodata, ThemeConfig theme, Color primary, Color text, Color subtitle, String displayName,
  ) {
    final borderRadius = theme.photoShape == 'circle' ? BorderRadius.circular(40) : BorderRadius.circular(12);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: biodata.profilePhotoPath.isNotEmpty ? null : primary,
            borderRadius: borderRadius,
            border: biodata.profilePhotoPath.isNotEmpty ? Border.all(color: primary, width: 2) : null,
          ),
          child: biodata.profilePhotoPath.isNotEmpty
              ? ClipRRect(
                  borderRadius: borderRadius,
                  child: Image.file(File(biodata.profilePhotoPath), width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _initialsWidget(displayName, primary)),
                )
              : Center(child: _initialsWidget(displayName, Colors.white)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayName, style: GoogleFonts.playfairDisplay(fontSize: theme.headingFontSize, color: text, fontWeight: FontWeight.bold)),
              if (biodata.age.isNotEmpty || biodata.gender.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text([biodata.age, biodata.gender].where((s) => s.isNotEmpty).join(' | '), style: GoogleFonts.poppins(fontSize: theme.bodyFontSize, color: subtitle)),
              ],
              if (biodata.occupation.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(biodata.occupation, style: GoogleFonts.poppins(fontSize: theme.bodyFontSize, color: subtitle)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  static Widget _initialsWidget(String name, Color color) {
    final initials = name.isEmpty ? '?' : name.trim().split(RegExp(r'\s+')).map((s) => s[0]).take(2).join().toUpperCase();
    return Text(initials, style: GoogleFonts.playfairDisplay(fontSize: 32, color: color, fontWeight: FontWeight.bold));
  }

  /// Section heading, optionally followed by a small edit button (used by the
  /// wizard's Review step to jump back to the matching form section). When no
  /// [onEditSection] callback is supplied the heading renders exactly as
  /// before, so other screens that reuse the renderer are unaffected.
  static Widget _flutterSectionHeading(
    BuildContext context,
    String sectionKey,
    String title,
    Color primary,
    ThemeConfig theme,
    void Function(String sectionKey)? onEditSection,
  ) {
    final heading = _flutterSectionTitle(Strings.tr(title), primary, theme);
    if (onEditSection == null) return heading;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        heading,
        const SizedBox(width: 6),
        _flutterEditIcon(context, sectionKey, Strings.tr(title), primary, onEditSection),
      ],
    );
  }

  /// The small pencil used next to section headings and the header in the
  /// review/preview mode, keyed [editSection-<sectionKey>] for tests.
  static Widget _flutterEditIcon(
    BuildContext context,
    String sectionKey,
    String editLabel,
    Color primary,
    void Function(String sectionKey) onEditSection,
  ) {
    return Tooltip(
      message: '${Strings.tr('Edit')} $editLabel',
      child: InkWell(
        key: ValueKey('editSection-$sectionKey'),
        borderRadius: BorderRadius.circular(14),
        onTap: () => onEditSection(sectionKey),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Icon(Icons.edit_outlined, size: 15, color: primary),
        ),
      ),
    );
  }

  static Widget _flutterSectionTitle(String title, Color primary, ThemeConfig theme) {
    if (theme.headerDecoration == 'pill') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title.toUpperCase(),
          style: GoogleFonts.poppins(fontSize: theme.headingFontSize - 6, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
    return Text(title, style: GoogleFonts.playfairDisplay(fontSize: theme.headingFontSize - 4, color: primary, fontWeight: FontWeight.bold));
  }

  static Widget _flutterFieldRow(
    String label,
    String value,
    Color subtitle,
    Color text,
    ThemeConfig theme, {
    bool translateLabel = true,
  }) {
    // Predefined field labels are UI copy and get translated; sibling and
    // custom-field labels are user-entered data and stay as typed.
    final shownLabel = translateLabel ? Strings.tr(label) : label;
    return Padding(
      padding: EdgeInsets.only(bottom: theme.fieldSpacing / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(shownLabel, style: GoogleFonts.poppins(fontSize: theme.bodyFontSize, color: subtitle, fontWeight: FontWeight.w600))),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: theme.bodyFontSize, color: text))),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PDF mode
  // ---------------------------------------------------------------------------
  //
  // Content is emitted as a flat list of small, unbreakable "blocks". MultiPage
  // (see PdfService) lays these blocks out one after another and moves any block
  // that does not fit on the current page to the next page, so:
  //   * content always flows cleanly across pages (no clipping),
  //   * page breaks only ever occur between rows,
  //   * every section heading is glued to the first row below it (no orphan
  //     headings at the bottom of a page), and
  //   * very long values are split into several blocks first, so no single
  //     block can ever grow taller than one page.
  //
  // The horizontal inset keeps text clear of the per-page frame drawn by
  // PdfService.

  static const double _pdfPageInset = 4;
  // Chunk caps keep any single PDF block far below the usable page height:
  // wrapped lines plus explicit newlines mean a text of N characters can still
  // render ~N/30 lines, and a block between the usable height and the full
  // page height makes MultiPage retry forever (TooManyPagesException).
  static const int _pdfRowChunkChars = 900;
  static const int _pdfParagraphChunkChars = 1100;

  /// Splits [text] into chunks of at most [maxChars] characters, breaking on
  /// word boundaries so the resulting blocks wrap naturally across pages.
  static List<String> _pdfChunkText(String text, int maxChars) {
    if (text.length <= maxChars) return [text];
    final chunks = <String>[];
    var start = 0;
    while (start < text.length) {
      var end = start + maxChars;
      if (end > text.length) end = text.length;
      if (end < text.length) {
        final space = text.lastIndexOf(' ', end);
        if (space > start + maxChars ~/ 2) end = space;
      }
      chunks.add(text.substring(start, end).trim());
      if (end == start) break; // defensive: never stall on a zero-width chunk
      start = end;
    }
    return chunks;
  }

  /// Groups children into a single unbreakable PDF block: either the whole
  /// group fits on a page or it is moved to the next page as one unit.
  static pw.Widget _pdfKeepTogether(List<pw.Widget> children) {
    return pw.Container(
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  /// One page-safe content block: an atomic widget plus the small horizontal
  /// inset that keeps text clear of the per-page decorative frame.
  static pw.Widget _pdfPageBlock(pw.Widget child) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: _pdfPageInset),
      child: child,
    );
  }

  /// Turns a label/value pair into one row per chunk of the value (long values
  /// become several consecutive rows with the same label).
  static List<pw.Widget> _pdfValueRows(
    String label,
    String value,
    PdfColor subtitle,
    PdfColor text,
    ThemeConfig theme,
  ) {
    return [
      for (final chunk in _pdfChunkText(value, _pdfRowChunkChars))
        _pdfFieldRow(label, chunk, subtitle, text, theme),
    ];
  }

  static List<pw.Widget> toPdfWidgets(Biodata biodata, ThemeConfig theme, {pw.MemoryImage? profileImage}) {
    final primary = PdfColor.fromInt(theme.primaryColor);
    final text = PdfColor.fromInt(theme.textColor);
    final subtitle = PdfColor.fromInt(theme.subtitleColor);
    final displayName = biodata.fullName.isNotEmpty ? biodata.fullName : biodata.name;

    final blocks = <pw.Widget>[];
    void add(pw.Widget block) => blocks.add(_pdfPageBlock(block));

    // ---- Header ----
    add(_buildPdfHeader(biodata, theme, primary, text, subtitle, displayName, profileImage));
    blocks.add(pw.SizedBox(height: theme.sectionSpacing));

    // ---- About Me (heading kept with the first paragraph block) ----
    if (biodata.aboutMe.isNotEmpty) {
      final chunks = _pdfChunkText(biodata.aboutMe, _pdfParagraphChunkChars);
      add(_pdfKeepTogether([
        _pdfSectionTitle('About Me', primary, theme),
        pw.SizedBox(height: theme.fieldSpacing),
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 12),
          child: pw.Text(chunks.first, style: pw.TextStyle(font: _pdfFont(), fontSize: theme.bodyFontSize, color: text)),
        ),
      ]));
      for (var i = 1; i < chunks.length; i++) {
        add(pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 12),
          child: pw.Text(chunks[i], style: pw.TextStyle(font: _pdfFont(), fontSize: theme.bodyFontSize, color: text)),
        ));
      }
    }

    // ---- Sections ----
    for (final section in kSections) {
      final sectionFields = section.fields.where((f) => f.value(biodata).isNotEmpty).toList();
      final sectionCustom = biodata.customFields.where((c) => c.section == section.key && c.value.isNotEmpty).toList();
      final showSiblings = section.key == 'family' &&
          biodata.siblings.any((s) => s.name.trim().isNotEmpty || s.occupation.trim().isNotEmpty || s.maritalStatus.trim().isNotEmpty);
      if (sectionFields.isEmpty && sectionCustom.isEmpty && !showSiblings) continue;

      final rows = <pw.Widget>[];
      for (final field in sectionFields) {
        rows.addAll(_pdfValueRows(field.label, field.value(biodata), subtitle, text, theme));
      }

      // Dynamic sibling rows inside the Family Details section
      if (showSiblings) {
        for (final sibling in biodata.siblings) {
          final display = _siblingDisplay(sibling, biodata.siblings);
          if (display.value.isEmpty) continue;
          rows.addAll(_pdfValueRows(display.label, display.value, subtitle, text, theme));
        }
      }

      for (final cf in sectionCustom) {
        rows.addAll(_pdfValueRows(cf.label, cf.value, subtitle, text, theme));
      }

      // Section heading + its first row are one unbreakable block, so a page
      // break can never leave a heading stranded at the bottom of a page.
      add(_pdfKeepTogether([
        _pdfSectionTitle(section.title, primary, theme),
        pw.SizedBox(height: theme.fieldSpacing),
        rows.removeAt(0),
      ]));
      for (final row in rows) {
        add(row);
      }
      blocks.add(pw.SizedBox(height: theme.sectionSpacing));
    }

    // ---- Orphan custom fields under an "Additional Details" heading ----
    final orphanCustomFields = biodata.customFields.where((c) => c.value.isNotEmpty && !kSections.any((s) => s.key == c.section)).toList();
    if (orphanCustomFields.isNotEmpty) {
      final rows = <pw.Widget>[];
      for (final cf in orphanCustomFields) {
        rows.addAll(_pdfValueRows(cf.label, cf.value, subtitle, text, theme));
      }
      add(_pdfKeepTogether([
        _pdfSectionTitle('Additional Details', primary, theme),
        pw.SizedBox(height: theme.fieldSpacing),
        rows.removeAt(0),
      ]));
      for (final row in rows) {
        add(row);
      }
      blocks.add(pw.SizedBox(height: theme.sectionSpacing));
    }

    // ---- Closing rule + credit line (glued together, moved as one unit) ----
    add(_pdfKeepTogether([
      // The section loop above already leaves a sectionSpacing gap after the
      // final section; the original single-page layout added a second one only
      // for the tall mandala decoration.
      if (theme.footerDecoration == 'mandala_image_style')
        pw.SizedBox(height: theme.sectionSpacing),
      if (theme.footerDecoration == 'mandala_image_style')
        pw.Container(
          height: 40,
          decoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: primary, width: 4),
              top: pw.BorderSide(color: primary, width: 1),
            ),
          ),
          child: pw.Center(
            child: pw.Text('*   *   *', style: pw.TextStyle(font: _pdfFont(), fontSize: 24, color: primary, fontWeight: pw.FontWeight.bold)),
          ),
        )
      else
        pw.Container(height: 1.5, color: PdfColor.fromInt((theme.primaryColor & 0x00FFFFFF) | (0x4D << 24))),
      pw.SizedBox(height: 8),
      pw.Center(child: pw.Text('Created with Biodata Maker', style: pw.TextStyle(font: _pdfFont(), fontSize: 10, color: subtitle))),
    ]));

    return blocks;
  }

  static pw.Font _pdfFont() => pw.Font.helvetica();

  static pw.Widget _buildPdfHeader(
    Biodata biodata, ThemeConfig theme, PdfColor primary, PdfColor text, PdfColor subtitle, String displayName, pw.MemoryImage? profileImage,
  ) {
    final radius = theme.photoShape == 'circle' ? 40.0 : 12.0;
    final borderRadius = pw.BorderRadius.circular(radius);
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 80, height: 80,
            decoration: pw.BoxDecoration(
              color: profileImage != null ? null : primary,
              borderRadius: borderRadius,
              border: profileImage != null ? pw.Border.all(color: primary, width: 2) : null,
            ),
            child: profileImage != null
                ? (theme.photoShape == 'circle'
                    ? pw.ClipOval(
                        child: pw.Image(profileImage, fit: pw.BoxFit.cover, width: 80, height: 80),
                      )
                    : pw.ClipRRect(
                        horizontalRadius: radius,
                        verticalRadius: radius,
                        child: pw.Image(profileImage, fit: pw.BoxFit.cover, width: 80, height: 80),
                      ))
                : pw.Center(
                    child: pw.Text(
                      displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                      style: pw.TextStyle(font: _pdfFont(), fontSize: 32, color: PdfColor.fromInt(0xFFFFFFFF), fontWeight: pw.FontWeight.bold),
                    ),
                  ),
          ),
          pw.SizedBox(width: 16),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(displayName, style: pw.TextStyle(font: _pdfFont(), fontSize: theme.headingFontSize, color: text, fontWeight: pw.FontWeight.bold)),
                if (biodata.age.isNotEmpty || biodata.gender.isNotEmpty)
                  pw.Padding(padding: const pw.EdgeInsets.only(top: 4), child: pw.Text([biodata.age, biodata.gender].where((s) => s.isNotEmpty).join(' | '), style: pw.TextStyle(font: _pdfFont(), fontSize: theme.bodyFontSize, color: subtitle))),
                if (biodata.occupation.isNotEmpty)
                  pw.Padding(padding: const pw.EdgeInsets.only(top: 4), child: pw.Text(biodata.occupation, style: pw.TextStyle(font: _pdfFont(), fontSize: theme.bodyFontSize, color: subtitle))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _pdfSectionTitle(String title, PdfColor primary, ThemeConfig theme) {
    if (theme.headerDecoration == 'pill') {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: pw.BoxDecoration(
            color: primary,
            borderRadius: pw.BorderRadius.circular(20),
          ),
          child: pw.Text(
            title.toUpperCase(),
            style: pw.TextStyle(font: _pdfFont(), fontSize: theme.headingFontSize - 6, color: PdfColor.fromInt(0xFFFFFFFF), fontWeight: pw.FontWeight.bold),
          ),
        ),
      );
    }
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(title, style: pw.TextStyle(font: _pdfFont(), fontSize: theme.headingFontSize - 4, color: primary, fontWeight: pw.FontWeight.bold)),
    );
  }

  static pw.Widget _pdfFieldRow(String label, String value, PdfColor subtitle, PdfColor text, ThemeConfig theme) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: 110, child: pw.Text(label, style: pw.TextStyle(font: _pdfFont(), fontSize: theme.bodyFontSize, color: subtitle, fontWeight: pw.FontWeight.bold))),
          pw.Expanded(child: pw.Text(value, style: pw.TextStyle(font: _pdfFont(), fontSize: theme.bodyFontSize, color: text))),
        ],
      ),
    );
  }
}
