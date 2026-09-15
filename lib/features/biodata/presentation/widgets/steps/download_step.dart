import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/core/services/ad_service.dart';
import 'package:biodata_maker/core/services/export_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:biodata_maker/core/services/pdf_service.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/biodata/data/repositories/biodata_repository.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/features/templates/data/models/theme_engine.dart';
import 'package:biodata_maker/features/templates/data/repositories/template_repository.dart';
import 'package:biodata_maker/shared/widgets/app_banner_ad.dart';

class DownloadStep extends StatefulWidget {
  final Biodata biodata;

  const DownloadStep({super.key, required this.biodata});

  @override
  State<DownloadStep> createState() => _DownloadStepState();
}

class _DownloadStepState extends State<DownloadStep> {
  final _pdfService = sl<PdfService>();
  final _templateRepo = sl<TemplateRepository>();
  final _biodataRepo = sl<BiodataRepository>();

  bool _isGenerating = false;
  Uint8List? _pdfBytes;
  String? _filePath;

  ThemeConfig get _template {
    if (widget.biodata.templateId.isNotEmpty) {
      final t = _templateRepo.getById(widget.biodata.templateId);
      if (t != null) return t;
    }
    return ThemeEngine.defaultTemplates.first;
  }

  Future<void> _generatePdf() async {
    if (!mounted) return;
    setState(() => _isGenerating = true);
    try {
      final template = _template;
      final bytes = await _pdfService.generatePdf(widget.biodata, template);
      // Persist where the user can find it: Downloads (Android) or app
      // documents elsewhere; keep the bytes for in-app preview/share.
      final result = await sl<ExportService>().savePdfBytesToDownloads(
        bytes,
        '${widget.biodata.fullName.isNotEmpty ? widget.biodata.fullName.replaceAll(' ', '_') : 'my'}_biodata.pdf',
      );
      final visiblePath = result.location == ExportLocation.downloads
          ? result.path // Downloads/VivahBio/<name>.pdf
          : (await getApplicationDocumentsDirectory()).path;
      _biodataRepo.incrementDownloadCount(widget.biodata.id);
      if (mounted) {
        setState(() {
          _pdfBytes = bytes;
          _filePath = result.location == ExportLocation.appDocuments
              ? result.path
              : null; // content in MediaStore; share from bytes instead
          _isGenerating = false;
        });
        if (result.location == ExportLocation.downloads) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.tr(result.nameKey))),
          );
        }
        sl<AdService>().showInterstitialAd();
      }
      assert(visiblePath.isNotEmpty);
    } catch (e) {
      if (mounted) {
        setState(() => _isGenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.tr('Failed to generate PDF')}: $e')),
        );
      }
    }
  }

  Future<void> _sharePdf() async {
    try {
      if (_filePath != null) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(_filePath!)],
            text: '${widget.biodata.fullName.isNotEmpty ? widget.biodata.fullName : 'Biodata'} - Marriage Biodata',
          ),
        );
      } else if (_pdfBytes != null) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/${widget.biodata.fullName.isNotEmpty ? widget.biodata.fullName.replaceAll(' ', '_') : 'biodata'}_biodata.pdf');
        await file.writeAsBytes(_pdfBytes!);
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path)],
            text: '${widget.biodata.fullName.isNotEmpty ? widget.biodata.fullName : 'Biodata'} - Marriage Biodata',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.tr('Failed to share')}: $e')),
        );
      }
    }
  }

  Future<void> _printOrSavePdf() async {
    if (_pdfBytes == null) {
      await _generatePdf();
    }
    if (_pdfBytes != null) {
      await Printing.layoutPdf(
        name: widget.biodata.fullName.isNotEmpty ? widget.biodata.fullName : 'Biodata',
        onLayout: (_) => _pdfBytes!,
      );
    }
  }

  Future<void> _openPdf() async {
    if (_filePath == null) return;
    final uri = Uri.file(_filePath!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No PDF viewer found on device')),
        );
      }
    }
  }

  Future<void> _saveImage() async {
    try {
      final result = await _pdfService.saveImage(widget.biodata, _template);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Strings.tr(result.nameKey))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.tr('Failed to save image')}: $e')),
        );
      }
    }
  }

  Future<void> _shareImage() async {
    try {
      await _pdfService.shareImage(widget.biodata, _template);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.tr('Failed to share')}: $e')),
        );
      }
    }
  }

  Future<void> _shareOnWhatsApp() async {
    if (_filePath == null) return;
    final name = widget.biodata.fullName.isNotEmpty ? widget.biodata.fullName : 'Biodata';
    final text = Uri.encodeComponent('Marriage Biodata for $name');
    final whatsappUrl = 'https://wa.me/?text=$text';
    final uri = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp is not installed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(Strings.tr('Preview & Download'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(Strings.tr('Review your biodata and export as PDF'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 16),
        // PDF Preview using the printing package's PdfPreview widget
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf_outlined, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(Strings.tr('PDF Preview'), style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              SizedBox(
                height: 400,
                child: PdfPreview(
                  build: (format) => _pdfService.generatePdf(widget.biodata, _template),
                  allowPrinting: false,
                  allowSharing: false,
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  canDebug: false,
                  useActions: false,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Center(child: AppBannerAd()),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.tr('PDF Document'), style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                if (_isGenerating)
                  Column(
                    children: [
                      const LinearProgressIndicator(),
                      const SizedBox(height: 24),
                      const Center(child: CircularProgressIndicator()),
                      const SizedBox(height: 16),
                      Center(child: Text(Strings.tr('Generating your biodata PDF...'), style: theme.textTheme.bodyMedium)),
                    ],
                  )
                else if (_pdfBytes != null)
                  Column(
                    children: [
                      Center(
                        child: Icon(Icons.check_circle, size: 72, color: theme.colorScheme.primary)
                            .animate()
                            .scale(duration: 500.ms, curve: Curves.elasticOut),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'PDF Generated Successfully!',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_filePath != null)
                        Center(
                          child: Text(
                            _filePath!.split('\\').last.split('/').last,
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton.icon(
                          onPressed: _openPdf,
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Open PDF'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: _printOrSavePdf,
                          icon: const Icon(Icons.print),
                          label: Text(Strings.tr('Print / Save as PDF')),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: _shareOnWhatsApp,
                          icon: const Icon(Icons.chat, color: Color(0xFF25D366)),
                          label: const Text('Share on WhatsApp'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: _sharePdf,
                          icon: const Icon(Icons.share),
                          label: Text(Strings.tr('Share PDF File')),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _saveImage,
                              icon: const Icon(Icons.image_outlined),
                              label: Text(Strings.tr('Save Image')),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _shareImage,
                              icon: const Icon(Icons.ios_share),
                              label: Text(Strings.tr('Share Image')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      Icon(Icons.picture_as_pdf, size: 64, color: theme.colorScheme.primary),
                      const SizedBox(height: 12),
                      Text(
                        'Ready to generate your biodata PDF',
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Template: ${_template.name} (${_template.category})',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton.icon(
                          onPressed: _generatePdf,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Generate PDF Now'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
