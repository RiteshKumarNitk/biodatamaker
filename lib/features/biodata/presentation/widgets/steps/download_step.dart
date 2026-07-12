import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:biodata_maker/core/services/pdf_service.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/biodata/data/repositories/biodata_repository.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
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

  ThemeConfig? get _template =>
      widget.biodata.templateId.isNotEmpty ? _templateRepo.getById(widget.biodata.templateId) : null;

  Future<void> _generatePdf() async {
    setState(() => _isGenerating = true);
    try {
      final template = _template;
      if (template == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a template first')),
          );
        }
        setState(() => _isGenerating = false);
        return;
      }
      final bytes = await _pdfService.generatePdf(widget.biodata, template);
      final dir = await getApplicationDocumentsDirectory();
      final fileName = '${widget.biodata.fullName.replaceAll(' ', '_')}_biodata.pdf';
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
          SnackBar(content: Text('Failed to generate PDF: $e')),
        );
      }
    }
  }

  Future<void> _sharePdf() async {
    if (_filePath == null) return;
    try {
      await Share.shareXFiles(
        [XFile(_filePath!)],
        text: '${widget.biodata.fullName} - Biodata',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share: $e')),
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
        Text('Generate PDF', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('Download or share your biodata as a PDF', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Generate PDF', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                if (_isGenerating)
                  Column(
                    children: [
                      const LinearProgressIndicator(),
                      const SizedBox(height: 24),
                      const Center(child: CircularProgressIndicator()),
                      const SizedBox(height: 16),
                      Center(child: Text('Generating your biodata PDF...', style: theme.textTheme.bodyMedium)),
                    ],
                  )
                else if (_pdfBytes != null)
                  Column(
                    children: [
                      Center(
                        child: Icon(Icons.check_circle, size: 80, color: theme.colorScheme.primary)
                            .animate()
                            .scale(duration: 600.ms, curve: Curves.elasticOut)
                            .then()
                            .shimmer(duration: 1000.ms, color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'PDF generated successfully!',
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
                      FilledButton.icon(
                        onPressed: () async {
                          if (_filePath != null) {
                            try {
                              final file = File(_filePath!);
                              final dir = await getApplicationDocumentsDirectory();
                              final destPath = '${dir.path}/${widget.biodata.fullName.replaceAll(' ', '_')}_biodata.pdf';
                              await file.copy(destPath);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Saved to $destPath')),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Save failed: $e')),
                                );
                              }
                            }
                          }
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download'),
                      ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideX(begin: -0.2),
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
                        'Make sure you have selected a template and filled in all details',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _template == null ? null : _generatePdf,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Generate PDF'),
                      ),
                      if (_template == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Please select a template first',
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        if (_pdfBytes != null) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Share', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _sharePdf,
                      icon: const Icon(Icons.share),
                      label: const Text('Share PDF'),
                    ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideX(begin: -0.2),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 32),
      ],
    );
  }
}
