import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/core/services/pdf_service.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/biodata/data/repositories/biodata_repository.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/features/templates/data/models/theme_engine.dart';
import 'package:biodata_maker/features/templates/data/repositories/template_repository.dart';
import 'package:biodata_maker/features/preview/presentation/screens/final_preview_screen.dart';
import 'package:biodata_maker/shared/widgets/biodata_renderer.dart';
import 'package:biodata_maker/shared/widgets/template_thumbnail.dart';

class PreviewScreen extends StatefulWidget {
  final String biodataId;

  const PreviewScreen({super.key, required this.biodataId});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final BiodataRepository _biodataRepo = sl<BiodataRepository>();
  final TemplateRepository _templateRepo = sl<TemplateRepository>();
  final PdfService _pdfService = sl<PdfService>();

  Biodata? _biodata;
  late ThemeConfig _currentTheme;
  List<ThemeConfig> _allThemes = [];
  bool _isLoading = true;
  double _fontScale = 1.0;

  ThemeConfig get _scaledTheme {
    return _currentTheme.copyWith(
      bodyFontSize: (_currentTheme.bodyFontSize * _fontScale).clamp(_currentTheme.minFontSize, _currentTheme.maxFontSize),
      headingFontSize: (_currentTheme.headingFontSize * _fontScale).clamp(_currentTheme.minFontSize, _currentTheme.maxFontSize),
      fieldSpacing: _currentTheme.fieldSpacing * _fontScale,
      sectionSpacing: _currentTheme.sectionSpacing * _fontScale,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    try {
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
    } catch (_) {
      _biodata = null;
      _allThemes = ThemeEngine.defaultTemplates;
      _currentTheme = ThemeEngine.defaultTemplates.first;
    }
    setState(() => _isLoading = false);
  }

  void _changeTheme(ThemeConfig theme) {
    setState(() {
      _currentTheme = theme;
      _fontScale = 1.0; // reset per-template scaling
    });
    _biodataRepo.save(_biodata!.copyWith(templateId: theme.id));
  }

  /// Bottom sheet with large, real-rendered template previews — replaces the
  /// old 80px strip of color swatches.
  void _openThemeSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.75,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Column(
                children: [
                  Text(
                    Strings.tr('Choose a Template'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.58,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _allThemes.length,
                      itemBuilder: (context, index) {
                        final theme = _allThemes[index];
                        final isSelected = theme.id == _currentTheme.id;
                        return _ThemePreviewCard(
                          theme: theme,
                          isSelected: isSelected,
                          onTap: () {
                            _changeTheme(theme);
                            Navigator.of(sheetContext).pop();
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(Strings.tr('Preview'))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_biodata == null) {
      return Scaffold(
        appBar: AppBar(title: Text(Strings.tr('Preview'))),
        body: Center(child: Text(Strings.tr('Biodata not found'))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.tr('Preview')),
        leading: Navigator.canPop(context) 
            ? null 
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/dashboard'),
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: Strings.tr('Preview Final PDF'),
            onPressed: () => _previewFinalPdf(context),
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined),
            tooltip: Strings.tr('Print / Save as PDF'),
            onPressed: () => _printPdf(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Compact template switcher row — opens the full sheet.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 44,
                    height: 60,
                    child: TemplateThumbnail(
                      template: _currentTheme,
                      width: 44,
                      height: 60,
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentTheme.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _currentTheme.category,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: _openThemeSheet,
                  icon: const Icon(Icons.palette_outlined, size: 18),
                  label: Text(Strings.tr('Change')),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  Strings.tr('Text Size'),
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                  onPressed: () => setState(
                      () => _fontScale = (_fontScale - 0.1).clamp(0.6, 1.4)),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 8),
                    ),
                    child: Slider(
                      value: _fontScale,
                      min: 0.6,
                      max: 1.4,
                      divisions: 8,
                      label: '${(_fontScale * 100).round()}%',
                      onChanged: (val) => setState(() => _fontScale = val),
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  onPressed: () => setState(
                      () => _fontScale = (_fontScale + 0.1).clamp(0.6, 1.4)),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: BiodataRenderer(
                  biodata: _biodata!,
                  theme: _scaledTheme,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: FilledButton.icon(
                  onPressed: () => _downloadPdf(context),
                  icon: const Icon(Icons.download),
                  label: Text(Strings.tr('Download PDF')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  onPressed: () => _sharePdf(context),
                  icon: const Icon(Icons.share_outlined),
                  label: Text(Strings.tr('Share')),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                tooltip: Strings.tr('More options'),
                onSelected: (value) {
                  if (value == 'save_image') _saveImage(context);
                  if (value == 'share_image') _shareImage(context);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                      value: 'save_image',
                      child: Text(Strings.tr('Save Image'))),
                  PopupMenuItem(
                      value: 'share_image',
                      child: Text(Strings.tr('Share Image'))),
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
      builder: (_) => FinalPreviewScreen(biodata: _biodata!, theme: _scaledTheme),
    ));
  }

  Future<void> _saveImage(BuildContext context) async {
    try {
      final result = await _pdfService.saveImage(_biodata!, _scaledTheme);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Strings.tr(result.nameKey))),
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
      await _pdfService.shareImage(_biodata!, _scaledTheme);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing image: $e')),
        );
      }
    }
  }

  Future<void> _downloadPdf(BuildContext context) async {
    try {
      final result = await _pdfService.savePdfVisible(_biodata!, _scaledTheme);
      _biodataRepo.incrementDownloadCount(widget.biodataId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Strings.tr(result.nameKey))),
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
    try {
      await _pdfService.previewPdf(_biodata!, _scaledTheme);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error preparing print preview: $e')),
        );
      }
    }
  }

  Future<void> _sharePdf(BuildContext context) async {
    try {
      await _pdfService.sharePdf(_biodata!, _scaledTheme);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing PDF: $e')),
        );
      }
    }
  }
}

/// One selectable card inside the theme bottom sheet.
class _ThemePreviewCard extends StatelessWidget {
  final ThemeConfig theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemePreviewCard({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outlineVariant,
                        width: isSelected ? 2.5 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: TemplateThumbnail(
                        template: theme,
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: colorScheme.primary,
                      child: Icon(Icons.check,
                          size: 12, color: colorScheme.onPrimary),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            theme.name,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
