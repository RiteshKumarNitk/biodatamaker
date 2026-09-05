import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:flutter/services.dart' show rootBundle;
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

    // PageTheme's build callbacks are synchronous, so background-image
    // assets must be loaded up front (same reason profileImage is above).
    pw.MemoryImage? backgroundImage;
    if (theme.backgroundImage.isNotEmpty) {
      backgroundImage = await _loadAssetImage(theme.backgroundImage);
    }
    pw.MemoryImage? continuationBackgroundImage;
    if (theme.continuationBackgroundMode == 'separate' && theme.continuationBackgroundImage.isNotEmpty) {
      continuationBackgroundImage = await _loadAssetImage(theme.continuationBackgroundImage);
    }

    final font = pw.Font.helvetica();
    final displayName = biodata.fullName.isNotEmpty ? biodata.fullName : biodata.name;
    final useImageLayout = theme.backgroundImage.isNotEmpty;

    // MultiPage splits content between the blocks returned by
    // BiodataRenderer.toPdfWidgets: each block is small and unbreakable, so
    // content longer than one page flows cleanly onto further pages instead of
    // being clipped. PageTheme keeps the themed background (and frame) painted
    // on every page, and the footer adds "Page X of Y".
    //
    // MultiPage margin is a single EdgeInsets for the whole document (it
    // cannot vary per page), so an image template's continuation-page art
    // must be designed to work within the same contentArea insets as page 1.
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: useImageLayout
              ? pw.EdgeInsets.fromLTRB(theme.contentAreaLeft, theme.contentAreaTop, theme.contentAreaRight, theme.contentAreaBottom)
              : pw.EdgeInsets.all(theme.margin),
          theme: pw.ThemeData.withFont(base: font),
          buildBackground: (context) => _buildPageBackground(
            theme,
            isFirstPage: context.pageNumber == 1,
            backgroundImage: backgroundImage,
            continuationBackgroundImage: continuationBackgroundImage,
          ),
          buildForeground: (context) => _buildPageForeground(
            context,
            theme,
            font,
            profileImage: profileImage,
            displayName: displayName,
          ),
        ),
        footer: (context) => _buildPageFooter(context, theme, font),
        build: (_) => BiodataRenderer.toPdfWidgets(biodata, theme, profileImage: profileImage),
      ),
    );

    return pdf.save();
  }

  /// Fills the whole content area with the theme background on every page.
  /// Legacy (no backgroundImage) templates keep the exact solid-color +
  /// frame-border look; image templates fill with the page-1 background
  /// image, or, on page 2+, whichever continuation strategy the template
  /// configures (reuse the main image, a separate continuation image, or
  /// none at all).
  static pw.Widget _buildPageBackground(
    ThemeConfig theme, {
    required bool isFirstPage,
    pw.MemoryImage? backgroundImage,
    pw.MemoryImage? continuationBackgroundImage,
  }) {
    pw.MemoryImage? pageImage;
    if (isFirstPage) {
      pageImage = backgroundImage;
    } else {
      switch (theme.continuationBackgroundMode) {
        case 'separate':
          pageImage = continuationBackgroundImage ?? backgroundImage;
          break;
        case 'reuse':
          pageImage = backgroundImage;
          break;
        default:
          pageImage = null;
      }
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(theme.backgroundColor),
        image: pageImage != null ? pw.DecorationImage(image: pageImage, fit: pw.BoxFit.cover) : null,
        borderRadius: pageImage != null ? null : pw.BorderRadius.circular(10),
        border: pageImage != null || theme.borderStyle == 'none'
            ? null
            : pw.Border.all(color: PdfColor.fromInt(theme.primaryColor), width: 1.2),
      ),
    );
  }

  /// Page overlay layer: the profile photo (image templates only, page 1
  /// only — biodata photos aren't repeated on continuation pages) stacked
  /// with the existing watermark.
  static pw.Widget _buildPageForeground(
    pw.Context context,
    ThemeConfig theme,
    pw.Font font, {
    required pw.MemoryImage? profileImage,
    required String displayName,
  }) {
    final showPhotoOverlay = theme.backgroundImage.isNotEmpty && context.pageNumber == 1;
    final showWatermark = theme.showWatermark && theme.watermarkText.isNotEmpty;
    if (!showPhotoOverlay && !showWatermark) return pw.SizedBox();

    return pw.Stack(
      children: [
        if (showPhotoOverlay)
          pw.Positioned(
            left: theme.photoRectLeft,
            top: theme.photoRectTop,
            child: BiodataRenderer.pdfPhotoBox(
              theme,
              profileImage,
              displayName,
              width: theme.photoRectWidth,
              height: theme.photoRectHeight,
            ),
          ),
        if (showWatermark) _buildWatermark(theme, font),
      ],
    );
  }

  Future<pw.MemoryImage?> _loadAssetImage(String assetPath) async {
    try {
      final data = await rootBundle.load(assetPath);
      return pw.MemoryImage(data.buffer.asUint8List());
    } catch (_) {
      return null;
    }
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
