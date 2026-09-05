import 'package:flutter/material.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/features/templates/data/repositories/template_repository.dart';

import 'package:biodata_maker/features/templates/data/models/theme_engine.dart';
import 'package:biodata_maker/shared/widgets/biodata_renderer.dart';

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

  /// The currently selected template, falling back to the first available one.
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
      // Select default template if none selected
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
          _LiveTemplatePreview(
            biodata: widget.biodata,
            template: _selectedTemplate,
          ),
        if (!_isLoading) const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.tr('Choose a Template'), style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_templates.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.dashboard_customize, size: 64, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text(Strings.tr('No templates available'), style: theme.textTheme.bodyLarge),
                      ],
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
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
                              if (template.isPremium)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.tertiary,
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                                  ),
                                  child: Text('PREMIUM', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: theme.colorScheme.onTertiary)),
                                )
                              else
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
                                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
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
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

/// Renders the actual biodata (with everything the user has filled in) using
/// the selected template's real background, fonts and layout, so choosing a
/// template shows exactly how the PDF will look.
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
              height: 420,
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
              child: IgnorePointer(
                child: SingleChildScrollView(
                  child: BiodataRenderer(
                    biodata: biodata,
                    theme: template,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
