import 'package:flutter/material.dart';

import 'package:biodata_maker/core/constants/app_constants.dart';
import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/biodata/data/models/sibling.dart';
import 'package:biodata_maker/shared/widgets/custom_fields_editor.dart';

class FamilyStep extends StatelessWidget {
  final Biodata biodata;
  final void Function(Biodata) onUpdate;

  const FamilyStep({super.key, required this.biodata, required this.onUpdate});

  InputDecoration _deco(String label, {String? hint, Widget? prefixIcon}) {
    return InputDecoration(
      labelText: Strings.tr(label),
      hintText: hint,
      prefixIcon: prefixIcon,
    );
  }

  /// Keeps the legacy "Brothers" / "Sisters" fields in sync with the
  /// dynamic sibling cards so they still appear in the PDF.
  Biodata _syncSiblingCounts(List<Sibling> siblings) {
    final brothers = siblings.where((s) => s.relationship == 'Brother').length;
    final sisters = siblings.where((s) => s.relationship == 'Sister').length;
    return biodata.copyWith(
      siblings: siblings,
      brothers: brothers == 0 ? '' : '$brothers',
      sisters: sisters == 0 ? '' : '$sisters',
    );
  }

  Future<void> _openSiblingDialog(BuildContext context, {Sibling? existing, int? index}) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final occupationCtrl = TextEditingController(text: existing?.occupation ?? '');
    String relationship = existing?.relationship ?? 'Brother';
    String maritalStatus = existing?.maritalStatus ?? 'Unmarried';

    final saved = await showDialog<Sibling>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          title: Text(existing == null
              ? Strings.tr('Add Sibling')
              : Strings.tr('Edit Sibling')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: relationship,
                  decoration: InputDecoration(
                    labelText: Strings.tr('Relationship'),
                    prefixIcon: const Icon(Icons.family_restroom),
                  ),
                  items: AppConstants.siblingRelationships
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setDlgState(() => relationship = v);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: Strings.tr("Sibling's Name *"),
                    hintText: 'e.g. Abhinav Singh',
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: occupationCtrl,
                  decoration: InputDecoration(
                    labelText: Strings.tr('Occupation'),
                    hintText: 'e.g. Software Engineer (optional)',
                    prefixIcon: const Icon(Icons.work_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: maritalStatus,
                  decoration: InputDecoration(
                    labelText: Strings.tr('Marital Status'),
                    prefixIcon: const Icon(Icons.favorite_outline),
                  ),
                  items: AppConstants.siblingMaritalStatuses
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setDlgState(() => maritalStatus = v);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(Strings.tr('Cancel')),
            ),
            FilledButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                final sibling = Sibling(
                  id: existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  relationship: relationship,
                  name: nameCtrl.text.trim(),
                  occupation: occupationCtrl.text.trim(),
                  maritalStatus: maritalStatus,
                );
                Navigator.pop(ctx, sibling);
              },
              child: Text(Strings.tr('Save')),
            ),
          ],
        ),
      ),
    );

    if (saved == null) return;
    final list = [...biodata.siblings];
    if (existing != null && index != null && index < list.length) {
      list[index] = saved;
    } else {
      list.add(saved);
    }
    onUpdate(_syncSiblingCounts(list));
  }

  void _confirmRemoveSibling(BuildContext context, int index) {
    final theme = Theme.of(context);
    final sibling = biodata.siblings[index];
    final name = sibling.name.isNotEmpty ? sibling.name : sibling.relationship;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(Strings.tr('Remove Sibling')),
        content: Text(Strings.tr('Remove $name from your biodata? This cannot be undone.')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(Strings.tr('Cancel')),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _removeSibling(index);
            },
            style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error),
            child: Text(Strings.tr('Remove')),
          ),
        ],
      ),
    );
  }

  void _removeSibling(int index) {
    final list = [...biodata.siblings]..removeAt(index);
    onUpdate(_syncSiblingCounts(list));
  }

  String _siblingSummary(Sibling sibling) {
    return [
      sibling.relationship,
      if (sibling.occupation.isNotEmpty) sibling.occupation,
      if (sibling.maritalStatus.isNotEmpty) sibling.maritalStatus,
    ].join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = biodata;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(Strings.tr('Family Details'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(Strings.tr('Enter family background information'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 16),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.tr('Grandparents'), style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.grandFatherName,
                  decoration: _deco("Grandfather's Name", hint: 'Enter grandfather\'s name'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(grandFatherName: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.grandFatherOccupation,
                  decoration: _deco("Grandfather's Occupation", hint: 'e.g. Farmer, Retired'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(grandFatherOccupation: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.grandMotherName,
                  decoration: _deco("Grandmother's Name", hint: 'Enter grandmother\'s name'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(grandMotherName: v)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.tr('Parents'), style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.fatherName,
                  decoration: _deco("Father's Name", hint: 'Enter father\'s name', prefixIcon: const Icon(Icons.person_outline)),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(fatherName: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.fatherOccupation,
                  decoration: _deco("Father's Occupation", hint: 'e.g. Businessman, Government Employee, Teacher, Retired'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(fatherOccupation: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.motherName,
                  decoration: _deco("Mother's Name", hint: 'Enter mother\'s name', prefixIcon: const Icon(Icons.person_outline)),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(motherName: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.motherOccupation,
                  decoration: _deco("Mother's Occupation", hint: 'e.g. Homemaker, Teacher, Business'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(motherOccupation: v)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.group_add_outlined, size: 20, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(Strings.tr('Siblings'), style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (biodata.siblings.isEmpty)
                  Text(
                    Strings.tr(
                        'Add each sibling individually with their name, occupation and marital status.'),
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  )
                else ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: Icon(Icons.male, size: 16, color: theme.colorScheme.primary),
                        label: Text('${b.brothers.isEmpty ? 0 : b.brothers} Brother${b.brothers == '1' ? '' : 's'}'),
                        visualDensity: VisualDensity.compact,
                      ),
                      Chip(
                        avatar: Icon(Icons.female, size: 16, color: theme.colorScheme.primary),
                        label: Text('${b.sisters.isEmpty ? 0 : b.sisters} Sister${b.sisters == '1' ? '' : 's'}'),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ...biodata.siblings.asMap().entries.map((entry) {
                    final index = entry.key;
                    final sibling = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.outlineVariant),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Text(
                            sibling.relationship == 'Sister' ? 'S' : 'B',
                            style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          sibling.name.isEmpty ? Strings.tr('Unnamed sibling') : sibling.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(_siblingSummary(sibling)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: Strings.tr('Edit'),
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              onPressed: () => _openSiblingDialog(context, existing: sibling, index: index),
                            ),
                            IconButton(
                              tooltip: Strings.tr('Delete'),
                              icon: Icon(Icons.delete_outline, size: 20, color: theme.colorScheme.error),
                              onPressed: () => _confirmRemoveSibling(context, index),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openSiblingDialog(context),
                    icon: const Icon(Icons.person_add_alt_1),
                    label: Text(Strings.tr('Add Sibling')),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.tr('Family Background'), style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.familyType.isEmpty ? null : (AppConstants.familyTypes.contains(b.familyType) ? b.familyType : null),
                  decoration: _deco('Family Type', prefixIcon: const Icon(Icons.home_outlined)),
                  items: AppConstants.familyTypes.map((ft) => DropdownMenuItem(value: ft, child: Text(ft))).toList(),
                  onChanged: (v) => onUpdate(biodata.copyWith(familyType: v ?? '')),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: b.familyValues.isEmpty ? null : (AppConstants.familyValues.contains(b.familyValues) ? b.familyValues : null),
                        decoration: _deco('Family Values', prefixIcon: const Icon(Icons.people_outline)),
                        items: AppConstants.familyValues.map((fv) => DropdownMenuItem(value: fv, child: Text(fv))).toList(),
                        onChanged: (v) => onUpdate(biodata.copyWith(familyValues: v ?? '')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: b.familyStatus.isEmpty ? null : (AppConstants.familyStatuses.contains(b.familyStatus) ? b.familyStatus : null),
                        decoration: _deco('Family Status', prefixIcon: const Icon(Icons.trending_up_outlined)),
                        items: AppConstants.familyStatuses.map((fs) => DropdownMenuItem(value: fs, child: Text(fs, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (v) => onUpdate(biodata.copyWith(familyStatus: v ?? '')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.nativePlace,
                  decoration: _deco('Native Place / Hometown', hint: 'e.g. Jaipur, Rajasthan', prefixIcon: const Icon(Icons.location_on_outlined)),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(nativePlace: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.familyDescription,
                  decoration: const InputDecoration(
                    labelText: 'Family Description',
                    hintText: 'e.g. We are a close-knit family based in Delhi with traditional values and a modern outlook.',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (v) => onUpdate(biodata.copyWith(familyDescription: v)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        CustomFieldsEditor(
          section: 'family',
          sectionLabel: 'Family Details',
          fields: biodata.customFields,
          onChanged: (fields) => onUpdate(biodata.copyWith(customFields: fields)),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
