import 'package:flutter/material.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/features/biodata/data/models/custom_field.dart';

/// Reusable "+ Add More Fields" editor for one biodata section.
///
/// Shows the custom fields belonging to [section], lets the user add more via
/// a label/value dialog, and allows editing or deleting existing ones. All
/// changes are reported through [onChanged] with the full updated list.
class CustomFieldsEditor extends StatelessWidget {
  final String section;
  final String sectionLabel;
  final List<CustomField> fields;
  final ValueChanged<List<CustomField>> onChanged;

  const CustomFieldsEditor({
    super.key,
    required this.section,
    required this.sectionLabel,
    required this.fields,
    required this.onChanged,
  });

  List<CustomField> get _sectionFields =>
      fields.where((f) => f.section == section).toList();

  Future<void> _openFieldDialog(
    BuildContext context, {
    CustomField? existing,
    int? index,
  }) async {
    final labelCtrl = TextEditingController(text: existing?.label ?? '');
    final valueCtrl = TextEditingController(text: existing?.value ?? '');

    final saved = await showDialog<CustomField?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null
            ? Strings.tr('Add Field')
            : Strings.tr('Edit Field')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelCtrl,
              autofocus: true,
              decoration: InputDecoration(
                labelText: Strings.tr('Field Label'),
                hintText: 'e.g. Blood Group',
                border: const OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: valueCtrl,
              decoration: InputDecoration(
                labelText: Strings.tr('Field Value'),
                hintText: 'e.g. B+',
                border: const OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(Strings.tr('Cancel')),
          ),
          FilledButton(
            onPressed: () {
              final label = labelCtrl.text.trim();
              final value = valueCtrl.text.trim();
              if (label.isEmpty || value.isEmpty) return;
              Navigator.pop(
                ctx,
                CustomField(
                  id: existing?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  section: section,
                  label: label,
                  value: value,
                  order: existing?.order ?? 0,
                ),
              );
            },
            child: Text(Strings.tr('Save')),
          ),
        ],
      ),
    );

    if (saved == null) return;
    final list = [..._sectionFields];
    if (existing != null && index != null && index < list.length) {
      list[index] = saved;
    } else {
      list.add(saved);
    }
    // Merge back into the full (cross-section) list, preserving other sections.
    final otherFields = fields.where((f) => f.section != section).toList();
    onChanged([...otherFields, ...list]);
  }

  void _removeField(BuildContext context, int index) {
    final list = [..._sectionFields]..removeAt(index);
    final otherFields = fields.where((f) => f.section != section).toList();
    onChanged([...otherFields, ...list]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sectionFields = _sectionFields;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.library_add_outlined,
                    size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    Strings.tr('Custom Fields'),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              // sectionLabel is kept for API stability; the sentence no longer
              // interpolates it so it can be translated as a whole.
              Strings.tr(
                  'Extra details shown in this section will also appear in your biodata'),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (sectionFields.isEmpty) ...[
              const SizedBox(height: 12),
              Text(
                Strings.tr('No custom fields added yet.'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ] else ...[
              const SizedBox(height: 8),
              ...sectionFields.asMap().entries.map((entry) {
                final index = entry.key;
                final field = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              field.label,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (field.value.isNotEmpty)
                              Text(
                                field.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: Strings.tr('Edit'),
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: () => _openFieldDialog(
                          context,
                          existing: field,
                          index: index,
                        ),
                      ),
                      IconButton(
                        tooltip: Strings.tr('Delete'),
                        visualDensity: VisualDensity.compact,
                        icon: Icon(Icons.delete_outline,
                            size: 20, color: theme.colorScheme.error),
                        onPressed: () => _removeField(context, index),
                      ),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _openFieldDialog(context),
                icon: const Icon(Icons.add),
                label: Text(Strings.tr('Add More Fields')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
