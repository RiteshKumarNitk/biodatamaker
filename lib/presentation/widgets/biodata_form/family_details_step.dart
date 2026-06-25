import 'package:flutter/material.dart';
import 'package:biodata_maker/data/models/biodata.dart';
import 'package:biodata_maker/core/constants/app_constants.dart';

/// Step 3: Family Details
class FamilyDetailsStep extends StatelessWidget {
  final Biodata biodata;
  final ValueChanged<Biodata> onChanged;

  const FamilyDetailsStep({
    super.key,
    required this.biodata,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionHeader(title: 'Parents', theme: theme),
        const SizedBox(height: 12),
        _FormField(
          label: "Father's Name",
          value: biodata.fatherName,
          onChanged: (v) => onChanged(biodata.copyWith(fatherName: v)),
          icon: Icons.man_outlined,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: "Father's Occupation",
          value: biodata.fatherOccupation,
          onChanged: (v) =>
              onChanged(biodata.copyWith(fatherOccupation: v)),
          icon: Icons.work_outline,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: "Mother's Name",
          value: biodata.motherName,
          onChanged: (v) => onChanged(biodata.copyWith(motherName: v)),
          icon: Icons.woman_outlined,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: "Mother's Occupation",
          value: biodata.motherOccupation,
          onChanged: (v) =>
              onChanged(biodata.copyWith(motherOccupation: v)),
          icon: Icons.work_outline,
        ),

        const SizedBox(height: 24),
        _SectionHeader(title: 'Siblings', theme: theme),
        const SizedBox(height: 12),
        _FormField(
          label: 'Brothers',
          value: biodata.brothers,
          onChanged: (v) => onChanged(biodata.copyWith(brothers: v)),
          icon: Icons.people_outline,
          hint: 'e.g. 1 Elder Brother (Married)',
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Sisters',
          value: biodata.sisters,
          onChanged: (v) => onChanged(biodata.copyWith(sisters: v)),
          icon: Icons.people_outline,
          hint: 'e.g. 1 Younger Sister (Unmarried)',
        ),

        const SizedBox(height: 24),
        _SectionHeader(title: 'Family Details', theme: theme),
        const SizedBox(height: 12),
        _DropdownField(
          label: 'Family Type',
          value: biodata.familyType.isEmpty ? null : biodata.familyType,
          items: AppConstants.familyTypes,
          onChanged: (v) =>
              onChanged(biodata.copyWith(familyType: v ?? '')),
          icon: Icons.home_outlined,
        ),
        const SizedBox(height: 12),
        _DropdownField(
          label: 'Family Values',
          value:
              biodata.familyValues.isEmpty ? null : biodata.familyValues,
          items: AppConstants.familyValues,
          onChanged: (v) =>
              onChanged(biodata.copyWith(familyValues: v ?? '')),
          icon: Icons.favorite_outline,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Native Place',
          value: biodata.nativePlace,
          onChanged: (v) => onChanged(biodata.copyWith(nativePlace: v)),
          icon: Icons.location_on_outlined,
          hint: 'e.g. Varanasi, UP',
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

// ─── Shared Form Widgets ────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _SectionHeader({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final IconData icon;
  final String? hint;

  const _FormField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.icon,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final IconData icon;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
