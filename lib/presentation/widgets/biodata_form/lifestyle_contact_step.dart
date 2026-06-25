import 'package:flutter/material.dart';
import 'package:biodata_maker/data/models/biodata.dart';
import 'package:biodata_maker/core/constants/app_constants.dart';

/// Step 4: Lifestyle & Contact
class LifestyleContactStep extends StatelessWidget {
  final Biodata biodata;
  final ValueChanged<Biodata> onChanged;

  const LifestyleContactStep({
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
        _SectionHeader(title: 'Lifestyle', theme: theme),
        const SizedBox(height: 12),
        _DropdownField(
          label: 'Diet',
          value: biodata.diet.isEmpty ? null : biodata.diet,
          items: AppConstants.diets,
          onChanged: (v) => onChanged(biodata.copyWith(diet: v ?? '')),
          icon: Icons.restaurant_outlined,
        ),
        const SizedBox(height: 12),
        _DropdownField(
          label: 'Smoking',
          value: biodata.smoking.isEmpty ? null : biodata.smoking,
          items: const ['No', 'Yes', 'Occasionally'],
          onChanged: (v) => onChanged(biodata.copyWith(smoking: v ?? '')),
          icon: Icons.smoking_rooms_outlined,
        ),
        const SizedBox(height: 12),
        _DropdownField(
          label: 'Drinking',
          value: biodata.drinking.isEmpty ? null : biodata.drinking,
          items: const ['No', 'Yes', 'Occasionally'],
          onChanged: (v) =>
              onChanged(biodata.copyWith(drinking: v ?? '')),
          icon: Icons.local_bar_outlined,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Languages Known',
          value: biodata.languages,
          onChanged: (v) => onChanged(biodata.copyWith(languages: v)),
          icon: Icons.translate,
          hint: 'e.g. Hindi, English, Marathi',
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Hobbies',
          value: biodata.hobbies,
          onChanged: (v) => onChanged(biodata.copyWith(hobbies: v)),
          icon: Icons.sports_esports_outlined,
          hint: 'e.g. Reading, Traveling, Sports',
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Personality',
          value: biodata.personality,
          onChanged: (v) => onChanged(biodata.copyWith(personality: v)),
          icon: Icons.psychology_outlined,
          hint: 'e.g. Introvert, Ambitious',
        ),

        const SizedBox(height: 24),
        _SectionHeader(title: 'Contact Information', theme: theme),
        const SizedBox(height: 12),
        _FormField(
          label: 'Mobile Number',
          value: biodata.mobile,
          onChanged: (v) => onChanged(biodata.copyWith(mobile: v)),
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'WhatsApp Number',
          value: biodata.whatsapp,
          onChanged: (v) => onChanged(biodata.copyWith(whatsapp: v)),
          icon: Icons.chat_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Email',
          value: biodata.email,
          onChanged: (v) => onChanged(biodata.copyWith(email: v)),
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Address',
          value: biodata.address,
          onChanged: (v) => onChanged(biodata.copyWith(address: v)),
          icon: Icons.home_outlined,
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'City',
          value: biodata.city,
          onChanged: (v) => onChanged(biodata.copyWith(city: v)),
          icon: Icons.location_city_outlined,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'State',
          value: biodata.state,
          onChanged: (v) => onChanged(biodata.copyWith(state: v)),
          icon: Icons.map_outlined,
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Country',
          value: biodata.country,
          onChanged: (v) => onChanged(biodata.copyWith(country: v)),
          icon: Icons.flag_outlined,
          hint: 'India',
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
  final TextInputType? keyboardType;

  const _FormField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.icon,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      maxLines: maxLines,
      keyboardType: keyboardType,
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
