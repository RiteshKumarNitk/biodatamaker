import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:biodata_maker/core/constants/app_constants.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';

class BasicDetailsStep extends StatefulWidget {
  final Biodata biodata;
  final void Function(Biodata) onUpdate;

  const BasicDetailsStep({super.key, required this.biodata, required this.onUpdate});

  @override
  State<BasicDetailsStep> createState() => _BasicDetailsStepState();
}

class _BasicDetailsStepState extends State<BasicDetailsStep> {
  late TextEditingController _fullNameCtrl;
  late TextEditingController _ageCtrl;
  late TextEditingController _heightCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _dateOfBirthCtrl;
  late TextEditingController _casteCtrl;
  late TextEditingController _subCasteCtrl;
  late TextEditingController _motherTongueCtrl;

  @override
  void initState() {
    super.initState();
    _fullNameCtrl = TextEditingController(text: widget.biodata.fullName);
    _ageCtrl = TextEditingController(text: widget.biodata.age);
    _heightCtrl = TextEditingController(text: widget.biodata.height);
    _weightCtrl = TextEditingController(text: widget.biodata.weight);
    _dateOfBirthCtrl = TextEditingController(text: widget.biodata.dateOfBirth);
    _casteCtrl = TextEditingController(text: widget.biodata.caste);
    _subCasteCtrl = TextEditingController(text: widget.biodata.subCaste);
    _motherTongueCtrl = TextEditingController(text: widget.biodata.motherTongue);
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _dateOfBirthCtrl.dispose();
    _casteCtrl.dispose();
    _subCasteCtrl.dispose();
    _motherTongueCtrl.dispose();
    super.dispose();
  }

  void _update({
    String? fullName,
    String? gender,
    String? dateOfBirth,
    String? age,
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
  }) {
    widget.onUpdate(widget.biodata.copyWith(
      fullName: fullName ?? _fullNameCtrl.text,
      gender: gender ?? widget.biodata.gender,
      dateOfBirth: dateOfBirth ?? _dateOfBirthCtrl.text,
      age: age ?? _ageCtrl.text,
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
    ));
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
    );

    if (picked != null) {
      final formatted = DateFormat('dd/MM/yyyy').format(picked);
      _dateOfBirthCtrl.text = formatted;

      final now = DateTime.now();
      int calculatedAge = now.year - picked.year;
      if (now.month < picked.month || (now.month == picked.month && now.day < picked.day)) {
        calculatedAge--;
      }
      _ageCtrl.text = calculatedAge.toString();

      _update(dateOfBirth: formatted, age: calculatedAge.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = widget.biodata;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Basic Details', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('Enter the basic personal information', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Personal Info', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _fullNameCtrl,
                  decoration: const InputDecoration(labelText: 'Full Name', hintText: 'Enter full name', prefixIcon: Icon(Icons.person_outline)),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => _update(fullName: v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.gender.isEmpty ? null : b.gender,
                  decoration: const InputDecoration(labelText: 'Gender', prefixIcon: Icon(Icons.wc)),
                  items: AppConstants.genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (v) => _update(gender: v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dateOfBirthCtrl,
                  readOnly: true,
                  onTap: _selectDateOfBirth,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
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
                        controller: _ageCtrl,
                        decoration: const InputDecoration(labelText: 'Age', hintText: 'e.g. 28', prefixIcon: Icon(Icons.numbers)),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => _update(age: v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _heightCtrl,
                        decoration: const InputDecoration(labelText: 'Height', hintText: 'e.g. 5\'9"', prefixIcon: Icon(Icons.height)),
                        onChanged: (v) => _update(height: v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _weightCtrl,
                  decoration: const InputDecoration(labelText: 'Weight', hintText: 'e.g. 65 kg', prefixIcon: Icon(Icons.monitor_weight_outlined)),
                  keyboardType: TextInputType.text,
                  onChanged: (v) => _update(weight: v),
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
                Text('Background & Community', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.religion.isEmpty ? null : b.religion,
                  decoration: const InputDecoration(labelText: 'Religion', prefixIcon: Icon(Icons.church_outlined)),
                  items: AppConstants.religions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (v) => _update(religion: v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _casteCtrl,
                  decoration: const InputDecoration(labelText: 'Caste', hintText: 'Enter caste', prefixIcon: Icon(Icons.groups_outlined)),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => _update(caste: v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _subCasteCtrl,
                  decoration: const InputDecoration(labelText: 'Subcaste', hintText: 'Enter subcaste', prefixIcon: Icon(Icons.group_outlined)),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => _update(subCaste: v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _motherTongueCtrl,
                  decoration: const InputDecoration(labelText: 'Mother Tongue', hintText: 'e.g. Hindi, Gujarati', prefixIcon: Icon(Icons.translate)),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => _update(motherTongue: v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.maritalStatus.isEmpty ? null : b.maritalStatus,
                  decoration: const InputDecoration(labelText: 'Marital Status', prefixIcon: Icon(Icons.favorite_outline)),
                  items: AppConstants.maritalStatuses.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (v) => _update(maritalStatus: v),
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
                Text('Physical & Astrological', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.bloodGroup.isEmpty ? null : b.bloodGroup,
                  decoration: const InputDecoration(labelText: 'Blood Group', prefixIcon: Icon(Icons.bloodtype_outlined)),
                  items: AppConstants.bloodGroups.map((bg) => DropdownMenuItem(value: bg, child: Text(bg))).toList(),
                  onChanged: (v) => _update(bloodGroup: v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.complexion.isEmpty ? null : b.complexion,
                  decoration: const InputDecoration(labelText: 'Complexion', prefixIcon: Icon(Icons.face)),
                  items: AppConstants.complexions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => _update(complexion: v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.manglik.isEmpty ? null : b.manglik,
                  decoration: const InputDecoration(labelText: 'Manglik Status', prefixIcon: Icon(Icons.brightness_auto)),
                  items: AppConstants.manglikStatuses.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (v) => _update(manglik: v),
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
