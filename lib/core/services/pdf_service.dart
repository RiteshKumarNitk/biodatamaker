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

  /// Top margin for continuation pages (page 2+) in image-mode templates.
  /// This is smaller than page 1's contentAreaTop so that continuation pages
  /// don't start with a large blank area.
  static const double _continuationPageMargin = 40.0;

  /// Renders [biodata] on [theme], favoring fitting it on one page: if
  /// normal spacing spills onto a second page, retries once with a ~15%
  /// more compact spacing/font preset and uses that instead when it actually
  /// gets it down to one page. Genuinely long content (still needs 2+ pages
  /// even compact) keeps the normal, more readable spacing and paginates as
  /// usual. This only affects the PDF — position/margin fields never change,
  /// and it's driven by the real render (page count of the actual output),
  /// not an estimate, since only the PDF has a "page" for content to spill
  /// off of (the on-screen preview is one continuous scroll either way).
  Future<Uint8List> generatePdf(Biodata biodata, ThemeConfig theme) async {
    final normal = await _renderPdf(biodata, theme);
    if (_pageCount(normal) <= 1) return normal;

    final compact = await _renderPdf(biodata, theme.copyWith(
      sectionSpacing: theme.sectionSpacing * 0.85,
      fieldSpacing: theme.fieldSpacing * 0.85,
      bodyFontSize: theme.bodyFontSize * 0.85,
      headingFontSize: theme.headingFontSize * 0.85,
    ));
    return _pageCount(compact) <= 1 ? compact : normal;
  }

  static int _pageCount(Uint8List bytes) {
    final ascii = String.fromCharCodes(bytes);
    final counts = RegExp(r'/Count\s+(\d+)').allMatches(ascii).map((m) => int.parse(m.group(1)!));
    return counts.isEmpty ? 1 : counts.reduce(math.max);
  }

  Future<Uint8List> _renderPdf(Biodata biodata, ThemeConfig theme) async {
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

    final font = await BiodataRenderer.loadPdfFont(biodata.selectedFontId);
    final displayName = biodata.fullName.isNotEmpty ? biodata.fullName : biodata.name;
    final useImageLayout = theme.backgroundImage.isNotEmpty;

    // MultiPage splits content between the blocks returned by
    // BiodataRenderer.toPdfWidgets: each block is small and unbreakable, so
    // content longer than one page flows cleanly onto further pages instead of
    // being clipped. PageTheme keeps the themed background (and frame) painted
    // on every page, and the footer adds "Page X of Y".
    //
    // For image-mode templates, we use a smaller page margin so continuation
    // pages (page 2+) start closer to the top instead of inheriting the large
    // contentAreaTop from page 1. A spacer block at the start of the content
    // pushes page 1's content down to the correct position.
    final firstPageSpacer = useImageLayout
        ? pw.SizedBox(height: (theme.contentAreaTop - _continuationPageMargin).clamp(0.0, double.infinity))
        : null;
    final pageMargin = useImageLayout
        ? pw.EdgeInsets.fromLTRB(
            theme.contentAreaLeft,
            _continuationPageMargin,
            theme.contentAreaRight,
            theme.contentAreaBottom,
          )
        : pw.EdgeInsets.all(theme.margin);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: pageMargin,
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
        build: (_) {
          final blocks = BiodataRenderer.toPdfWidgets(biodata, theme, profileImage: profileImage, customFont: font);
          if (firstPageSpacer != null) {
            return [firstPageSpacer, ...blocks];
          }
          return blocks;
        },
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

    final container = pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(theme.backgroundColor),
        image: pageImage != null ? pw.DecorationImage(image: pageImage, fit: pw.BoxFit.cover) : null,
        borderRadius: pageImage != null ? null : pw.BorderRadius.circular(10),
        border: pageImage != null || theme.borderStyle == 'none'
            ? null
            : pw.Border.all(color: PdfColor.fromInt(theme.primaryColor), width: 1.2),
      ),
    );

    // pw.PageTheme.buildBackground is otherwise sized to (and offset by) the
    // margin-derived content box, not the physical page — fine for the
    // legacy inset color+border "framed box" look, but a background image
    // must cover the page edge-to-edge. FullPage(ignoreMargins: true)
    // escapes that box to the true page bounds (see the pdf package's own
    // watermark example, which uses the same pattern for full-bleed content).
    return pageImage != null ? pw.FullPage(ignoreMargins: true, child: container) : container;
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

    final stack = pw.Stack(
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
              customFont: font,
            ),
          ),
        if (showWatermark) _buildWatermark(theme, font),
      ],
    );

    // photoRect is defined in true page-absolute coordinates, so it needs to
    // escape the margin-derived content box the same way the background
    // image does (see _buildPageBackground) — otherwise it lands offset by
    // the margin instead of at the configured position.
    return showPhotoOverlay ? pw.FullPage(ignoreMargins: true, child: stack) : stack;
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

  /// Rasterizes one page of the generated PDF to a PNG, so the exported
  /// image is pixel-identical to that PDF page (same template, same layout,
  /// same data) rather than a separately-rendered approximation.
  Future<Uint8List> renderPageImage(
    Biodata biodata,
    ThemeConfig theme, {
    int page = 0,
    double dpi = 200,
  }) async {
    final pdf = await generatePdf(biodata, theme);
    final raster = await Printing.raster(pdf, pages: [page], dpi: dpi).first;
    return raster.toPng();
  }

  Future<String> saveImage(Biodata biodata, ThemeConfig theme, {int page = 0}) async {
    final png = await renderPageImage(biodata, theme, page: page);
    final dir = await getApplicationDocumentsDirectory();
    final suffix = page > 0 ? '_page${page + 1}' : '';
    final fileName = '${biodata.fullName.replaceAll(' ', '_')}_biodata$suffix.png';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(png);
    return file.path;
  }

  Future<void> shareImage(Biodata biodata, ThemeConfig theme, {int page = 0}) async {
    final png = await renderPageImage(biodata, theme, page: page);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${biodata.fullName.replaceAll(' ', '_')}_biodata.png');
    await file.writeAsBytes(png);
    await Share.shareXFiles([XFile(file.path)], text: '${biodata.fullName} - Biodata');
  }
}
