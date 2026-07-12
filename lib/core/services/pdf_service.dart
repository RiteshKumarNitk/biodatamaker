import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/shared/widgets/biodata_renderer.dart';

class PdfService {
  static final PdfService _instance = PdfService._internal();
  factory PdfService() => _instance;
  PdfService._internal();

  Future<Uint8List> generatePdf(Biodata biodata, ThemeConfig theme) async {
    final pdf = pw.Document();
    final headingFont = pw.Font.helvetica();
    final bodyFont = pw.Font.helvetica();

    pw.MemoryImage? profileImage;
    if (biodata.profilePhotoPath.isNotEmpty) {
      profileImage = await _loadProfileImage(biodata.profilePhotoPath);
    }

    final sections = BiodataRenderer.toPdfWidgets(biodata, theme);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(theme.margin),
        build: (context) {
          final pageContent = <pw.Widget>[
            pw.Container(
              decoration: pw.BoxDecoration(
                color: PdfColor.fromInt(theme.backgroundColor),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(biodata, theme, headingFont, bodyFont, profileImage),
                  ...sections,
                ],
              ),
            ),
          ];

          if (theme.showWatermark && theme.watermarkText.isNotEmpty) {
            return [
              pw.Stack(
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: pageContent,
                  ),
                  pw.Positioned(
                    bottom: 40,
                    right: 40,
                    child: pw.Opacity(
                      opacity: 0.15,
                      child: pw.Transform.rotate(
                        angle: -math.pi / 4,
                        child: pw.Text(
                          theme.watermarkText,
                          style: pw.TextStyle(
                            fontSize: 48,
                            color: PdfColor.fromInt(theme.textColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ];
          }

          return pageContent;
        },
      ),
    );

    return pdf.save();
  }

  Future<pw.MemoryImage?> _loadProfileImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        return pw.MemoryImage(bytes);
      }
    } catch (_) {}
    return null;
  }

  pw.Widget _buildProfileHeader(
    Biodata biodata,
    ThemeConfig theme,
    pw.Font headingFont,
    pw.Font bodyFont,
    pw.MemoryImage? profileImage,
  ) {
    final primary = PdfColor.fromInt(theme.primaryColor);
    final text = PdfColor.fromInt(theme.textColor);
    final subtitle = PdfColor.fromInt(theme.subtitleColor);
    final radius = theme.photoShape == 'circle' ? 40.0 : 12.0;

    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 80,
            height: 80,
            decoration: pw.BoxDecoration(
              color: profileImage != null ? null : primary,
              borderRadius: pw.BorderRadius.circular(radius),
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
                      _getInitials(biodata.fullName),
                      style: pw.TextStyle(
                        font: headingFont,
                        fontSize: 28,
                        color: PdfColor.fromInt(0xFFFFFFFF),
                      ),
                    ),
                  ),
          ),
          pw.SizedBox(width: 16),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  biodata.fullName.isNotEmpty ? biodata.fullName : biodata.name,
                  style: pw.TextStyle(
                    font: headingFont,
                    fontSize: theme.headingFontSize,
                    color: text,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                if (biodata.age.isNotEmpty || biodata.gender.isNotEmpty)
                  pw.Text(
                    [biodata.age, biodata.gender].where((s) => s.isNotEmpty).join(' | '),
                    style: pw.TextStyle(font: bodyFont, fontSize: theme.bodyFontSize, color: subtitle),
                  ),
                if (biodata.occupation.isNotEmpty)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 4),
                    child: pw.Text(
                      biodata.occupation,
                      style: pw.TextStyle(font: bodyFont, fontSize: theme.bodyFontSize, color: subtitle),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Future<void> previewPdf(Biodata biodata, ThemeConfig theme) async {
    final pdf = await generatePdf(biodata, theme);
    await Printing.layoutPdf(onLayout: (_) => pdf);
  }

  Future<void> sharePdf(Biodata biodata, ThemeConfig theme) async {
    final pdf = await generatePdf(biodata, theme);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${biodata.fullName.replaceAll(' ', '_')}_biodata.pdf');
    await file.writeAsBytes(pdf);
    await Share.shareXFiles([XFile(file.path)], text: '${biodata.fullName} - Biodata');
  }

  Future<String> savePdf(Biodata biodata, ThemeConfig theme) async {
    final pdf = await generatePdf(biodata, theme);
    final dir = await getApplicationDocumentsDirectory();
    final fileName = '${biodata.fullName.replaceAll(' ', '_')}_biodata.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(pdf);
    return file.path;
  }
}
