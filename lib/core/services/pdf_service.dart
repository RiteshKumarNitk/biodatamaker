import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:biodata_maker/data/models/biodata.dart';
import 'package:biodata_maker/data/models/theme_config.dart';

/// Service for generating PDF biodata documents.
class PdfService {
  /// Create a PdfColor with custom alpha (0.0-1.0).
  static PdfColor _alpha(PdfColor c, double a) =>
      PdfColor(c.red, c.green, c.blue, a);
  /// Generate a PDF document from biodata and theme config.
  static Future<pw.Document> generatePdf({
    required Biodata biodata,
    required ThemeConfig theme,
  }) async {
    final pdf = pw.Document();

    final primaryColor = PdfColor.fromInt(theme.primaryColor);
    final secondaryColor = PdfColor.fromInt(theme.secondaryColor);
    final textColor = PdfColor.fromInt(theme.textColor);
    final subtitleColor = PdfColor.fromInt(theme.subtitleColor);

    // Try to load fonts, fall back to built-in
    pw.Font? headingFont;
    pw.Font? bodyFont;
    try {
      final fontData = await PdfGoogleFonts.playfairDisplayRegular();
      headingFont = fontData;
    } catch (_) {}
    try {
      final fontData = await PdfGoogleFonts.poppinsRegular();
      bodyFont = fontData;
    } catch (_) {}

    final headingStyle = pw.TextStyle(
      font: headingFont,
      fontSize: theme.headingFontSize,
      fontWeight: pw.FontWeight.bold,
      color: textColor,
    );

    final bodyStyle = pw.TextStyle(
      font: bodyFont,
      fontSize: theme.bodyFontSize,
      color: textColor,
    );

    final subtitleStyle = pw.TextStyle(
      font: bodyFont,
      fontSize: theme.bodyFontSize - 1,
      color: subtitleColor,
    );

    final sectionStyle = pw.TextStyle(
      font: headingFont,
      fontSize: theme.bodyFontSize + 2,
      fontWeight: pw.FontWeight.bold,
      color: primaryColor,
    );

    // Build PDF page
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(theme.margin),
        build: (context) => [
          // ─── Header ─────────────────────────────────────────
          _buildHeader(biodata, theme, primaryColor, secondaryColor,
              headingStyle, bodyStyle, headingFont),

          pw.SizedBox(height: theme.sectionSpacing),

          // ─── Personal Details ───────────────────────────────
          _buildSection('Personal Details', [
            _infoRow('Full Name', biodata.fullName, bodyStyle, subtitleStyle),
            _infoRow('Age', biodata.age > 0 ? '${biodata.age} years' : '', bodyStyle, subtitleStyle),
            _infoRow('Religion', biodata.religion, bodyStyle, subtitleStyle),
            _infoRow('Caste', biodata.caste, bodyStyle, subtitleStyle),
            _infoRow('Mother Tongue', biodata.motherTongue, bodyStyle, subtitleStyle),
            _infoRow('Height', biodata.height, bodyStyle, subtitleStyle),
            _infoRow('Complexion', biodata.complexion, bodyStyle, subtitleStyle),
            _infoRow('Marital Status', biodata.maritalStatus, bodyStyle, subtitleStyle),
            _infoRow('Blood Group', biodata.bloodGroup, bodyStyle, subtitleStyle),
            _infoRow('Manglik', biodata.manglik, bodyStyle, subtitleStyle),
            _infoRow('Rashi', biodata.rashi, bodyStyle, subtitleStyle),
            _infoRow('Nakshatra', biodata.nakshatra, bodyStyle, subtitleStyle),
            _infoRow('Gotra', biodata.gotra, bodyStyle, subtitleStyle),
            _infoRow('Birth Place', biodata.birthPlace, bodyStyle, subtitleStyle),
            _infoRow('Birth Time', biodata.birthTime, bodyStyle, subtitleStyle),
          ], sectionStyle, primaryColor),

          pw.SizedBox(height: theme.sectionSpacing),

          // ─── About Me ───────────────────────────────────────
          if (biodata.aboutMe.isNotEmpty) ...[
            _buildSection('About Me', [
              pw.Paragraph(
                text: biodata.aboutMe,
                style: bodyStyle,
                textAlign: pw.TextAlign.left,
              ),
            ], sectionStyle, primaryColor),
            pw.SizedBox(height: theme.sectionSpacing),
          ],

          // ─── Education & Career ─────────────────────────────
          _buildSection('Education & Career', [
            _infoRow('Qualification', biodata.qualification, bodyStyle, subtitleStyle),
            _infoRow('College', biodata.college, bodyStyle, subtitleStyle),
            _infoRow('Occupation', biodata.occupation, bodyStyle, subtitleStyle),
            _infoRow('Designation', biodata.designation, bodyStyle, subtitleStyle),
            _infoRow('Company', biodata.company, bodyStyle, subtitleStyle),
            _infoRow('Annual Income', biodata.annualIncome, bodyStyle, subtitleStyle),
          ], sectionStyle, primaryColor),

          pw.SizedBox(height: theme.sectionSpacing),

          // ─── Family Details ─────────────────────────────────
          _buildSection('Family Details', [
            _infoRow("Father's Name", biodata.fatherName, bodyStyle, subtitleStyle),
            _infoRow("Father's Occupation", biodata.fatherOccupation, bodyStyle, subtitleStyle),
            _infoRow("Mother's Name", biodata.motherName, bodyStyle, subtitleStyle),
            _infoRow("Mother's Occupation", biodata.motherOccupation, bodyStyle, subtitleStyle),
            _infoRow('Brothers', biodata.brothers, bodyStyle, subtitleStyle),
            _infoRow('Sisters', biodata.sisters, bodyStyle, subtitleStyle),
            _infoRow('Family Type', biodata.familyType, bodyStyle, subtitleStyle),
            _infoRow('Family Values', biodata.familyValues, bodyStyle, subtitleStyle),
            _infoRow('Native Place', biodata.nativePlace, bodyStyle, subtitleStyle),
          ], sectionStyle, primaryColor),

          pw.SizedBox(height: theme.sectionSpacing),

          // ─── Lifestyle ──────────────────────────────────────
          _buildSection('Lifestyle', [
            _infoRow('Diet', biodata.diet, bodyStyle, subtitleStyle),
            _infoRow('Smoking', biodata.smoking, bodyStyle, subtitleStyle),
            _infoRow('Drinking', biodata.drinking, bodyStyle, subtitleStyle),
            _infoRow('Languages', biodata.languages, bodyStyle, subtitleStyle),
            _infoRow('Hobbies', biodata.hobbies, bodyStyle, subtitleStyle),
            _infoRow('Personality', biodata.personality, bodyStyle, subtitleStyle),
          ], sectionStyle, primaryColor),

          pw.SizedBox(height: theme.sectionSpacing),

          // ─── Partner Preferences ────────────────────────────
          _buildSection('Partner Preferences', [
            _infoRow('Preferred Age', biodata.preferredAge, bodyStyle, subtitleStyle),
            _infoRow('Preferred Height', biodata.preferredHeight, bodyStyle, subtitleStyle),
            _infoRow('Preferred Education', biodata.preferredEducation, bodyStyle, subtitleStyle),
            _infoRow('Preferred Occupation', biodata.preferredOccupation, bodyStyle, subtitleStyle),
            _infoRow('Preferred Religion', biodata.preferredReligion, bodyStyle, subtitleStyle),
            _infoRow('Preferred Location', biodata.preferredLocation, bodyStyle, subtitleStyle),
            if (biodata.expectations.isNotEmpty)
              pw.Paragraph(
                text: biodata.expectations,
                style: bodyStyle,
                margin: const pw.EdgeInsets.only(top: 4),
              ),
          ], sectionStyle, primaryColor),

          pw.SizedBox(height: theme.sectionSpacing),

          // ─── Contact Information ────────────────────────────
          _buildSection('Contact Information', [
            _infoRow('Mobile', biodata.mobile, bodyStyle, subtitleStyle),
            _infoRow('WhatsApp', biodata.whatsapp, bodyStyle, subtitleStyle),
            _infoRow('Email', biodata.email, bodyStyle, subtitleStyle),
            _infoRow('City', biodata.city, bodyStyle, subtitleStyle),
            _infoRow('State', biodata.state, bodyStyle, subtitleStyle),
            _infoRow('Country', biodata.country, bodyStyle, subtitleStyle),
          ], sectionStyle, primaryColor),

          // ─── Footer ─────────────────────────────────────────
          pw.SizedBox(height: theme.sectionSpacing * 2),
          pw.Divider(color: primaryColor),
          pw.SizedBox(height: 8),
          pw.Center(
            child: pw.Text(
              'Created with Biodata Maker',
              style: subtitleStyle.copyWith(
                fontSize: 10,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );

    return pdf;
  }

  /// Build the header section with name and photo placeholder
  static pw.Widget _buildHeader(
    Biodata biodata,
    ThemeConfig theme,
    PdfColor primaryColor,
    PdfColor secondaryColor,
    pw.TextStyle headingStyle,
    pw.TextStyle bodyStyle,
    pw.Font? headingFont,
  ) {
    return pw.Column(
      children: [
        // Photo placeholder
        if (theme.photoShape == 'circle')
          pw.Container(
            width: 80,
            height: 80,
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              color: _alpha(primaryColor, 0.1),
            ),
            child: pw.Center(
              child: pw.Text(
                biodata.fullName.isNotEmpty
                    ? biodata.fullName[0].toUpperCase()
                    : 'B',
                style: pw.TextStyle(
                  font: headingFont,
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          )
        else
          pw.Container(
            width: 80,
            height: 80,
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(8),
              color: _alpha(primaryColor, 0.1),
            ),
            child: pw.Center(
              child: pw.Text(
                biodata.fullName.isNotEmpty
                    ? biodata.fullName[0].toUpperCase()
                    : 'B',
                style: pw.TextStyle(
                  font: headingFont,
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ),

        pw.SizedBox(height: 12),

        // Name
        pw.Text(
          biodata.fullName.isNotEmpty ? biodata.fullName : biodata.name,
          style: headingStyle,
          textAlign: pw.TextAlign.center,
        ),

        // Occupation
        if (biodata.occupation.isNotEmpty) ...[
          pw.SizedBox(height: 4),
          pw.Text(
            biodata.occupation,
            style: bodyStyle.copyWith(color: secondaryColor),
            textAlign: pw.TextAlign.center,
          ),
        ],

        // Divider
        pw.SizedBox(height: 12),
        pw.Divider(color: primaryColor),
        pw.SizedBox(height: 8),
      ],
    );
  }

  /// Build a section with title and children
  static pw.Widget _buildSection(
    String title,
    List<pw.Widget> children,
    pw.TextStyle sectionStyle,
    PdfColor primaryColor,
  ) {
    final nonEmpty = children.where((w) {
      if (w is pw.Paragraph) return w.text?.isNotEmpty == true;
      return true;
    }).toList();

    if (nonEmpty.isEmpty) return pw.SizedBox.shrink();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: sectionStyle),
        pw.SizedBox(height: 6),
        pw.Divider(color: _alpha(primaryColor, 0.3)),
        pw.SizedBox(height: 6),
        ...nonEmpty,
      ],
    );
  }

  /// Build an info row (label: value)
  static pw.Widget _infoRow(
    String label,
    String value,
    pw.TextStyle bodyStyle,
    pw.TextStyle subtitleStyle,
  ) {
    if (value.isEmpty) return pw.SizedBox.shrink();

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              '$label:',
              style: subtitleStyle,
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: bodyStyle.copyWith(fontWeight: pw.FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  /// Preview PDF on device
  static Future<void> previewPdf({
    required Biodata biodata,
    required ThemeConfig theme,
  }) async {
    final pdf = await generatePdf(biodata: biodata, theme: theme);
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Biodata - ${biodata.fullName}',
    );
  }

  /// Share PDF
  static Future<void> sharePdf({
    required Biodata biodata,
    required ThemeConfig theme,
  }) async {
    final pdf = await generatePdf(biodata: biodata, theme: theme);
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Biodata - ${biodata.fullName}.pdf',
    );
  }
}
