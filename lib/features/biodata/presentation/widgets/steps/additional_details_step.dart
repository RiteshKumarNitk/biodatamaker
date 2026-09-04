import 'package:flutter/material.dart';

import 'package:biodata_maker/core/constants/app_constants.dart';
import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';

class AdditionalDetailsStep extends StatelessWidget {
  final Biodata biodata;
  final void Function(Biodata) onUpdate;

  const AdditionalDetailsStep({super.key, required this.biodata, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = biodata;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(Strings.tr('Lifestyle & Interests'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(Strings.tr('Enter lifestyle preferences, hobbies and a short bio'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 16),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.tr('Lifestyle'), style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.diet.isEmpty ? null : (AppConstants.diets.contains(b.diet) ? b.diet : null),
                  decoration: InputDecoration(labelText: Strings.tr('Food Preference'), prefixIcon: const Icon(Icons.restaurant_outlined)),
                  items: AppConstants.diets.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                  onChanged: (v) => onUpdate(biodata.copyWith(diet: v ?? '')),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: b.smoking.isEmpty ? null : (AppConstants.smokingOptions.contains(b.smoking) ? b.smoking : null),
                        decoration: InputDecoration(labelText: Strings.tr('Smoking'), prefixIcon: const Icon(Icons.smoking_rooms_outlined)),
                        items: AppConstants.smokingOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (v) => onUpdate(biodata.copyWith(smoking: v ?? '')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: b.drinking.isEmpty ? null : (AppConstants.drinkingOptions.contains(b.drinking) ? b.drinking : null),
                        decoration: InputDecoration(labelText: Strings.tr('Drinking'), prefixIcon: const Icon(Icons.local_bar_outlined)),
                        items: AppConstants.drinkingOptions.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                        onChanged: (v) => onUpdate(biodata.copyWith(drinking: v ?? '')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.hobbies,
                  decoration: InputDecoration(
                    labelText: Strings.tr('Hobbies & Interests'),
                    hintText: 'e.g. Reading, Travelling, Cricket, Music',
                    prefixIcon: const Icon(Icons.self_improvement_outlined),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 2,
                  onChanged: (v) => onUpdate(biodata.copyWith(hobbies: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.personality,
                  decoration: InputDecoration(
                    labelText: Strings.tr('Personality'),
                    hintText: 'e.g. Friendly, Caring, Family-oriented',
                    prefixIcon: const Icon(Icons.psychology_outlined),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (v) => onUpdate(biodata.copyWith(personality: v)),
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
                Text(Strings.tr('About Me'), style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.aboutMe,
                  decoration: InputDecoration(
                    labelText: Strings.tr('About Me'),
                    hintText: 'Write a short bio about yourself',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (v) => onUpdate(biodata.copyWith(aboutMe: v)),
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
