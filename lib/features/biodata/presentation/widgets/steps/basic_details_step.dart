import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:biodata_maker/core/constants/app_constants.dart';
import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/shared/widgets/custom_fields_editor.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/photo_step.dart';

class BasicDetailsStep extends StatefulWidget {
  final Biodata biodata;
  final void Function(Biodata) onUpdate;

  const BasicDetailsStep({super.key, required this.biodata, required this.onUpdate});

  @override
  State<BasicDetailsStep> createState() => _BasicDetailsStepState();
}

class _BasicDetailsStepState extends State<BasicDetailsStep> {
  late TextEditingController _fullNameCtrl;
  late TextEditingController _heightCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _dateOfBirthCtrl;
  late TextEditingController _birthPlaceCtrl;
  late TextEditingController _birthTimeCtrl;
  late TextEditingController _casteCtrl;
  late TextEditingController _subCasteCtrl;
  late TextEditingController _motherTongueCtrl;
  late TextEditingController _gotraCtrl;
  late TextEditingController _languagesCtrl;

  @override
  void initState() {
    super.initState();
    _fullNameCtrl = TextEditingController(text: widget.biodata.fullName);
    _heightCtrl = TextEditingController(text: widget.biodata.height);
    _weightCtrl = TextEditingController(text: widget.biodata.weight);
    _dateOfBirthCtrl = TextEditingController(text: widget.biodata.dateOfBirth);
    _birthPlaceCtrl = TextEditingController(text: widget.biodata.birthPlace);
    _birthTimeCtrl = TextEditingController(text: widget.biodata.birthTime);
    _casteCtrl = TextEditingController(text: widget.biodata.caste);
    _subCasteCtrl = TextEditingController(text: widget.biodata.subCaste);
    _motherTongueCtrl = TextEditingController(text: widget.biodata.motherTongue);
    _gotraCtrl = TextEditingController(text: widget.biodata.gotra);
    _languagesCtrl = TextEditingController(text: widget.biodata.languages);
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _dateOfBirthCtrl.dispose();
    _birthPlaceCtrl.dispose();
    _birthTimeCtrl.dispose();
    _casteCtrl.dispose();
    _subCasteCtrl.dispose();
    _motherTongueCtrl.dispose();
    _gotraCtrl.dispose();
    _languagesCtrl.dispose();
    super.dispose();
  }

  void _update({
    String? fullName,
    String? gender,
    String? dateOfBirth,
    String? height,
    String? weight,
    String? religion,
    String? caste,
    String? subCaste,
    String? motherTongue,
    String? maritalStatus,
    String? bloodGroup,
    String? complexion,
    String? manglik,
    String? rashi,
    String? nakshatra,
    String? gotra,
    String? birthPlace,
    String? birthTime,
    String? languages,
  }) {
    widget.onUpdate(widget.biodata.copyWith(
      fullName: fullName ?? _fullNameCtrl.text,
      gender: gender ?? widget.biodata.gender,
      dateOfBirth: dateOfBirth ?? _dateOfBirthCtrl.text,
      height: height ?? _heightCtrl.text,
      weight: weight ?? _weightCtrl.text,
      religion: religion ?? widget.biodata.religion,
      caste: caste ?? _casteCtrl.text,
      subCaste: subCaste ?? _subCasteCtrl.text,
      motherTongue: motherTongue ?? _motherTongueCtrl.text,
      maritalStatus: maritalStatus ?? widget.biodata.maritalStatus,
      bloodGroup: bloodGroup ?? widget.biodata.bloodGroup,
      complexion: complexion ?? widget.biodata.complexion,
      manglik: manglik ?? widget.biodata.manglik,
      rashi: rashi ?? widget.biodata.rashi,
      nakshatra: nakshatra ?? widget.biodata.nakshatra,
      gotra: gotra ?? _gotraCtrl.text,
      birthPlace: birthPlace ?? _birthPlaceCtrl.text,
      birthTime: birthTime ?? _birthTimeCtrl.text,
      languages: languages ?? _languagesCtrl.text,
    ));
  }

  /// Only use a saved value when it still exists in the option list
  /// (older saved drafts may contain values from previous lists).
  String? _validOption(String? value, List<String> options) {
    if (value == null || value.isEmpty) return null;
    return options.contains(value) ? value : null;
  }

  Future<void> _selectDateOfBirth() async {
    DateTime initialDate = DateTime(1995, 1, 1);
    if (_dateOfBirthCtrl.text.isNotEmpty) {
      try {
        initialDate = DateFormat('dd/MM/yyyy').parse(_dateOfBirthCtrl.text);
      } catch (_) {
        try {
          initialDate = DateTime.parse(_dateOfBirthCtrl.text);
        } catch (_) {}
      }
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'SELECT DATE OF BIRTH',
      cancelText: 'CANCEL',
      confirmText: 'OK',
      errorFormatText: 'Enter a valid date (DD/MM/YYYY)',
      errorInvalidText: 'Enter a date between 1950 and today',
    );

    if (picked != null) {
      final formatted = DateFormat('dd/MM/yyyy').format(picked);
      _dateOfBirthCtrl.text = formatted;
      _update(dateOfBirth: formatted);
    }
  }

  Future<void> _selectBirthTime() async {
    TimeOfDay initial = const TimeOfDay(hour: 10, minute: 0);
    if (_birthTimeCtrl.text.isNotEmpty) {
      try {
        final parsed = DateFormat('hh:mm a').parse(_birthTimeCtrl.text);
        initial = TimeOfDay(hour: parsed.hour, minute: parsed.minute);
      } catch (_) {}
    }
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      final formatted = DateFormat('hh:mm a')
          .format(DateTime(2000, 1, 1, picked.hour, picked.minute));
      _birthTimeCtrl.text = formatted;
      _update(birthTime: formatted);
    }
  }

  List<String> get _selectedLanguages {
    return _languagesCtrl.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  void _toggleLanguage(String language) {
    final selected = _selectedLanguages;
    if (selected.contains(language)) {
      selected.remove(language);
    } else {
      selected.add(language);
    }
    final joined = selected.join(', ');
    _languagesCtrl.text = joined;
    _update(languages: joined);
  }

  /// Searchable text field with a suggestion dropdown. Users can pick a
  /// suggestion or keep typing their own value (free text is preserved).
  Widget _autocompleteField({
    required Key key,
    required String initialText,
    required TextEditingController mirror,
    required Iterable<String> Function(String query) options,
    required String label,
    required String hint,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    return Autocomplete<String>(
      key: key,
      initialValue: TextEditingValue(text: initialText),
      optionsBuilder: (text) => options(text.text),
      onSelected: (option) {
        mirror.text = option;
        onChanged(option);
      },
      fieldViewBuilder: (context, controller, focusNode, onSubmit) {
        // Seed the framework-managed controller with the persisted value.
        if (controller.text.isEmpty && initialText.isNotEmpty) {
          controller.text = initialText;
        }
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icon),
          ),
          textCapitalization: TextCapitalization.words,
          onChanged: (v) {
            mirror.text = v;
            onChanged(v);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = widget.biodata;

    InputDecoration deco(String label, {String? hint, Widget? prefixIcon}) {
      return InputDecoration(
        labelText: Strings.tr(label),
        hintText: hint,
        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(Strings.tr('Personal Details'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(Strings.tr('Enter your basic personal information'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 16),
        PhotoStep(biodata: widget.biodata, onUpdate: widget.onUpdate),
        const SizedBox(height: 16),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.tr('Basic Information'), style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _fullNameCtrl,
                  decoration: deco('Full Name *', hint: 'Enter full name', prefixIcon: const Icon(Icons.person_outline)),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => _update(fullName: v),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _validOption(b.gender, AppConstants.genders),
                        decoration: deco('Gender', prefixIcon: const Icon(Icons.wc)),
                        items: AppConstants.genders.map((g) => DropdownMenuItem(value: g, child: Text(g, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (v) => _update(gender: v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _validOption(b.maritalStatus, AppConstants.maritalStatuses),
                        decoration: deco('Marital Status', prefixIcon: const Icon(Icons.favorite_outline)),
                        items: AppConstants.maritalStatuses.map((m) => DropdownMenuItem(value: m, child: Text(m, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (v) => _update(maritalStatus: v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dateOfBirthCtrl,
                  readOnly: true,
                  onTap: _selectDateOfBirth,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth *',
                    hintText: 'DD/MM/YYYY',
                    prefixIcon: const Icon(Icons.cake_outlined),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _selectDateOfBirth,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _birthPlaceCtrl,
                        decoration: deco('Place of Birth', hint: 'e.g. Patna, Bihar', prefixIcon: const Icon(Icons.place_outlined)),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (v) => _update(birthPlace: v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _birthTimeCtrl,
                        readOnly: true,
                        onTap: _selectBirthTime,
                        decoration: InputDecoration(
                          labelText: 'Time of Birth',
                          hintText: 'e.g. 10:30 AM',
                          prefixIcon: const Icon(Icons.schedule),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.access_time),
                            onPressed: _selectBirthTime,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _validOption(b.height, AppConstants.heights),
                        decoration: deco('Height', hint: "e.g. 5'9\"", prefixIcon: const Icon(Icons.height)),
                        items: AppConstants.heights.map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                        onChanged: (v) => _update(height: v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _weightCtrl,
                        decoration: deco('Weight', hint: 'e.g. 65 kg', prefixIcon: const Icon(Icons.monitor_weight_outlined)),
                        onChanged: (v) => _update(weight: v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _validOption(b.complexion, AppConstants.complexions),
                        decoration: deco('Complexion', prefixIcon: const Icon(Icons.face)),
                        items: AppConstants.complexions.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (v) => _update(complexion: v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _validOption(b.bloodGroup, AppConstants.bloodGroups),
                  decoration: deco('Blood Group', prefixIcon: const Icon(Icons.bloodtype_outlined)),
                  items: AppConstants.bloodGroups.map((bg) => DropdownMenuItem(value: bg, child: Text(bg))).toList(),
                  onChanged: (v) => _update(bloodGroup: v),
                ),
                const SizedBox(height: 12),
                _autocompleteField(
                  key: const ValueKey('motherTongue'),
                  initialText: b.motherTongue,
                  mirror: _motherTongueCtrl,
                  options: (query) => query.isEmpty
                      ? AppConstants.languages
                      : AppConstants.languages.where((l) => l.toLowerCase().contains(query.toLowerCase())),
                  label: Strings.tr('Mother Tongue'),
                  hint: 'Search e.g. Hindi',
                  icon: Icons.translate,
                  onChanged: (v) => _update(motherTongue: v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _languagesCtrl,
                  decoration: deco('Languages Known', hint: 'e.g. Hindi, English', prefixIcon: const Icon(Icons.language)),
                  onChanged: (v) => _update(languages: v),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: AppConstants.languages.take(12).map((lang) {
                      final selected = _selectedLanguages.contains(lang);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(lang),
                          selected: selected,
                          visualDensity: VisualDensity.compact,
                          onSelected: (_) => _toggleLanguage(lang),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(Strings.tr('Religion, Community & Astrology'), style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
          subtitle: Text(Strings.tr('Optional - tap to expand'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          initiallyExpanded: b.religion.isNotEmpty || b.caste.isNotEmpty || b.gotra.isNotEmpty,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _validOption(b.religion, AppConstants.religions),
              decoration: deco('Religion', prefixIcon: const Icon(Icons.church_outlined)),
              items: AppConstants.religions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (v) => _update(religion: v),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _casteCtrl,
                    decoration: deco('Caste / Community', hint: 'Enter caste', prefixIcon: const Icon(Icons.groups_outlined)),
                    textCapitalization: TextCapitalization.words,
                    onChanged: (v) => _update(caste: v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _subCasteCtrl,
                    decoration: deco('Sub-caste', hint: 'Enter subcaste', prefixIcon: const Icon(Icons.group_outlined)),
                    textCapitalization: TextCapitalization.words,
                    onChanged: (v) => _update(subCaste: v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _autocompleteField(
              key: const ValueKey('gotra'),
              initialText: b.gotra,
              mirror: _gotraCtrl,
              options: (query) => query.isEmpty
                  ? AppConstants.gotraSuggestions
                  : AppConstants.gotraSuggestions.where((g) => g.toLowerCase().contains(query.toLowerCase())),
              label: Strings.tr('Gotra'),
              hint: 'e.g. Kashyap (optional)',
              icon: Icons.diversity_2_outlined,
              onChanged: (v) => _update(gotra: v),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _validOption(b.rashi, AppConstants.rashis),
                    decoration: deco('Rashi', prefixIcon: const Icon(Icons.brightness_5_outlined)),
                    items: AppConstants.rashis.map((r) => DropdownMenuItem(value: r, child: Text(r, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (v) => _update(rashi: v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _validOption(b.nakshatra, AppConstants.nakshatras),
                    decoration: deco('Nakshatra', prefixIcon: const Icon(Icons.star_outline)),
                    items: AppConstants.nakshatras.map((n) => DropdownMenuItem(value: n, child: Text(n, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (v) => _update(nakshatra: v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _validOption(b.manglik, AppConstants.manglikStatuses),
              decoration: deco('Manglik Status', prefixIcon: const Icon(Icons.auto_awesome_outlined)),
              items: AppConstants.manglikStatuses.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (v) => _update(manglik: v),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomFieldsEditor(
          section: 'personal',
          sectionLabel: 'Personal Details',
          fields: widget.biodata.customFields,
          onChanged: (fields) =>
              widget.onUpdate(widget.biodata.copyWith(customFields: fields)),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
