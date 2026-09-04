import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:printing/printing.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
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
    setState(() => _isGenerating = true);
    try {
      final template = _template;
      final bytes = await _pdfService.generatePdf(widget.biodata, template);
      final dir = await getApplicationDocumentsDirectory();
      final fileName = '${widget.biodata.fullName.isNotEmpty ? widget.biodata.fullName.replaceAll(' ', '_') : 'my'}_biodata.pdf';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);
      _biodataRepo.incrementDownloadCount(widget.biodata.id);
      setState(() {
        _pdfBytes = bytes;
        _filePath = file.path;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() => _isGenerating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.tr('Failed to generate PDF')}: $e')),
        );
      }
    }
  }

  Future<void> _sharePdf() async {
    if (_filePath == null) return;
    try {
      await Share.shareXFiles(
        [XFile(_filePath!)],
        text: '${widget.biodata.fullName.isNotEmpty ? widget.biodata.fullName : 'Biodata'} - Marriage Biodata',
      );
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(Strings.tr('Generate & Download PDF'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(Strings.tr('Export your biodata as a high quality PDF, print or share directly'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
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
                          onPressed: _sharePdf,
                          icon: const Icon(Icons.share),
                          label: Text(Strings.tr('Share PDF File')),
                        ),
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
