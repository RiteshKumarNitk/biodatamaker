import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:biodata_maker/core/services/export_service.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/settings/data/models/user_settings.dart';
import 'package:biodata_maker/features/settings/data/repositories/settings_repository.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/shared/widgets/biodata_renderer.dart';

class PdfService {
  static final PdfService _instance = PdfService._internal();
  factory PdfService() => _instance;
  PdfService._internal();

  /// Returns the [PdfPageFormat] matching the user's page-size preference.
  static PdfPageFormat _pageFormat(UserSettings settings) {
    switch (settings.pdfPageSize) {
      case 'Letter':
        return PdfPageFormat.letter;
      case 'A4':
      default:
        return PdfPageFormat.a4;
    }
  }

  /// Returns a DPI multiplier based on the user's quality preference.
  /// High = 200 DPI, Medium = 150 DPI, Low = 100 DPI.
  static double _qualityDpi(UserSettings settings) {
    switch (settings.pdfQuality) {
      case 'medium':
        return 150;
      case 'low':
        return 100;
      case 'high':
      default:
        return 200;
    }
  }

  Future<Uint8List> generatePdf(Biodata biodata, ThemeConfig theme, {UserSettings? settings}) async {
    final pageFormat = settings != null ? _pageFormat(settings) : PdfPageFormat.a4;
    final normal = await _renderPdf(biodata, theme, pageFormat: pageFormat);
    if (_pageCount(normal) <= 1) return normal;

    final compact = await _renderPdf(biodata, theme.copyWith(
      sectionSpacing: theme.sectionSpacing * 0.85,
      fieldSpacing: theme.fieldSpacing * 0.85,
      bodyFontSize: (theme.bodyFontSize * 0.9).clamp(theme.minFontSize, theme.maxFontSize),
      headingFontSize: (theme.headingFontSize * 0.9).clamp(theme.minFontSize, theme.maxFontSize),
    ), pageFormat: pageFormat);
    final countCompact = _pageCount(compact);
    if (countCompact <= 1) return compact;

    return normal;
  }

  static int _pageCount(Uint8List bytes) {
    final ascii = String.fromCharCodes(bytes);
    final counts = RegExp(r'/Count\s+(\d+)').allMatches(ascii).map((m) => int.parse(m.group(1)!));
    return counts.isEmpty ? 1 : counts.reduce(math.max);
  }

  Future<Uint8List> _renderPdf(Biodata biodata, ThemeConfig theme, {PdfPageFormat? pageFormat}) async {
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
    pw.Font? bodyFont;
    if (biodata.customSecondaryFont.isNotEmpty) {
      bodyFont = await BiodataRenderer.loadPdfFont(biodata.customSecondaryFont);
    }
    
    final fallbacks = <pw.Font>[];
    if (biodata.language == 'hi') {
      try {
        fallbacks.add(await PdfGoogleFonts.notoSansDevanagariRegular());
      } catch (_) {}
    }
    
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
        ? pw.SizedBox(height: (theme.contentAreaTop - theme.continuationContentAreaTop).clamp(0.0, double.infinity))
        : null;
    final resolvedMargin = biodata.customMargin > 0 ? biodata.customMargin : theme.margin;
    final pageMargin = useImageLayout
        ? pw.EdgeInsets.fromLTRB(
            theme.contentAreaLeft,
            theme.continuationContentAreaTop,
            theme.contentAreaRight,
            theme.contentAreaBottom,
          )
        : pw.EdgeInsets.all(resolvedMargin);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: pageFormat ?? PdfPageFormat.a4,
          margin: pageMargin,
          theme: pw.ThemeData.withFont(base: font, fontFallback: fallbacks),
          buildBackground: (context) => _buildPageBackground(
            theme,
            biodata,
            isFirstPage: context.pageNumber == 1,
            backgroundImage: backgroundImage,
            continuationBackgroundImage: continuationBackgroundImage,
          ),
          buildForeground: (context) => _buildPageForeground(
            context,
            theme,
            font,
            biodata: biodata,
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
    ThemeConfig theme,
    Biodata biodata, {
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

    final bgColor = biodata.customBackgroundColor > 0 ? biodata.customBackgroundColor : theme.backgroundColor;
    final primaryColor = biodata.customPrimaryColor > 0 ? biodata.customPrimaryColor : theme.primaryColor;

    final container = pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(bgColor),
        image: pageImage != null ? pw.DecorationImage(image: pageImage, fit: pw.BoxFit.cover) : null,
        borderRadius: pageImage != null ? null : pw.BorderRadius.circular(10),
        border: pageImage != null || theme.borderStyle == 'none'
            ? null
            : pw.Border.all(color: PdfColor.fromInt(primaryColor), width: 1.2),
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
    required Biodata biodata,
    required pw.MemoryImage? profileImage,
    required String displayName,
  }) {
    final showPhotoOverlay = theme.backgroundImage.isNotEmpty && context.pageNumber == 1;

    final stack = pw.Stack(
      children: [
        if (showPhotoOverlay)
          pw.Positioned(
            left: biodata.photoAlignment == 'right' ? null : theme.photoRectLeft,
            right: biodata.photoAlignment == 'right' ? theme.photoRectLeft : null,
            top: theme.photoRectTop,
            child: BiodataRenderer.pdfPhotoBox(
              theme,
              biodata,
              profileImage,
              displayName,
              width: theme.photoRectWidth * (biodata.customPhotoSize > 0 ? biodata.customPhotoSize : 1.0),
              height: theme.photoRectHeight * (biodata.customPhotoSize > 0 ? biodata.customPhotoSize : 1.0),
              customFont: font,
            ),
          ),
        if (biodata.showWatermark)
          pw.Positioned(
            bottom: 5,
            right: 5,
            child: pw.Text(
              'Made with Biodata Maker',
              style: pw.TextStyle(
                font: font,
                fontSize: 8,
                color: PdfColors.grey500,
              ),
            ),
          ),
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
    final file = File('${dir.path}/${_pdfName(biodata)}');
    await file.writeAsBytes(pdf);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: '${biodata.fullName} - Biodata'),
    );
  }

  static String _pdfName(Biodata biodata) =>
      '${biodata.fullName.replaceAll(' ', '_')}_biodata.pdf';

  /// Generates the PDF and saves it somewhere the user can find it: the
  /// device Downloads folder (Android, via MediaStore) or the app documents
  /// directory (iOS/desktop, where users export through the share sheet).
  /// Returns the [ExportResult] describing where it landed.
  Future<ExportResult> savePdfVisible(Biodata biodata, ThemeConfig theme) async {
    final pdf = await generatePdf(biodata, theme);
    final result = await sl<ExportService>().savePdfBytesToDownloads(pdf, _pdfName(biodata));
    if (result.location == ExportLocation.appDocuments && !Platform.isAndroid) {
      return result; // iOS/desktop: app documents is the norm; share via UI
    }
    return result;
  }

  /// Legacy direct-path save (kept for callers that need the raw file path).
  Future<String> savePdf(Biodata biodata, ThemeConfig theme) async {
    final pdf = await generatePdf(biodata, theme);
    final dir = await getApplicationDocumentsDirectory();
    final fileName = _pdfName(biodata);
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
    UserSettings? settings,
  }) async {
    final resolvedDpi = settings != null ? _qualityDpi(settings) : dpi;
    final pdf = await generatePdf(biodata, theme, settings: settings);
    final raster = await Printing.raster(pdf, pages: [page], dpi: resolvedDpi).first;
    return raster.toPng();
  }

  /// Rasterized PNG saved straight into the device gallery so it shows up in
  /// Photos/Files immediately. Returns the [ExportResult] for UI messaging.
  Future<ExportResult> saveImage(Biodata biodata, ThemeConfig theme, {int page = 0}) async {
    final png = await renderPageImage(biodata, theme, page: page);
    final suffix = page > 0 ? '_page${page + 1}' : '';
    final fileName = '${biodata.fullName.replaceAll(' ', '_')}_biodata$suffix.png';
    return sl<ExportService>().saveImageToGallery(png, fileName);
  }

  Future<void> shareImage(Biodata biodata, ThemeConfig theme, {int page = 0}) async {
    final png = await renderPageImage(biodata, theme, page: page);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${biodata.fullName.replaceAll(' ', '_')}_biodata.png');
    await file.writeAsBytes(png);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: '${biodata.fullName} - Biodata'),
    );
  }
}
