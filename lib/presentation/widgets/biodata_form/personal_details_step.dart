import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biodata_maker/data/models/biodata.dart';
import 'package:biodata_maker/core/constants/app_constants.dart';

/// Step 1: Personal Details
class PersonalDetailsStep extends StatelessWidget {
  final Biodata biodata;
  final ValueChanged<Biodata> onChanged;

  const PersonalDetailsStep({
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
        _SectionHeader(title: 'Basic Information', theme: theme),
        const SizedBox(height: 12),
        _FormField(
          label: 'Full Name',
          value: biodata.fullName,
          onChanged: (v) => onChanged(biodata.copyWith(fullName: v)),
          icon: Icons.person_outline,
          required: true,
        ),
        const SizedBox(height: 12),
        _DropdownField(
          label: 'Gender',
          value: biodata.gender.isEmpty ? null : biodata.gender,
          items: AppConstants.genders,
          onChanged: (v) => onChanged(biodata.copyWith(gender: v ?? '')),
          icon: Icons.wc_outlined,
          required: true,
        ),
        const SizedBox(height: 12),
        _DateField(
          label: 'Date of Birth',
          value: biodata.dateOfBirth,
          onChanged: (v) {
            final age = v != null
                ? DateTime.now().year -
                    v.year -
                    ((DateTime.now().month < v.month ||
                            (DateTime.now().month == v.month &&
                                DateTime.now().day < v.day))
                        ? 1
                        : 0)
                : 0;
            onChanged(biodata.copyWith(dateOfBirth: v, age: age));
          },
          icon: Icons.cake_outlined,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Age',
          value: biodata.age > 0 ? biodata.age.toString() : '',
          onChanged: (v) => onChanged(
              biodata.copyWith(age: int.tryParse(v) ?? 0)),
          icon: Icons.timer_outlined,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Height',
          value: biodata.height,
          onChanged: (v) => onChanged(biodata.copyWith(height: v)),
          icon: Icons.height,
          hint: 'e.g. 5\'8" or 173 cm',
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Weight',
          value: biodata.weight,
          onChanged: (v) => onChanged(biodata.copyWith(weight: v)),
          icon: Icons.monitor_weight_outlined,
          hint: 'e.g. 70 kg',
        ),

        const SizedBox(height: 24),
        _SectionHeader(title: 'Religious & Cultural', theme: theme),
        const SizedBox(height: 12),
        _DropdownField(
          label: 'Religion',
          value: biodata.religion.isEmpty ? null : biodata.religion,
          items: AppConstants.religions,
          onChanged: (v) => onChanged(biodata.copyWith(religion: v ?? '')),
          icon: Icons.temple_hindu_outlined,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Caste',
          value: biodata.caste,
          onChanged: (v) => onChanged(biodata.copyWith(caste: v)),
          icon: Icons.group_outlined,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Sub-Caste',
          value: biodata.subCaste,
          onChanged: (v) => onChanged(biodata.copyWith(subCaste: v)),
          icon: Icons.group_outlined,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Mother Tongue',
          value: biodata.motherTongue,
          onChanged: (v) => onChanged(biodata.copyWith(motherTongue: v)),
          icon: Icons.translate,
        ),
        const SizedBox(height: 12),
        _DropdownField(
          label: 'Marital Status',
          value:
              biodata.maritalStatus.isEmpty ? null : biodata.maritalStatus,
          items: AppConstants.maritalStatuses,
          onChanged: (v) =>
              onChanged(biodata.copyWith(maritalStatus: v ?? '')),
          icon: Icons.favorite_outline,
        ),
        const SizedBox(height: 12),
        _DropdownField(
          label: 'Blood Group',
          value: biodata.bloodGroup.isEmpty ? null : biodata.bloodGroup,
          items: AppConstants.bloodGroups,
          onChanged: (v) =>
              onChanged(biodata.copyWith(bloodGroup: v ?? '')),
          icon: Icons.bloodtype_outlined,
        ),
        const SizedBox(height: 12),
        _DropdownField(
          label: 'Complexion',
          value: biodata.complexion.isEmpty ? null : biodata.complexion,
          items: AppConstants.complexions,
          onChanged: (v) =>
              onChanged(biodata.copyWith(complexion: v ?? '')),
          icon: Icons.palette_outlined,
        ),

        const SizedBox(height: 24),
        _SectionHeader(title: 'Astrological (Optional)', theme: theme),
        const SizedBox(height: 12),
        _DropdownField(
          label: 'Manglik',
          value: biodata.manglik.isEmpty ? null : biodata.manglik,
          items: AppConstants.manglikStatuses,
          onChanged: (v) => onChanged(biodata.copyWith(manglik: v ?? '')),
          icon: Icons.star_outline,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Rashi',
          value: biodata.rashi,
          onChanged: (v) => onChanged(biodata.copyWith(rashi: v)),
          icon: Icons.auto_awesome,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Nakshatra',
          value: biodata.nakshatra,
          onChanged: (v) => onChanged(biodata.copyWith(nakshatra: v)),
          icon: Icons.auto_awesome,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Gotra',
          value: biodata.gotra,
          onChanged: (v) => onChanged(biodata.copyWith(gotra: v)),
          icon: Icons.family_restroom_outlined,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Birth Place',
          value: biodata.birthPlace,
          onChanged: (v) => onChanged(biodata.copyWith(birthPlace: v)),
          icon: Icons.location_on_outlined,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Birth Time',
          value: biodata.birthTime,
          onChanged: (v) => onChanged(biodata.copyWith(birthTime: v)),
          icon: Icons.access_time,
          hint: 'e.g. 10:30 AM',
        ),

        const SizedBox(height: 24),
        _SectionHeader(title: 'About Me', theme: theme),
        const SizedBox(height: 12),
        _FormField(
          label: 'About Me',
          value: biodata.aboutMe,
          onChanged: (v) => onChanged(biodata.copyWith(aboutMe: v)),
          icon: Icons.info_outline,
          maxLines: 4,
          hint: 'Tell us about yourself...',
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
  final bool required;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _FormField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.icon,
    this.hint,
    this.required = false,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
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
  final bool required;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.icon,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
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

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final IconData icon;

  const _DateField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime(1995),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        onChanged(date);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
        ),
        child: Text(
          value != null
              ? '${value!.day}/${value!.month}/${value!.year}'
              : 'Select date',
          style: TextStyle(
            color: value != null
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
