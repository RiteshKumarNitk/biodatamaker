import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/core/services/pdf_service.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/biodata/data/repositories/biodata_repository.dart';
import 'package:biodata_maker/features/settings/data/repositories/settings_repository.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/features/templates/data/models/theme_engine.dart';
import 'package:biodata_maker/features/templates/data/repositories/template_repository.dart';
import 'package:biodata_maker/features/preview/presentation/screens/final_preview_screen.dart';
import 'package:biodata_maker/shared/widgets/biodata_renderer.dart';

class PreviewScreen extends StatefulWidget {
  final String biodataId;

  const PreviewScreen({super.key, required this.biodataId});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final BiodataRepository _biodataRepo = sl<BiodataRepository>();
  final TemplateRepository _templateRepo = sl<TemplateRepository>();
  final SettingsRepository _settingsRepo = sl<SettingsRepository>();
  final PdfService _pdfService = sl<PdfService>();

  Biodata? _biodata;
  late ThemeConfig _currentTheme;
  List<ThemeConfig> _allThemes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final biodata = _biodataRepo.getById(widget.biodataId);
    if (biodata == null) {
      setState(() => _isLoading = false);
      return;
    }
    _biodata = biodata;
    _allThemes = _templateRepo.getAll();
    if (_allThemes.isEmpty) {
      _allThemes = ThemeEngine.defaultTemplates;
    }
    final savedTheme = _templateRepo.getById(biodata.templateId);
    _currentTheme = savedTheme ?? ThemeEngine.defaultTemplates.first;
    setState(() => _isLoading = false);
  }

  void _changeTheme(ThemeConfig theme) {
    setState(() => _currentTheme = theme);
    _biodataRepo.save(_biodata!.copyWith(templateId: theme.id));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Preview')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_biodata == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Preview')),
        body: const Center(child: Text('Biodata not found')),
      );
    }

    final isPremium = _settingsRepo.isPremium;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Preview Final PDF',
            onPressed: () => _previewFinalPdf(context),
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined),
            tooltip: 'Print / Save as PDF',
            onPressed: () => _printPdf(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _allThemes.length,
              itemBuilder: (context, index) {
                final theme = _allThemes[index];
                final isSelected = theme.id == _currentTheme.id;
                return GestureDetector(
                  onTap: () => _changeTheme(theme),
                  child: Container(
                    width: 72,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Color(theme.primaryColor).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(
                              color: Color(theme.primaryColor), width: 2.5)
                          : Border.all(color: Colors.transparent),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Color(theme.primaryColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    theme.name.isNotEmpty
                                        ? theme.name[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                theme.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (theme.isPremium && !isPremium)
                          const Positioned(
                            top: 4,
                            right: 4,
                            child: Icon(Icons.lock, size: 14, color: Colors.amber),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BiodataRenderer(
                biodata: _biodata!,
                theme: _currentTheme,
              ),
            ),
          ),
          if (!isPremium)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Row(
                children: [
                  Icon(Icons.water_drop, color: Theme.of(context).colorScheme.tertiary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currentTheme.isPremium
                          ? 'This is a Premium Template. Go Premium to unlock & remove watermark.'
                          : 'Free version includes watermark. Go Premium to remove watermark & unlock all templates.',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _downloadPdf(context),
                  icon: Icon(_currentTheme.isPremium && !isPremium ? Icons.lock : Icons.download),
                  label: Text(_currentTheme.isPremium && !isPremium ? 'Unlock Template' : 'Download PDF'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _sharePdf(context),
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
              const SizedBox(width: 4),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                tooltip: 'More options',
                onSelected: (value) {
                  if (value == 'save_image') _saveImage(context);
                  if (value == 'share_image') _shareImage(context);
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'save_image', child: Text('Save Image')),
                  PopupMenuItem(value: 'share_image', child: Text('Share Image')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _previewFinalPdf(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => FinalPreviewScreen(biodata: _biodata!, theme: _currentTheme),
    ));
  }

  Future<void> _saveImage(BuildContext context) async {
    try {
      final path = await _pdfService.saveImage(_biodata!, _currentTheme);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image saved to: $path')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving image: $e')),
        );
      }
    }
  }

  Future<void> _shareImage(BuildContext context) async {
    try {
      await _pdfService.shareImage(_biodata!, _currentTheme);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing image: $e')),
        );
      }
    }
  }

  Future<void> _downloadPdf(BuildContext context) async {
    final isPremium = _settingsRepo.isPremium;
    if (_currentTheme.isPremium && !isPremium) {
      context.push('/paywall');
      return;
    }
    try {
      final path = await _pdfService.savePdf(_biodata!, _currentTheme);
      _biodataRepo.incrementDownloadCount(widget.biodataId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF saved successfully to: $path')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving PDF: $e')),
        );
      }
    }
  }

  Future<void> _printPdf(BuildContext context) async {
    final isPremium = _settingsRepo.isPremium;
    if (_currentTheme.isPremium && !isPremium) {
      context.push('/paywall');
      return;
    }
    try {
      await _pdfService.previewPdf(_biodata!, _currentTheme);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error preparing print preview: $e')),
        );
      }
    }
  }

  Future<void> _sharePdf(BuildContext context) async {
    final isPremium = _settingsRepo.isPremium;
    if (_currentTheme.isPremium && !isPremium) {
      context.push('/paywall');
      return;
    }
    try {
      await _pdfService.sharePdf(_biodata!, _currentTheme);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing PDF: $e')),
        );
      }
    }
  }
}
