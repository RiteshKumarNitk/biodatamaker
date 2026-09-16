import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/features/templates/data/repositories/template_repository.dart';

import 'package:biodata_maker/features/templates/data/models/theme_engine.dart';
import 'package:biodata_maker/shared/widgets/sample_biodata.dart';
import 'package:biodata_maker/core/services/pdf_service.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:printing/printing.dart';

class TemplateStep extends StatefulWidget {
  final Biodata biodata;
  final void Function(Biodata) onUpdate;

  const TemplateStep({super.key, required this.biodata, required this.onUpdate});

  @override
  State<TemplateStep> createState() => _TemplateStepState();
}

class _TemplateStepState extends State<TemplateStep> {
  List<ThemeConfig> _templates = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  ThemeConfig get _selectedTemplate {
    if (_templates.isEmpty) return ThemeEngine.defaultTemplates.first;
    return _templates.firstWhere(
      (t) => t.id == widget.biodata.templateId,
      orElse: () => _templates.first,
    );
  }

  void _loadTemplates() {
    try {
      final repo = sl<TemplateRepository>();
      var templates = repo.getAll();
      if (templates.isEmpty) {
        templates = ThemeEngine.defaultTemplates;
      }
      setState(() {
        _templates = templates;
        _isLoading = false;
      });
      if (widget.biodata.templateId.isEmpty && templates.isNotEmpty) {
        widget.onUpdate(widget.biodata.copyWith(templateId: templates.first.id));
      }
    } catch (e) {
      setState(() {
        _templates = ThemeEngine.defaultTemplates;
        _isLoading = false;
      });
    }
  }

  Color _colorFromInt(int colorInt) {
    return Color(colorInt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(Strings.tr('Choose Template'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(Strings.tr('Select a design template for your biodata'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 16),
        if (!_isLoading)
          SizedBox(
            height: 220,
            child: _templates.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.dashboard_customize, size: 64, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text(Strings.tr('No templates available'), style: theme.textTheme.bodyLarge),
                      ],
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _templates.length,
                    itemBuilder: (context, index) {
                      final template = _templates[index];
                      final isSelected = widget.biodata.templateId == template.id;
                      final primary = _colorFromInt(template.primaryColor);
                      final secondary = _colorFromInt(template.secondaryColor);
                      final bg = _colorFromInt(template.backgroundColor);
                      return GestureDetector(
                        key: ValueKey('templateCard-${template.id}'),
                        onTap: () => widget.onUpdate(widget.biodata.copyWith(templateId: template.id)),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 150,
                          margin: const EdgeInsets.only(right: 12, bottom: 8),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                              width: isSelected ? 2.5 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
                                    BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.1), blurRadius: 24, offset: const Offset(0, 8)),
                                  ]
                                : [BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 2))],
                            image: template.backgroundImage.isNotEmpty
                                ? DecorationImage(image: AssetImage(template.backgroundImage), fit: BoxFit.cover)
                                : null,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 18),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.biodata.fullName.isNotEmpty
                                                ? widget.biodata.fullName.split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join().toUpperCase()
                                                : 'BM',
                                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        template.name,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: _colorFromInt(template.textColor),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          fontFamily: template.headingFont,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        template.category,
                                        style: TextStyle(
                                          color: _colorFromInt(template.subtitleColor),
                                          fontSize: 11,
                                          fontFamily: template.bodyFont,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: secondary,
                                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(11)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        const SizedBox(height: 16),
        if (!_isLoading)
          _LayoutControls(
            biodata: widget.biodata,
            onUpdate: widget.onUpdate,
            template: _selectedTemplate,
          ),
        if (!_isLoading) const SizedBox(height: 16),
        if (!_isLoading)
          _LiveTemplatePreview(
            biodata: widget.biodata,
            template: _selectedTemplate,
          ),
        if (_isLoading)
          const Center(child: CircularProgressIndicator()),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _LayoutControls extends StatelessWidget {
  final Biodata biodata;
  final void Function(Biodata) onUpdate;
  final ThemeConfig template;

  const _LayoutControls({required this.biodata, required this.onUpdate, required this.template});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  Strings.tr('Layout Details'),
                  style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(Strings.tr('Photo Position'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'left', icon: Icon(Icons.align_horizontal_left), label: Text('Left')),
                ButtonSegment(value: 'right', icon: Icon(Icons.align_horizontal_right), label: Text('Right')),
              ],
              selected: {biodata.photoAlignment.isEmpty ? 'left' : biodata.photoAlignment},
              onSelectionChanged: (Set<String> newSelection) {
                onUpdate(biodata.copyWith(photoAlignment: newSelection.first));
              },
              style: SegmentedButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(height: 16),
            Text(Strings.tr('Header Icon'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: biodata.headerIcon.isEmpty ? 'none' : biodata.headerIcon,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: 'none', child: Text('None')),
                DropdownMenuItem(value: 'ganesh', child: Text('Ganesh Ji')),
                DropdownMenuItem(value: 'om', child: Text('Om')),
                DropdownMenuItem(value: 'swastik', child: Text('Swastik')),
                DropdownMenuItem(value: 'cross', child: Text('Cross')),
                DropdownMenuItem(value: 'moon', child: Text('Crescent Moon')),
                DropdownMenuItem(value: 'khanda', child: Text('Khanda')),
              ],
              onChanged: (String? value) {
                if (value != null) {
                  onUpdate(biodata.copyWith(headerIcon: value));
                }
              },
            ),
            const SizedBox(height: 16),
            Text(Strings.tr('Content Alignment'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: biodata.contentAlignment.isEmpty ? 'left' : biodata.contentAlignment,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: 'left', child: Text('Left')),
                DropdownMenuItem(value: 'center', child: Text('Center')),
                DropdownMenuItem(value: 'right', child: Text('Right')),
                DropdownMenuItem(value: 'spaceBetween', child: Text('Space Between')),
                DropdownMenuItem(value: 'spaceAround', child: Text('Space Around')),
              ],
              onChanged: (String? value) {
                if (value != null) {
                  onUpdate(biodata.copyWith(contentAlignment: value));
                }
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(Strings.tr('Show Footer Separator Line'), style: theme.textTheme.bodyMedium),
              subtitle: Text(Strings.tr('Draws a line at the very end of the biodata'), style: theme.textTheme.bodySmall),
              value: biodata.showFooterLine,
              onChanged: (bool value) {
                onUpdate(biodata.copyWith(showFooterLine: value));
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.tr('Heading Font Size'),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                if (biodata.customHeadingFontSize > 0)
                  TextButton(
                    onPressed: () => onUpdate(biodata.copyWith(customHeadingFontSize: 0.0)),
                    child: Text(Strings.tr('Reset'), style: const TextStyle(fontSize: 12)),
                  ),
              ],
            ),
            Slider(
              value: biodata.customHeadingFontSize > 0 ? biodata.customHeadingFontSize : 24.0,
              min: 16.0,
              max: 48.0,
              divisions: 32,
              label: biodata.customHeadingFontSize > 0 ? biodata.customHeadingFontSize.toStringAsFixed(0) : 'Default',
              onChanged: (val) => onUpdate(biodata.copyWith(customHeadingFontSize: val)),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.tr('Body Font Size'),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                if (biodata.customBodyFontSize > 0)
                  TextButton(
                    onPressed: () => onUpdate(biodata.copyWith(customBodyFontSize: 0.0)),
                    child: Text(Strings.tr('Reset'), style: const TextStyle(fontSize: 12)),
                  ),
              ],
            ),
            Slider(
              value: biodata.customBodyFontSize > 0 ? biodata.customBodyFontSize : 14.0,
              min: 10.0,
              max: 32.0,
              divisions: 22,
              label: biodata.customBodyFontSize > 0 ? biodata.customBodyFontSize.toStringAsFixed(0) : 'Default',
              onChanged: (val) => onUpdate(biodata.copyWith(customBodyFontSize: val)),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.tr('Line Spacing (Field Spacing)'),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                if (biodata.customFieldSpacing > 0)
                  TextButton(
                    onPressed: () => onUpdate(biodata.copyWith(customFieldSpacing: 0.0)),
                    child: Text(Strings.tr('Reset'), style: const TextStyle(fontSize: 12)),
                  ),
              ],
            ),
            Slider(
              value: biodata.customFieldSpacing > 0 ? biodata.customFieldSpacing : 8.0,
              min: 0.0,
              max: 24.0,
              divisions: 24,
              label: biodata.customFieldSpacing > 0 ? biodata.customFieldSpacing.toStringAsFixed(1) : 'Default',
              onChanged: (val) => onUpdate(biodata.copyWith(customFieldSpacing: val)),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.tr('Section Spacing'),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                if (biodata.customSectionSpacing > 0)
                  TextButton(
                    onPressed: () => onUpdate(biodata.copyWith(customSectionSpacing: 0.0)),
                    child: Text(Strings.tr('Reset'), style: const TextStyle(fontSize: 12)),
                  ),
              ],
            ),
            Slider(
              value: biodata.customSectionSpacing > 0 ? biodata.customSectionSpacing : 16.0,
              min: 4.0,
              max: 48.0,
              divisions: 44,
              label: biodata.customSectionSpacing > 0 ? biodata.customSectionSpacing.toStringAsFixed(1) : 'Default',
              onChanged: (val) => onUpdate(biodata.copyWith(customSectionSpacing: val)),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.tr('Page Margin'),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                if (biodata.customMargin > 0)
                  TextButton(
                    onPressed: () => onUpdate(biodata.copyWith(customMargin: 0.0)),
                    child: Text(Strings.tr('Reset'), style: const TextStyle(fontSize: 12)),
                  ),
              ],
            ),
            Slider(
              value: biodata.customMargin > 0 ? biodata.customMargin : 20.0,
              min: 0.0,
              max: 60.0,
              divisions: 60,
              label: biodata.customMargin > 0 ? biodata.customMargin.toStringAsFixed(1) : 'Default',
              onChanged: (val) => onUpdate(biodata.copyWith(customMargin: val)),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveTemplatePreview extends StatelessWidget {
  final Biodata biodata;
  final ThemeConfig template;

  const _LiveTemplatePreview({
    required this.biodata,
    required this.template,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    Strings.tr('Live Preview'),
                    style: theme.textTheme.titleSmall
                        ?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(template.primaryColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    template.name,
                    style: TextStyle(
                      color: Color(template.backgroundColor),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              Strings.tr('This is how your filled details will appear in the PDF'),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            Container(
              key: const ValueKey('templateLivePreview'),
              height: 480,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(template.backgroundColor),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: PdfPreview(
                build: (format) => sl<PdfService>().generatePdf(biodata, template),
                allowPrinting: false,
                allowSharing: false,
                canChangePageFormat: false,
                canChangeOrientation: false,
                canDebug: false,
                useActions: false,
                scrollViewDecoration: const BoxDecoration(color: Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdvancedLayoutBottomSheet extends StatelessWidget {
  final Biodata biodata;
  final void Function(Biodata) onUpdate;
  final ThemeConfig template;

  const _AdvancedLayoutBottomSheet({
    required this.biodata,
    required this.onUpdate,
    required this.template,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Strings.tr('Advanced Options'), style: theme.textTheme.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildSectionHeader(theme, 'Colors'),
                    _ColorPickerTile(
                      title: 'Primary Color',
                      currentColor: biodata.customPrimaryColor > 0 ? Color(biodata.customPrimaryColor) : Color(template.primaryColor),
                      onColorChanged: (c) => onUpdate(biodata.copyWith(customPrimaryColor: c.value)),
                      onReset: () => onUpdate(biodata.copyWith(customPrimaryColor: 0)),
                      hasCustom: biodata.customPrimaryColor > 0,
                    ),
                    _ColorPickerTile(
                      title: 'Background Color',
                      currentColor: biodata.customBackgroundColor > 0 ? Color(biodata.customBackgroundColor) : Color(template.backgroundColor),
                      onColorChanged: (c) => onUpdate(biodata.copyWith(customBackgroundColor: c.value)),
                      onReset: () => onUpdate(biodata.copyWith(customBackgroundColor: 0)),
                      hasCustom: biodata.customBackgroundColor > 0,
                    ),
                    const SizedBox(height: 16),
                    _buildSectionHeader(theme, 'Photo Settings'),
                    _buildDropdown(
                      'Photo Shape',
                      biodata.customPhotoShape.isEmpty ? template.photoShape : biodata.customPhotoShape,
                      [
                        const DropdownMenuItem(value: 'circle', child: Text('Circle')),
                        const DropdownMenuItem(value: 'rounded', child: Text('Rounded Rectangle')),
                        const DropdownMenuItem(value: 'square', child: Text('Square')),
                      ],
                      (val) => onUpdate(biodata.copyWith(customPhotoShape: val)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Photo Size Scale', style: theme.textTheme.bodyMedium),
                        if (biodata.customPhotoSize != 1.0)
                          TextButton(
                            onPressed: () => onUpdate(biodata.copyWith(customPhotoSize: 1.0)),
                            child: Text(Strings.tr('Reset'), style: const TextStyle(fontSize: 12)),
                          ),
                      ],
                    ),
                    Slider(
                      value: biodata.customPhotoSize,
                      min: 0.5,
                      max: 2.0,
                      divisions: 15,
                      label: '${(biodata.customPhotoSize * 100).toInt()}%',
                      onChanged: (val) => onUpdate(biodata.copyWith(customPhotoSize: val)),
                    ),
                    SwitchListTile(
                      title: const Text('Show Photo Border'),
                      value: biodata.showPhotoBorder,
                      onChanged: (val) => onUpdate(biodata.copyWith(showPhotoBorder: val)),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 16),
                    _buildSectionHeader(theme, 'Text Styling'),
                    SwitchListTile(
                      title: const Text('Uppercase Headings'),
                      value: biodata.uppercaseHeadings,
                      onChanged: (val) => onUpdate(biodata.copyWith(uppercaseHeadings: val)),
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: const Text('Bold Field Labels'),
                      value: biodata.boldLabels,
                      onChanged: (val) => onUpdate(biodata.copyWith(boldLabels: val)),
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: const Text('Show Colons ( : )'),
                      value: biodata.showColons,
                      onChanged: (val) => onUpdate(biodata.copyWith(showColons: val)),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 16),
                    _buildSectionHeader(theme, 'Header Decoration'),
                    _buildDropdown(
                      'Section Header Style',
                      biodata.customHeaderStyle.isEmpty ? template.headerDecoration : biodata.customHeaderStyle,
                      [
                        const DropdownMenuItem(value: 'pill', child: Text('Solid Pill')),
                        const DropdownMenuItem(value: 'underline', child: Text('Underline')),
                        const DropdownMenuItem(value: 'none', child: Text('Text Only')),
                      ],
                      (val) => onUpdate(biodata.copyWith(customHeaderStyle: val)),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<DropdownMenuItem<String>> items, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            isDense: true,
          ),
          items: items,
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ],
    );
  }
}

class _ColorPickerTile extends StatelessWidget {
  final String title;
  final Color currentColor;
  final Function(Color) onColorChanged;
  final VoidCallback onReset;
  final bool hasCustom;

  const _ColorPickerTile({
    required this.title,
    required this.currentColor,
    required this.onColorChanged,
    required this.onReset,
    required this.hasCustom,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasCustom)
            TextButton(
              onPressed: onReset,
              child: const Text('Reset'),
            ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  Color tempColor = currentColor;
                  return AlertDialog(
                    title: const Text('Pick a color!'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: currentColor,
                        onColorChanged: (c) => tempColor = c,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Save'),
                        onPressed: () {
                          onColorChanged(tempColor);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: currentColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
