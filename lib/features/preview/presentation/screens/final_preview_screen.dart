import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/core/services/pdf_service.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';

/// The exact, page-accurate final result: this screen renders the *actual*
/// generated PDF (via [PdfPreview], from the `printing` package) rather than
/// approximating it with the on-screen [BiodataRenderer] widget used
/// everywhere else — same page count, page breaks and wrapping the user will
/// get from Download/Print/Share, because it's the same
/// [PdfService.generatePdf] call underneath.
class FinalPreviewScreen extends StatelessWidget {
  final Biodata biodata;
  final ThemeConfig theme;

  const FinalPreviewScreen({super.key, required this.biodata, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.tr('Final Preview'))),
      body: PdfPreview(
        build: (format) => sl<PdfService>().generatePdf(biodata, theme),
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        actions: [
          PdfPreviewAction(
            icon: const Icon(Icons.share, color: Colors.green),
            onPressed: (context, build, format) => sl<PdfService>().sharePdf(biodata, theme),
          ),
          PdfPreviewAction(
            icon: const Icon(Icons.image_outlined),
            onPressed: (context, build, format) => _saveImage(context),
          ),
        ],
      ),
    );
  }

  Future<void> _saveImage(BuildContext context) async {
    try {
      final path = await sl<PdfService>().saveImage(biodata, theme);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.tr('Image saved to')}: $path')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.tr('Failed to save image')}: $e')),
        );
      }
    }
  }
}
