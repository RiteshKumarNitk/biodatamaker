import 'package:flutter/material.dart';

import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/features/templates/data/repositories/template_repository.dart';

class PreviewStep extends StatefulWidget {
  final Biodata biodata;

  const PreviewStep({super.key, required this.biodata});

  @override
  State<PreviewStep> createState() => _PreviewStepState();
}

class _PreviewStepState extends State<PreviewStep> {
  ThemeConfig? _template;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTemplate();
  }

  void _loadTemplate() {
    final repo = sl<TemplateRepository>();
    final template = widget.biodata.templateId.isNotEmpty
        ? repo.getById(widget.biodata.templateId)
        : null;
    setState(() {
      _template = template;
      _isLoading = false;
    });
  }

  Color _c(int colorInt) => Color(colorInt);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final b = widget.biodata;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final t = _template;
    final primary = t != null ? _c(t.primaryColor) : theme.colorScheme.primary;
    final bg = t != null ? _c(t.backgroundColor) : theme.colorScheme.surface;
    final textColor = t != null ? _c(t.textColor) : theme.colorScheme.onSurface;
    final subtitleColor = t != null ? _c(t.subtitleColor) : theme.colorScheme.onSurfaceVariant;

    final previewGradients = [
      [colorScheme.primaryContainer, colorScheme.primaryContainer.withValues(alpha: 0.4)],
      [colorScheme.secondaryContainer, colorScheme.secondaryContainer.withValues(alpha: 0.4)],
      [colorScheme.tertiaryContainer, colorScheme.tertiaryContainer.withValues(alpha: 0.4)],
      [colorScheme.primaryContainer.withValues(alpha: 0.7), colorScheme.tertiaryContainer.withValues(alpha: 0.4)],
      [colorScheme.secondaryContainer.withValues(alpha: 0.7), colorScheme.primaryContainer.withValues(alpha: 0.4)],
    ];
    final gradientIndex = b.fullName.hashCode % previewGradients.length;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Preview', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Review your biodata before generating PDF', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Preview', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(t?.margin ?? 16),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                      boxShadow: [
                        BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
                        BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.05), blurRadius: 24, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: previewGradients[gradientIndex],
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: primary,
                      child: Text(
                        b.fullName.isNotEmpty
                            ? b.fullName.split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join().toUpperCase()
                            : '?',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: t?.headingFont),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            b.fullName.isNotEmpty ? b.fullName : 'Full Name',
                            style: TextStyle(
                              fontSize: t?.headingFontSize ?? 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontFamily: t?.headingFont,
                            ),
                          ),
                          if (b.age.isNotEmpty || b.gender.isNotEmpty)
                            Text(
                              [b.age, b.gender].where((s) => s.isNotEmpty).join(' | '),
                              style: TextStyle(color: subtitleColor, fontSize: t?.bodyFontSize ?? 13, fontFamily: t?.bodyFont),
                            ),
                          if (b.occupation.isNotEmpty)
                            Text(b.occupation, style: TextStyle(color: subtitleColor, fontSize: t?.bodyFontSize ?? 13, fontFamily: t?.bodyFont)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: primary.withValues(alpha: 0.3)),
                const SizedBox(height: 8),
                if (b.aboutMe.isNotEmpty) _section('About Me', b.aboutMe, t, textColor, subtitleColor, primary),
                if (b.religion.isNotEmpty) _field('Religion', b.religion, t, textColor, subtitleColor),
                if (b.caste.isNotEmpty) _field('Caste', b.caste, t, textColor, subtitleColor),
                if (b.maritalStatus.isNotEmpty) _field('Marital Status', b.maritalStatus, t, textColor, subtitleColor),
                if (b.motherTongue.isNotEmpty) _field('Mother Tongue', b.motherTongue, t, textColor, subtitleColor),
                if (b.qualification.isNotEmpty) _field('Qualification', b.qualification, t, textColor, subtitleColor),
                if (b.occupation.isNotEmpty) _field('Occupation', b.occupation, t, textColor, subtitleColor),
                if (b.fatherName.isNotEmpty || b.motherName.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Family Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary, fontFamily: t?.headingFont)),
                  const SizedBox(height: 4),
                  if (b.fatherName.isNotEmpty) _field('Father', b.fatherName, t, textColor, subtitleColor),
                  if (b.motherName.isNotEmpty) _field('Mother', b.motherName, t, textColor, subtitleColor),
                ],
                if (b.diet.isNotEmpty || b.hobbies.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Lifestyle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary, fontFamily: t?.headingFont)),
                  const SizedBox(height: 4),
                  if (b.diet.isNotEmpty) _field('Diet', b.diet, t, textColor, subtitleColor),
                  if (b.hobbies.isNotEmpty) _field('Hobbies', b.hobbies, t, textColor, subtitleColor),
                ],
                  if (b.mobile.isNotEmpty || b.email.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Contact', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary, fontFamily: t?.headingFont)),
                    const SizedBox(height: 4),
                    if (b.mobile.isNotEmpty) _field('Mobile', b.mobile, t, textColor, subtitleColor),
                    if (b.email.isNotEmpty) _field('Email', b.email, t, textColor, subtitleColor),
                  ],
                ],
              ),
            ),
          ),
              ],
            ),
          ),
        ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _section(String title, String content, ThemeConfig? t, Color textColor, Color subtitleColor, Color primary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary, fontFamily: t?.headingFont)),
          const SizedBox(height: 4),
          Text(content, style: TextStyle(fontSize: t?.bodyFontSize ?? 13, color: textColor, fontFamily: t?.bodyFont)),
        ],
      ),
    );
  }

  Widget _field(String label, String value, ThemeConfig? t, Color textColor, Color subtitleColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: subtitleColor, fontSize: t?.bodyFontSize ?? 13, fontFamily: t?.bodyFont)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: textColor, fontSize: t?.bodyFontSize ?? 13, fontFamily: t?.bodyFont)),
          ),
        ],
      ),
    );
  }
}
