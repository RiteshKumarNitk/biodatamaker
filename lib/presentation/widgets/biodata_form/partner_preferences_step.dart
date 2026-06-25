import 'package:flutter/material.dart';
import 'package:biodata_maker/data/models/biodata.dart';

/// Step 5: Partner Preferences
class PartnerPreferencesStep extends StatelessWidget {
  final Biodata biodata;
  final ValueChanged<Biodata> onChanged;

  const PartnerPreferencesStep({
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
        _SectionHeader(title: 'Partner Preferences', theme: theme),
        const SizedBox(height: 12),
        _FormField(
          label: 'Preferred Age Range',
          value: biodata.preferredAge,
          onChanged: (v) =>
              onChanged(biodata.copyWith(preferredAge: v)),
          icon: Icons.cake_outlined,
          hint: 'e.g. 25-30 years',
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Preferred Height',
          value: biodata.preferredHeight,
          onChanged: (v) =>
              onChanged(biodata.copyWith(preferredHeight: v)),
          icon: Icons.height,
          hint: 'e.g. 5\'4" and above',
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Preferred Education',
          value: biodata.preferredEducation,
          onChanged: (v) =>
              onChanged(biodata.copyWith(preferredEducation: v)),
          icon: Icons.school_outlined,
          hint: 'e.g. Graduate or above',
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Preferred Occupation',
          value: biodata.preferredOccupation,
          onChanged: (v) =>
              onChanged(biodata.copyWith(preferredOccupation: v)),
          icon: Icons.work_outline,
          hint: 'e.g. Govt. Job / Private Sector',
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Preferred Religion',
          value: biodata.preferredReligion,
          onChanged: (v) =>
              onChanged(biodata.copyWith(preferredReligion: v)),
          icon: Icons.temple_hindu_outlined,
          hint: 'e.g. Hindu',
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Preferred Location',
          value: biodata.preferredLocation,
          onChanged: (v) =>
              onChanged(biodata.copyWith(preferredLocation: v)),
          icon: Icons.location_on_outlined,
          hint: 'e.g. Mumbai, Delhi',
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Expectations / About Partner',
          value: biodata.expectations,
          onChanged: (v) =>
              onChanged(biodata.copyWith(expectations: v)),
          icon: Icons.favorite_outline,
          maxLines: 4,
          hint: 'Describe your expectations from your life partner...',
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
  final int maxLines;

  const _FormField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.icon,
    this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}
