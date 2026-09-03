import 'package:flutter/material.dart';

import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/features/templates/data/models/theme_engine.dart';
import 'package:biodata_maker/features/templates/data/repositories/template_repository.dart';
import 'package:biodata_maker/shared/widgets/biodata_renderer.dart';

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
      _template = template ?? ThemeEngine.defaultTemplates.first;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final t = _template ?? ThemeEngine.defaultTemplates.first;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Preview',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          'Review your complete marriage biodata design before generating the final PDF',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        BiodataRenderer(
          biodata: widget.biodata,
          theme: t,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
