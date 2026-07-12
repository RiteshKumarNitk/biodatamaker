import 'package:flutter/material.dart';

import 'package:biodata_maker/core/constants/app_constants.dart';
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
        Text('Additional Details', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('Enter lifestyle, preferences and more', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lifestyle', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.diet.isEmpty ? null : b.diet,
                  decoration: const InputDecoration(labelText: 'Diet'),
                  items: AppConstants.diets.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                  onChanged: (v) => onUpdate(biodata.copyWith(diet: v ?? '')),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.smoking.isEmpty ? null : b.smoking,
                  decoration: const InputDecoration(labelText: 'Smoking'),
                  items: const [
                    DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                    DropdownMenuItem(value: 'No', child: Text('No')),
                    DropdownMenuItem(value: 'Occasionally', child: Text('Occasionally')),
                  ],
                  onChanged: (v) => onUpdate(biodata.copyWith(smoking: v ?? '')),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.drinking.isEmpty ? null : b.drinking,
                  decoration: const InputDecoration(labelText: 'Drinking'),
                  items: const [
                    DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                    DropdownMenuItem(value: 'No', child: Text('No')),
                    DropdownMenuItem(value: 'Occasionally', child: Text('Occasionally')),
                  ],
                  onChanged: (v) => onUpdate(biodata.copyWith(drinking: v ?? '')),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.languages,
                  decoration: const InputDecoration(labelText: 'Languages', hintText: 'e.g. Hindi, English'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(languages: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.hobbies,
                  decoration: const InputDecoration(labelText: 'Hobbies & Interests', hintText: 'e.g. Reading, Traveling'),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 2,
                  onChanged: (v) => onUpdate(biodata.copyWith(hobbies: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.personality,
                  decoration: const InputDecoration(labelText: 'Personality', hintText: 'e.g. Friendly, Caring'),
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (v) => onUpdate(biodata.copyWith(personality: v)),
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
                Text('Astrological', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.horoscope,
                  decoration: const InputDecoration(labelText: 'Horoscope', hintText: 'Horoscope details'),
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (v) => onUpdate(biodata.copyWith(horoscope: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.rashi,
                  decoration: const InputDecoration(labelText: 'Rashi (Moon Sign)', hintText: 'e.g. Mesh'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(rashi: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.nakshatra,
                  decoration: const InputDecoration(labelText: 'Nakshatra', hintText: 'e.g. Ashwini'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(nakshatra: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.gotra,
                  decoration: const InputDecoration(labelText: 'Gotra', hintText: 'e.g. Kashyap'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(gotra: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.birthPlace,
                  decoration: const InputDecoration(labelText: 'Birth Place', hintText: 'City, State'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => onUpdate(biodata.copyWith(birthPlace: v)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.birthTime,
                  decoration: const InputDecoration(labelText: 'Birth Time', hintText: 'e.g. 10:30 AM'),
                  onChanged: (v) => onUpdate(biodata.copyWith(birthTime: v)),
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
                Text('About Me', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.aboutMe,
                  decoration: const InputDecoration(
                    labelText: 'About Me',
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
