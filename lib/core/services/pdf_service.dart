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

    pw.MemoryImage? profileImage;
    if (biodata.profilePhotoPath.isNotEmpty) {
      profileImage = await _loadProfileImage(biodata.profilePhotoPath);
    }

    final font = pw.Font.helvetica();

    // MultiPage splits content between the blocks returned by
    // BiodataRenderer.toPdfWidgets: each block is small and unbreakable, so
    // content longer than one page flows cleanly onto further pages instead of
    // being clipped. PageTheme keeps the themed background (and frame) painted
    // on every page, and the footer adds "Page X of Y".
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(theme.margin),
          theme: pw.ThemeData.withFont(base: font),
          buildBackground: (_) => _buildPageBackground(theme),
          buildForeground: theme.showWatermark && theme.watermarkText.isNotEmpty
              ? (_) => _buildWatermark(theme, font)
              : null,
        ),
        footer: (context) => _buildPageFooter(context, theme, font),
        build: (_) => BiodataRenderer.toPdfWidgets(biodata, theme, profileImage: profileImage),
      ),
    );

    return pdf.save();
  }

  /// Fills the whole content area with the theme background on every page and,
  /// unless the theme opts out, draws the subtle frame border around it.
  static pw.Widget _buildPageBackground(ThemeConfig theme) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(theme.backgroundColor),
        borderRadius: pw.BorderRadius.circular(10),
        border: theme.borderStyle == 'none'
            ? null
            : pw.Border.all(color: PdfColor.fromInt(theme.primaryColor), width: 1.2),
      ),
    );
  }

  /// A fixed-height slot at the bottom of every page showing "Page X of Y"
  /// (hidden for single-page documents). The height is constant so content
  /// layout does not shift between pages.
  static pw.Widget _buildPageFooter(pw.Context context, ThemeConfig theme, pw.Font font) {
    return pw.SizedBox(
      height: 14,
      child: pw.Center(
        child: pw.Text(
          context.pagesCount > 1 ? 'Page ${context.pageNumber} of ${context.pagesCount}' : '',
          style: pw.TextStyle(font: font, fontSize: 9, color: PdfColor.fromInt(theme.subtitleColor)),
        ),
      ),
    );
  }

  /// Diagonal watermark, drawn on top of every page when enabled.
  static pw.Widget _buildWatermark(ThemeConfig theme, pw.Font font) {
    return pw.Stack(
      children: [
        pw.Positioned(
          bottom: 30,
          right: 30,
          child: pw.Opacity(
            opacity: 0.15,
            child: pw.Transform.rotate(
              angle: -math.pi / 4,
              child: pw.Text(
                theme.watermarkText,
                style: pw.TextStyle(fontSize: 48, font: font, color: PdfColor.fromInt(theme.textColor)),
              ),
            ),
          ),
        ),
      ],
    );
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
