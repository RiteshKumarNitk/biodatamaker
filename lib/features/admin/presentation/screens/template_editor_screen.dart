import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/features/templates/data/models/theme_engine.dart';
import 'package:biodata_maker/features/templates/data/repositories/template_repository.dart';

class TemplateEditorScreen extends StatefulWidget {
  final String? templateId;

  const TemplateEditorScreen({super.key, this.templateId});

  @override
  State<TemplateEditorScreen> createState() => _TemplateEditorScreenState();
}

class _TemplateEditorScreenState extends State<TemplateEditorScreen> {
  final TemplateRepository _templateRepo = sl<TemplateRepository>();
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late String _id;
  late String _name;
  late String _category;
  bool _isPremium = false;
  int _displayOrder = 0;
  late int _primaryColor;
  late int _secondaryColor;
  late int _backgroundColor;
  late int _textColor;
  late int _subtitleColor;
  late String _headingFont;
  late String _bodyFont;
  late double _headingFontSize;
  late double _bodyFontSize;
  late String _photoShape;
  late double _margin;
  late double _sectionSpacing;
  late double _fieldSpacing;
  late String _headerDecoration;
  late String _footerDecoration;
  late String _dividerStyle;
  late String _backgroundImage;
  late bool _isPublished;
  late List<String> _sectionOrder;

  bool _isNew = true;
  bool _isSaving = false;

  static const _colorPresets = [
    0xFFC62828,
    0xFFB8860B,
    0xFF2E7D32,
    0xFF0D47A1,
    0xFF6A1B9A,
    0xFF00897B,
    0xFF37474F,
    0xFFAD1457,
    0xFF1565C0,
    0xFF5D4037,
    0xFF1B5E20,
    0xFFD4A017,
    0xFF00695C,
    0xFF78909C,
    0xFF1A237E,
    0xFFF44336,
    0xFF2196F3,
    0xFF4CAF50,
    0xFFFF9800,
    0xFF9C27B0,
  ];

  static const _fontOptions = [
    'Playfair Display',
    'Poppins',
    'Lora',
    'Merriweather',
    'Roboto',
    'Lato',
    'Montserrat',
    'Open Sans',
    'Raleway',
    'Cinzel',
    'Cormorant Garamond',
    'Great Vibes',
    'Tangerine',
    'Alex Brush',
  ];

  static const _photoShapeOptions = ['circle', 'rounded', 'square'];
  static const _decorationOptions = [
    'minimal',
    'mandala',
    'floral',
    'royal',
    'ornate',
    'lotus',
    'temple',
    'geometric',
    'none',
  ];
  static const _dividerStyleOptions = [
    'minimal',
    'dashed',
    'dotted',
    'ornate',
    'floral',
    'thick',
    'none',
  ];

  static const _availableSections = [
    'personal',
    'education',
    'family',
    'lifestyle',
    'contact',
    'partner_preference',
  ];

  final _sectionLabels = {
    'personal': 'Personal Info',
    'education': 'Education & Career',
    'family': 'Family Details',
    'lifestyle': 'Lifestyle & Interests',
    'contact': 'Contact Information',
    'partner_preference': 'Partner Preference',
  };

  @override
  void initState() {
    super.initState();
    _isNew = widget.templateId == null;
    if (_isNew) {
      _id = _uuid.v4();
      _name = '';
      _category = 'Traditional';
      _isPremium = false;
      _displayOrder = 0;
      _primaryColor = 0xFFC62828;
      _secondaryColor = 0xFFFFB300;
      _backgroundColor = 0xFFFFFFFF;
      _textColor = 0xFF212121;
      _subtitleColor = 0xFF757575;
      _headingFont = 'Playfair Display';
      _bodyFont = 'Poppins';
      _headingFontSize = 24.0;
      _bodyFontSize = 14.0;
      _photoShape = 'circle';
      _margin = 20.0;
      _sectionSpacing = 16.0;
      _fieldSpacing = 8.0;
      _headerDecoration = 'mandala';
      _footerDecoration = 'floral';
      _dividerStyle = 'minimal';
      _backgroundImage = '';
      _isPublished = true;
      _sectionOrder = List.from(_availableSections);
    } else {
      final existing = _templateRepo.getById(widget.templateId!);
      if (existing == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Template not found')),
            );
            Navigator.of(context).pop();
          }
        });
        _id = widget.templateId!;
        _name = '';
        _category = 'General';
        _primaryColor = 0xFFC62828;
        _secondaryColor = 0xFFB8860B;
        _backgroundColor = 0xFFFFFFFF;
        _textColor = 0xFF000000;
        _subtitleColor = 0xFF666666;
        _headingFont = 'Playfair Display';
        _bodyFont = 'Poppins';
        _headingFontSize = 24.0;
        _bodyFontSize = 14.0;
        _photoShape = 'circle';
        _margin = 20.0;
        _sectionSpacing = 16.0;
        _fieldSpacing = 8.0;
        _headerDecoration = 'mandala';
        _footerDecoration = 'floral';
        _dividerStyle = 'minimal';
        _backgroundImage = '';
        _isPublished = true;
        _sectionOrder = List.from(_availableSections);
        return;
      }
      _id = existing.id;
      _name = existing.name;
      _category = existing.category;
      _isPremium = existing.isPremium;
      _displayOrder = existing.displayOrder;
      _primaryColor = existing.primaryColor;
      _secondaryColor = existing.secondaryColor;
      _backgroundColor = existing.backgroundColor;
      _textColor = existing.textColor;
      _subtitleColor = existing.subtitleColor;
      _headingFont = existing.headingFont;
      _bodyFont = existing.bodyFont;
      _headingFontSize = existing.headingFontSize;
      _bodyFontSize = existing.bodyFontSize;
      _photoShape = existing.photoShape;
      _margin = existing.margin;
      _sectionSpacing = existing.sectionSpacing;
      _fieldSpacing = existing.fieldSpacing;
      _headerDecoration = existing.headerDecoration;
      _footerDecoration = existing.footerDecoration;
      _dividerStyle = existing.dividerStyle;
      _backgroundImage = existing.backgroundImage;
      _isPublished = existing.isPublished;
      _sectionOrder = List.from(existing.sectionOrder);
    }
  }

  Future<void> _pickBackgroundImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      final dir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${dir.path}/admin_images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      final file = File(result.files.single.path!);
      final newPath = '${imagesDir.path}/${_id}_bg${result.files.single.extension?.isNotEmpty == true ? result.files.single.extension : '.jpg'}';
      await file.copy(newPath);
      setState(() {
        _backgroundImage = newPath;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final template = ThemeConfig(
      id: _id,
      name: _name,
      category: _category,
      isPremium: _isPremium,
      primaryColor: _primaryColor,
      secondaryColor: _secondaryColor,
      backgroundColor: _backgroundColor,
      textColor: _textColor,
      subtitleColor: _subtitleColor,
      headingFont: _headingFont,
      bodyFont: _bodyFont,
      headingFontSize: _headingFontSize,
      bodyFontSize: _bodyFontSize,
      photoShape: _photoShape,
      borderStyle: 'ornate',
      sectionSpacing: _sectionSpacing,
      fieldSpacing: _fieldSpacing,
      margin: _margin,
      headerDecoration: _headerDecoration,
      footerDecoration: _footerDecoration,
      dividerStyle: _dividerStyle,
      showWatermark: false,
      watermarkText: '',
      sectionOrder: _sectionOrder,
      hiddenFields: [],
      labelOverrides: {},
      iconStyle: 'outline',
      backgroundImage: _backgroundImage,
      borderImage: '',
      watermarkImage: '',
      isPublished: _isPublished,
      displayOrder: _displayOrder,
    );

    await _templateRepo.save(template);
    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isNew ? 'Template created' : 'Template saved'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'New Template' : 'Edit Template'),
        actions: [
          TextButton.icon(
            onPressed: () {
              context.push('/admin/template/preview/$_id');
            },
            icon: const Icon(Icons.preview),
            label: const Text('Preview'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection('Basic Info', [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Template Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
                onChanged: (v) => _name = v,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: ThemeEngine.categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _category = v);
                },
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Premium Template'),
                value: _isPremium,
                onChanged: (v) => setState(() => _isPremium = v),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: '$_displayOrder',
                decoration: const InputDecoration(
                  labelText: 'Display Order',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) =>
                    _displayOrder = int.tryParse(v) ?? 0,
              ),
            ]),
            const SizedBox(height: 16),
            _buildSection('Colors', [
              _buildColorPicker('Primary', _primaryColor, (c) {
                setState(() => _primaryColor = c);
              }),
              const SizedBox(height: 12),
              _buildColorPicker('Secondary', _secondaryColor, (c) {
                setState(() => _secondaryColor = c);
              }),
              const SizedBox(height: 12),
              _buildColorPicker('Background', _backgroundColor, (c) {
                setState(() => _backgroundColor = c);
              }),
              const SizedBox(height: 12),
              _buildColorPicker('Text', _textColor, (c) {
                setState(() => _textColor = c);
              }),
              const SizedBox(height: 12),
              _buildColorPicker('Subtitle', _subtitleColor, (c) {
                setState(() => _subtitleColor = c);
              }),
            ]),
            const SizedBox(height: 16),
            _buildSection('Fonts', [
              DropdownButtonFormField<String>(
                initialValue: _headingFont,
                decoration: const InputDecoration(
                  labelText: 'Heading Font',
                  border: OutlineInputBorder(),
                ),
                items: _fontOptions
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _headingFont = v);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _bodyFont,
                decoration: const InputDecoration(
                  labelText: 'Body Font',
                  border: OutlineInputBorder(),
                ),
                items: _fontOptions
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _bodyFont = v);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: '$_headingFontSize',
                decoration: const InputDecoration(
                  labelText: 'Heading Font Size',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) =>
                    _headingFontSize = double.tryParse(v) ?? 24.0,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: '$_bodyFontSize',
                decoration: const InputDecoration(
                  labelText: 'Body Font Size',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) =>
                    _bodyFontSize = double.tryParse(v) ?? 14.0,
              ),
            ]),
            const SizedBox(height: 16),
            _buildSection('Layout', [
              DropdownButtonFormField<String>(
                initialValue: _photoShape,
                decoration: const InputDecoration(
                  labelText: 'Photo Shape',
                  border: OutlineInputBorder(),
                ),
                items: _photoShapeOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _photoShape = v);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: '$_margin',
                decoration: const InputDecoration(
                  labelText: 'Margin',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => _margin = double.tryParse(v) ?? 20.0,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: '$_sectionSpacing',
                decoration: const InputDecoration(
                  labelText: 'Section Spacing',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) =>
                    _sectionSpacing = double.tryParse(v) ?? 16.0,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: '$_fieldSpacing',
                decoration: const InputDecoration(
                  labelText: 'Field Spacing',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) =>
                    _fieldSpacing = double.tryParse(v) ?? 8.0,
              ),
            ]),
            const SizedBox(height: 16),
            _buildSection('Decorations', [
              DropdownButtonFormField<String>(
                initialValue: _headerDecoration,
                decoration: const InputDecoration(
                  labelText: 'Header Decoration',
                  border: OutlineInputBorder(),
                ),
                items: _decorationOptions
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _headerDecoration = v);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _footerDecoration,
                decoration: const InputDecoration(
                  labelText: 'Footer Decoration',
                  border: OutlineInputBorder(),
                ),
                items: _decorationOptions
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _footerDecoration = v);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _dividerStyle,
                decoration: const InputDecoration(
                  labelText: 'Divider Style',
                  border: OutlineInputBorder(),
                ),
                items: _dividerStyleOptions
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _dividerStyle = v);
                },
              ),
            ]),
            const SizedBox(height: 16),
            _buildSection('Background Image', [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.image_outlined),
                  title: Text(
                    _backgroundImage.isNotEmpty
                        ? 'Image selected'
                        : 'No background image',
                  ),
                  trailing: TextButton(
                    onPressed: _pickBackgroundImage,
                    child: Text(
                      _backgroundImage.isNotEmpty ? 'Change' : 'Pick',
                    ),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            _buildSection('Section Order', [
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _sectionOrder.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = _sectionOrder.removeAt(oldIndex);
                    _sectionOrder.insert(newIndex, item);
                  });
                },
                itemBuilder: (context, index) {
                  final section = _sectionOrder[index];
                  return ListTile(
                    key: ValueKey(section),
                    leading: const Icon(Icons.drag_handle),
                    title: Text(_sectionLabels[section] ?? section),
                  );
                },
              ),
            ]),
            const SizedBox(height: 16),
            _buildSection('Publishing', [
              SwitchListTile(
                title: const Text('Published'),
                subtitle: const Text('Visible to users'),
                value: _isPublished,
                onChanged: (v) => setState(() => _isPublished = v),
              ),
            ]),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isNew ? 'Create Template' : 'Save Changes'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker(
      String label, int currentColor, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _colorPresets.map((color) {
            final isSelected = color == currentColor;
            return GestureDetector(
              onTap: () => onChanged(color),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Color(color),
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                  boxShadow: isSelected
                      ? [BoxShadow(color: Color(color).withValues(alpha: 0.5), blurRadius: 8)]
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
