import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
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
    FieldConfig(label: 'Father', value: (b) => b.fatherName),
    FieldConfig(label: "Father's Occupation", value: (b) => b.fatherOccupation),
    FieldConfig(label: 'Mother', value: (b) => b.motherName),
    FieldConfig(label: "Mother's Occupation", value: (b) => b.motherOccupation),
    FieldConfig(label: 'Brothers', value: (b) => b.brothers),
    FieldConfig(label: 'Sisters', value: (b) => b.sisters),
    FieldConfig(label: 'Family Type', value: (b) => b.familyType),
    FieldConfig(label: 'Family Values', value: (b) => b.familyValues),
    FieldConfig(label: 'Native Place', value: (b) => b.nativePlace),
  ]),
  SectionConfig(key: 'lifestyle', title: 'Lifestyle & Interests', fields: [
    FieldConfig(label: 'Diet', value: (b) => b.diet),
    FieldConfig(label: 'Smoking', value: (b) => b.smoking),
    FieldConfig(label: 'Drinking', value: (b) => b.drinking),
    FieldConfig(label: 'Languages', value: (b) => b.languages),
    FieldConfig(label: 'Hobbies', value: (b) => b.hobbies),
    FieldConfig(label: 'Personality', value: (b) => b.personality),
  ]),
  SectionConfig(key: 'contact', title: 'Contact Information', fields: [
    FieldConfig(label: 'Mobile', value: (b) => b.mobile),
    FieldConfig(label: 'WhatsApp', value: (b) => b.whatsapp),
    FieldConfig(label: 'Email', value: (b) => b.email),
    FieldConfig(label: 'Address', value: (b) => b.address),
    FieldConfig(label: 'City', value: (b) => b.city),
    FieldConfig(label: 'State', value: (b) => b.state),
    FieldConfig(label: 'Country', value: (b) => b.country),
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

class BiodataRenderer extends StatelessWidget {
  final Biodata biodata;
  final ThemeConfig theme;

  const BiodataRenderer({super.key, required this.biodata, required this.theme});

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
          children: _buildFlutterSections(biodata, theme, primary, text, subtitle),
        ),
      ),
    );
  }

  static List<Widget> _buildFlutterSections(
    Biodata biodata,
    ThemeConfig theme,
    Color primary,
    Color text,
    Color subtitle,
  ) {
    final widgets = <Widget>[];
    final displayName = biodata.fullName.isNotEmpty ? biodata.fullName : biodata.name;

    // Header
    widgets.add(_buildFlutterHeader(biodata, theme, primary, text, subtitle, displayName));
    widgets.add(SizedBox(height: theme.sectionSpacing));

    // About Me
    if (biodata.aboutMe.isNotEmpty) {
      widgets.add(_flutterSectionTitle('About Me', primary, theme));
      widgets.add(SizedBox(height: theme.fieldSpacing));
      widgets.add(Padding(
        padding: EdgeInsets.only(bottom: theme.sectionSpacing),
        child: Text(biodata.aboutMe, style: GoogleFonts.poppins(fontSize: theme.bodyFontSize, color: text)),
      ));
    }

    // Sections from config
    for (final section in kSections) {
      final sectionFields = section.fields.where((f) => f.value(biodata).isNotEmpty).toList();
      if (sectionFields.isEmpty && biodata.customFields.where((c) => c.section == section.key).isEmpty) continue;

      widgets.add(_flutterSectionTitle(section.title, primary, theme));
      widgets.add(SizedBox(height: theme.fieldSpacing));

      for (final field in sectionFields) {
        widgets.add(_flutterFieldRow(field.label, field.value(biodata), subtitle, text, theme));
      }

      // Custom fields for this section
      final customFields = biodata.customFields.where((c) => c.section == section.key && c.value.isNotEmpty).toList();
      for (final cf in customFields) {
        widgets.add(_flutterFieldRow(cf.label, cf.value, subtitle, text, theme));
      }

      widgets.add(SizedBox(height: theme.sectionSpacing));
    }

    // Additional Details section for orphan custom fields
    final orphanCustomFields = biodata.customFields.where((c) => c.value.isNotEmpty && !kSections.any((s) => s.key == c.section)).toList();
    if (orphanCustomFields.isNotEmpty) {
      widgets.add(_flutterSectionTitle('Additional Details', primary, theme));
      widgets.add(SizedBox(height: theme.fieldSpacing));
      for (final cf in orphanCustomFields) {
        widgets.add(_flutterFieldRow(cf.label, cf.value, subtitle, text, theme));
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

  static Widget _flutterFieldRow(String label, String value, Color subtitle, Color text, ThemeConfig theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: theme.fieldSpacing / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: GoogleFonts.poppins(fontSize: theme.bodyFontSize, color: subtitle, fontWeight: FontWeight.w600))),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: theme.bodyFontSize, color: text))),
        ],
      ),
    );
  }

  // PDF mode
  static List<pw.Widget> toPdfWidgets(Biodata biodata, ThemeConfig theme) {
    final primary = PdfColor.fromInt(theme.primaryColor);
    final text = PdfColor.fromInt(theme.textColor);
    final subtitle = PdfColor.fromInt(theme.subtitleColor);
    final displayName = biodata.fullName.isNotEmpty ? biodata.fullName : biodata.name;

    final widgets = <pw.Widget>[];

    // Header
    widgets.add(_buildPdfHeader(biodata, theme, primary, text, subtitle, displayName));
    widgets.add(pw.SizedBox(height: theme.sectionSpacing));

    // About Me
    if (biodata.aboutMe.isNotEmpty) {
      widgets.add(_pdfSectionTitle('About Me', primary, theme));
      widgets.add(pw.SizedBox(height: theme.fieldSpacing));
      widgets.add(pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 12),
        child: pw.Text(biodata.aboutMe, style: pw.TextStyle(font: _pdfFont(), fontSize: theme.bodyFontSize, color: text)),
      ));
    }

    // Sections from config
    for (final section in kSections) {
      final sectionFields = section.fields.where((f) => f.value(biodata).isNotEmpty).toList();
      if (sectionFields.isEmpty) continue;

      widgets.add(_pdfSectionTitle(section.title, primary, theme));
      widgets.add(pw.SizedBox(height: theme.fieldSpacing));

      for (final field in sectionFields) {
        widgets.add(_pdfFieldRow(field.label, field.value(biodata), subtitle, text, theme));
      }
      widgets.add(pw.SizedBox(height: theme.sectionSpacing));
    }

    // Custom fields in Additional Details
    final customFields = biodata.customFields.where((c) => c.value.isNotEmpty).toList();
    if (customFields.isNotEmpty) {
      widgets.add(_pdfSectionTitle('Additional Details', primary, theme));
      widgets.add(pw.SizedBox(height: theme.fieldSpacing));
      for (final cf in customFields) {
        widgets.add(_pdfFieldRow(cf.label, cf.value, subtitle, text, theme));
      }
      widgets.add(pw.SizedBox(height: theme.sectionSpacing));
    }

    // Footer
    if (theme.footerDecoration == 'mandala_image_style') {
      widgets.add(pw.SizedBox(height: theme.sectionSpacing));
      widgets.add(pw.Container(
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
      ));
    } else {
      widgets.add(pw.Container(height: 1.5, color: PdfColor.fromInt((theme.primaryColor & 0x00FFFFFF) | (0x4D << 24))));
    }
    widgets.add(pw.SizedBox(height: 8));
    widgets.add(pw.Center(child: pw.Text('Created with Biodata Maker', style: pw.TextStyle(font: _pdfFont(), fontSize: 10, color: subtitle))));

    return widgets;
  }

  static pw.Font _pdfFont() => pw.Font.helvetica();

  static pw.Widget _buildPdfHeader(
    Biodata biodata, ThemeConfig theme, PdfColor primary, PdfColor text, PdfColor subtitle, String displayName,
  ) {
    final borderRadius = theme.photoShape == 'circle' ? pw.BorderRadius.circular(40) : pw.BorderRadius.circular(12);
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 80, height: 80,
            decoration: pw.BoxDecoration(
              color: primary,
              borderRadius: borderRadius,
            ),
            child: pw.Center(child: pw.Text(displayName.isNotEmpty ? displayName[0].toUpperCase() : '?', style: pw.TextStyle(font: _pdfFont(), fontSize: 32, color: PdfColor.fromInt(0xFFFFFFFF), fontWeight: pw.FontWeight.bold))),
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
