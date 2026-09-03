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

    final sections = BiodataRenderer.toPdfWidgets(biodata, theme, profileImage: profileImage);

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
                children: sections,
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
