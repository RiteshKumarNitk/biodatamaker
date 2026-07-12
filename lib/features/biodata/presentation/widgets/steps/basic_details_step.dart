import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _fullNameCtrl = TextEditingController(text: widget.biodata.fullName);
    _ageCtrl = TextEditingController(text: widget.biodata.age);
    _heightCtrl = TextEditingController(text: widget.biodata.height);
    _weightCtrl = TextEditingController(text: widget.biodata.weight);
    _dateOfBirthCtrl = TextEditingController(text: widget.biodata.dateOfBirth);
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _dateOfBirthCtrl.dispose();
    super.dispose();
  }

  void _update({String? fullName, String? gender, String? dateOfBirth, String? age, String? height, String? weight, String? religion, String? caste, String? subCaste, String? motherTongue, String? maritalStatus, String? bloodGroup, String? complexion, String? manglik}) {
    widget.onUpdate(widget.biodata.copyWith(
      fullName: fullName ?? _fullNameCtrl.text,
      gender: gender ?? widget.biodata.gender,
      dateOfBirth: dateOfBirth ?? _dateOfBirthCtrl.text,
      age: age ?? _ageCtrl.text,
      height: height ?? _heightCtrl.text,
      weight: weight ?? _weightCtrl.text,
      religion: religion ?? widget.biodata.religion,
      caste: caste ?? widget.biodata.caste,
      subCaste: subCaste ?? widget.biodata.subCaste,
      motherTongue: motherTongue ?? widget.biodata.motherTongue,
      maritalStatus: maritalStatus ?? widget.biodata.maritalStatus,
      bloodGroup: bloodGroup ?? widget.biodata.bloodGroup,
      complexion: complexion ?? widget.biodata.complexion,
      manglik: manglik ?? widget.biodata.manglik,
    ));
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
                  decoration: const InputDecoration(labelText: 'Full Name', hintText: 'Enter full name'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => _update(fullName: v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.gender.isEmpty ? null : b.gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: AppConstants.genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (v) => _update(gender: v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dateOfBirthCtrl,
                  decoration: const InputDecoration(labelText: 'Date of Birth', hintText: 'DD/MM/YYYY'),
                  keyboardType: TextInputType.datetime,
                  onChanged: (v) => _update(dateOfBirth: v),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ageCtrl,
                        decoration: const InputDecoration(labelText: 'Age', hintText: 'e.g. 28'),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => _update(age: v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _heightCtrl,
                        decoration: const InputDecoration(labelText: 'Height', hintText: 'e.g. 5\'9"'),
                        onChanged: (v) => _update(height: v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _weightCtrl,
                  decoration: const InputDecoration(labelText: 'Weight', hintText: 'e.g. 65 kg'),
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
                Text('Background', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.religion.isEmpty ? null : b.religion,
                  decoration: const InputDecoration(labelText: 'Religion'),
                  items: AppConstants.religions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (v) => _update(religion: v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.caste,
                  decoration: const InputDecoration(labelText: 'Caste', hintText: 'Enter caste'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => _update(caste: v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.subCaste,
                  decoration: const InputDecoration(labelText: 'Subcaste', hintText: 'Enter subcaste'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => _update(subCaste: v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: b.motherTongue,
                  decoration: const InputDecoration(labelText: 'Mother Tongue', hintText: 'e.g. Hindi'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => _update(motherTongue: v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.maritalStatus.isEmpty ? null : b.maritalStatus,
                  decoration: const InputDecoration(labelText: 'Marital Status'),
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
                Text('Physical', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.bloodGroup.isEmpty ? null : b.bloodGroup,
                  decoration: const InputDecoration(labelText: 'Blood Group'),
                  items: AppConstants.bloodGroups.map((bg) => DropdownMenuItem(value: bg, child: Text(bg))).toList(),
                  onChanged: (v) => _update(bloodGroup: v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: b.complexion.isEmpty ? null : b.complexion,
                  decoration: const InputDecoration(labelText: 'Complexion'),
                  items: AppConstants.complexions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => _update(complexion: v),
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
                DropdownButtonFormField<String>(
                  initialValue: b.manglik.isEmpty ? null : b.manglik,
                  decoration: const InputDecoration(labelText: 'Manglik'),
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
