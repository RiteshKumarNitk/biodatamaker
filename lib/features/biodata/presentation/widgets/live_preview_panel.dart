import 'package:flutter/material.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/templates/data/models/theme_engine.dart';
import 'package:biodata_maker/features/templates/data/repositories/template_repository.dart';
import 'package:biodata_maker/shared/widgets/biodata_renderer.dart';

/// The cheap, instant-update preview shown while the user is still filling in
/// the form: it renders the exact same [BiodataRenderer] the final PDF uses,
/// against whatever the user has entered so far, so there is no separate
/// "editing preview" layout to keep in sync with the real output — only the
/// full PDF render (see [PdfService]/`FinalPreviewScreen`) is deferred to
/// avoid doing that expensive work on every keystroke.
class LivePreviewPanel extends StatelessWidget {
  final Biodata biodata;

  const LivePreviewPanel({super.key, required this.biodata});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final template = ThemeEngine.resolveById(
      biodata.templateId,
      sl<TemplateRepository>().getById,
    );

    return Container(
      color: theme.colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(Icons.visibility_outlined, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  Strings.tr('Live Preview'),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: BiodataRenderer(biodata: biodata, theme: template),
            ),
          ),
        ],
      ),
    );
  }
}
