import 'package:flutter/material.dart';

import 'package:biodata_maker/core/constants/app_constants.dart';
import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/shared/widgets/custom_fields_editor.dart';

class AdditionalDetailsStep extends StatefulWidget {
  final Biodata biodata;
  final void Function(Biodata) onUpdate;

  const AdditionalDetailsStep({super.key, required this.biodata, required this.onUpdate});

  @override
  State<AdditionalDetailsStep> createState() => _AdditionalDetailsStepState();
}

class _AdditionalDetailsStepState extends State<AdditionalDetailsStep> {
  static const _hobbySuggestions = [
    'Reading', 'Gardening', 'Cooking', 'Photography', 'Traveling',
    'Music', 'Fitness', 'Painting', 'Gaming',
  ];
  static const _skillSuggestions = [
    'Leadership', 'Communication', 'Problem Solving', 'Time Management',
    'Creative Thinking', 'Adaptability', 'Teamwork',
  ];

  late TextEditingController _hobbiesCtrl;
  late TextEditingController _personalityCtrl;
  late TextEditingController _aboutMeCtrl;

  @override
  void initState() {
    super.initState();
    _hobbiesCtrl = TextEditingController(text: widget.biodata.hobbies);
    _personalityCtrl = TextEditingController(text: widget.biodata.personality);
    _aboutMeCtrl = TextEditingController(text: widget.biodata.aboutMe);
  }

  @override
  void dispose() {
    _hobbiesCtrl.dispose();
    _personalityCtrl.dispose();
    _aboutMeCtrl.dispose();
    super.dispose();
  }

  void _update({String? hobbies, String? personality, String? aboutMe}) {
    widget.onUpdate(widget.biodata.copyWith(
      hobbies: hobbies ?? _hobbiesCtrl.text,
      personality: personality ?? _personalityCtrl.text,
      aboutMe: aboutMe ?? _aboutMeCtrl.text,
    ));
  }

  List<String> _selectedFrom(TextEditingController ctrl) {
    return ctrl.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  void _toggle(TextEditingController ctrl, String value, void Function(String) onChanged) {
    final selected = _selectedFrom(ctrl);
    if (selected.contains(value)) {
      selected.remove(value);
    } else {
      selected.add(value);
    }
    final joined = selected.join(', ');
    ctrl.text = joined;
    onChanged(joined);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = widget.biodata;
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
                  onChanged: (v) => widget.onUpdate(b.copyWith(diet: v ?? '')),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: b.smoking.isEmpty ? null : (AppConstants.smokingOptions.contains(b.smoking) ? b.smoking : null),
                        decoration: InputDecoration(labelText: Strings.tr('Smoking'), prefixIcon: const Icon(Icons.smoking_rooms_outlined)),
                        items: AppConstants.smokingOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (v) => widget.onUpdate(b.copyWith(smoking: v ?? '')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: b.drinking.isEmpty ? null : (AppConstants.drinkingOptions.contains(b.drinking) ? b.drinking : null),
                        decoration: InputDecoration(labelText: Strings.tr('Drinking'), prefixIcon: const Icon(Icons.local_bar_outlined)),
                        items: AppConstants.drinkingOptions.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                        onChanged: (v) => widget.onUpdate(b.copyWith(drinking: v ?? '')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _hobbiesCtrl,
                  decoration: InputDecoration(
                    labelText: Strings.tr('Hobbies & Interests'),
                    hintText: 'e.g. Reading, Travelling, Cricket, Music',
                    prefixIcon: const Icon(Icons.self_improvement_outlined),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 2,
                  onChanged: (v) => _update(hobbies: v),
                ),
                const SizedBox(height: 8),
                Text(Strings.tr('Quick select:'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _hobbySuggestions.map((hobby) {
                    final selected = _selectedFrom(_hobbiesCtrl).contains(hobby);
                    return FilterChip(
                      label: Text(hobby),
                      selected: selected,
                      visualDensity: VisualDensity.compact,
                      onSelected: (_) => setState(() => _toggle(_hobbiesCtrl, hobby, (v) => _update(hobbies: v))),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _personalityCtrl,
                  decoration: InputDecoration(
                    labelText: Strings.tr('Personality'),
                    hintText: 'e.g. Friendly, Caring, Family-oriented',
                    prefixIcon: const Icon(Icons.psychology_outlined),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (v) => _update(personality: v),
                ),
                const SizedBox(height: 8),
                Text(Strings.tr('Quick select:'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _skillSuggestions.map((skill) {
                    final selected = _selectedFrom(_personalityCtrl).contains(skill);
                    return FilterChip(
                      label: Text(skill),
                      selected: selected,
                      visualDensity: VisualDensity.compact,
                      onSelected: (_) => setState(() => _toggle(_personalityCtrl, skill, (v) => _update(personality: v))),
                    );
                  }).toList(),
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
                  controller: _aboutMeCtrl,
                  decoration: InputDecoration(
                    labelText: Strings.tr('About Me'),
                    hintText: 'Write a short bio about yourself',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (v) => _update(aboutMe: v),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        CustomFieldsEditor(
          section: 'lifestyle',
          sectionLabel: 'Lifestyle & Interests',
          fields: widget.biodata.customFields,
          onChanged: (fields) =>
              widget.onUpdate(widget.biodata.copyWith(customFields: fields)),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
