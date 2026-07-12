import 'package:flutter/material.dart';

import 'package:biodata_maker/core/constants/app_constants.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';

class FamilyStep extends StatelessWidget {
  final Biodata biodata;
  final void Function(Biodata) onUpdate;

  const FamilyStep({super.key, required this.biodata, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = biodata;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Family Details', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('Enter family background information', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Parents', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.fatherName,
                  decoration: const InputDecoration(labelText: 'Father\'s Name', hintText: 'Enter father\'s name'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(fatherName: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.fatherOccupation,
                  decoration: const InputDecoration(labelText: 'Father\'s Occupation', hintText: 'Enter father\'s occupation'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(fatherOccupation: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.motherName,
                  decoration: const InputDecoration(labelText: 'Mother\'s Name', hintText: 'Enter mother\'s name'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(motherName: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.motherOccupation,
                  decoration: const InputDecoration(labelText: 'Mother\'s Occupation', hintText: 'Enter mother\'s occupation'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(motherOccupation: v)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Siblings', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: b.brothers,
                        decoration: const InputDecoration(labelText: 'Brothers', hintText: 'Count & details'),
                        keyboardType: TextInputType.text,
                        onChanged: (v) => onUpdate(biodata.copyWith(brothers: v)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: b.sisters,
                        decoration: const InputDecoration(labelText: 'Sisters', hintText: 'Count & details'),
                        keyboardType: TextInputType.text,
                        onChanged: (v) => onUpdate(biodata.copyWith(sisters: v)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Family Background', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.familyType.isEmpty ? null : b.familyType,
                  decoration: const InputDecoration(labelText: 'Family Type'),
                  items: AppConstants.familyTypes.map((ft) => DropdownMenuItem(value: ft, child: Text(ft))).toList(),
                  onChanged: (v) => onUpdate(biodata.copyWith(familyType: v ?? '')),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.familyValues.isEmpty ? null : b.familyValues,
                  decoration: const InputDecoration(labelText: 'Family Values'),
                  items: AppConstants.familyValues.map((fv) => DropdownMenuItem(value: fv, child: Text(fv))).toList(),
                  onChanged: (v) => onUpdate(biodata.copyWith(familyValues: v ?? '')),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.nativePlace,
                  decoration: const InputDecoration(labelText: 'Native Place', hintText: 'Enter native place'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(nativePlace: v)),
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
