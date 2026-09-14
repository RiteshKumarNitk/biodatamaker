import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/biodata/presentation/bloc/form_bloc.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/features/templates/data/models/theme_engine.dart';
import 'package:biodata_maker/features/templates/data/repositories/template_repository.dart';
import 'package:biodata_maker/features/preview/presentation/screens/final_preview_screen.dart';
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

  /// Maps the renderer's section keys to the wizard step that edits them.
  /// Personal Information now also holds Education/Lifestyle/Partner
  /// Preference fields (see biodata_renderer.dart's 3-title consolidation),
  /// so its edit button jumps to the Personal step; the other wizard steps
  /// that feed it are still reachable via Next/Back from there.
  static const Map<String, int> _sectionSteps = {
    'photo': 0,
    'personal': 1,
    'family': 3,
    'contact': 5,
  };

  void _editSection(BuildContext context, String sectionKey) {
    final step = _sectionSteps[sectionKey];
    if (step == null) return;
    // All form data stays in bloc state, so jumping back and returning to
    // Review preserves everything the user has entered.
    context.read<BiodataFormBloc>().add(GoToStep(step));
  }

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
          Strings.tr('Preview'),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          Strings.tr('Review your complete marriage biodata design before generating the final PDF'),
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        BiodataRenderer(
          biodata: widget.biodata,
          theme: t,
          onEditSection: (sectionKey) => _editSection(context, sectionKey),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => FinalPreviewScreen(biodata: widget.biodata, theme: t),
            )),
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: Text(Strings.tr('Preview Final PDF')),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
