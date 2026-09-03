import 'package:flutter/material.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/biodata/data/models/custom_field.dart';

class ContactPartnerStep extends StatefulWidget {
  final Biodata biodata;
  final void Function(Biodata) onUpdate;

  const ContactPartnerStep({
    super.key,
    required this.biodata,
    required this.onUpdate,
  });

  @override
  State<ContactPartnerStep> createState() => _ContactPartnerStepState();
}

class _ContactPartnerStepState extends State<ContactPartnerStep> {
  late TextEditingController _mobileCtrl;
  late TextEditingController _whatsappCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _countryCtrl;

  late TextEditingController _prefAgeCtrl;
  late TextEditingController _prefHeightCtrl;
  late TextEditingController _prefEducationCtrl;
  late TextEditingController _prefOccupationCtrl;
  late TextEditingController _prefReligionCtrl;
  late TextEditingController _prefLocationCtrl;
  late TextEditingController _expectationsCtrl;

  @override
  void initState() {
    super.initState();
    final b = widget.biodata;
    _mobileCtrl = TextEditingController(text: b.mobile);
    _whatsappCtrl = TextEditingController(text: b.whatsapp);
    _emailCtrl = TextEditingController(text: b.email);
    _addressCtrl = TextEditingController(text: b.address);
    _cityCtrl = TextEditingController(text: b.city);
    _stateCtrl = TextEditingController(text: b.state);
    _countryCtrl = TextEditingController(text: b.country);

    _prefAgeCtrl = TextEditingController(text: b.preferredAge);
    _prefHeightCtrl = TextEditingController(text: b.preferredHeight);
    _prefEducationCtrl = TextEditingController(text: b.preferredEducation);
    _prefOccupationCtrl = TextEditingController(text: b.preferredOccupation);
    _prefReligionCtrl = TextEditingController(text: b.preferredReligion);
    _prefLocationCtrl = TextEditingController(text: b.preferredLocation);
    _expectationsCtrl = TextEditingController(text: b.expectations);
  }

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _whatsappCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _countryCtrl.dispose();

    _prefAgeCtrl.dispose();
    _prefHeightCtrl.dispose();
    _prefEducationCtrl.dispose();
    _prefOccupationCtrl.dispose();
    _prefReligionCtrl.dispose();
    _prefLocationCtrl.dispose();
    _expectationsCtrl.dispose();
    super.dispose();
  }

  void _update() {
    widget.onUpdate(widget.biodata.copyWith(
      mobile: _mobileCtrl.text,
      whatsapp: _whatsappCtrl.text,
      email: _emailCtrl.text,
      address: _addressCtrl.text,
      city: _cityCtrl.text,
      state: _stateCtrl.text,
      country: _countryCtrl.text,
      preferredAge: _prefAgeCtrl.text,
      preferredHeight: _prefHeightCtrl.text,
      preferredEducation: _prefEducationCtrl.text,
      preferredOccupation: _prefOccupationCtrl.text,
      preferredReligion: _prefReligionCtrl.text,
      preferredLocation: _prefLocationCtrl.text,
      expectations: _expectationsCtrl.text,
    ));
  }

  void _showAddCustomFieldDialog() {
    final labelCtrl = TextEditingController();
    final valueCtrl = TextEditingController();
    String section = 'personal';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          title: const Text('Add Custom Field'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelCtrl,
                decoration: const InputDecoration(
                  labelText: 'Field Name (e.g. Passport, Hobby)',
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: valueCtrl,
                decoration: const InputDecoration(
                  labelText: 'Field Value',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: section,
                decoration: const InputDecoration(labelText: 'Belongs to Section'),
                items: const [
                  DropdownMenuItem(value: 'personal', child: Text('Personal Details')),
                  DropdownMenuItem(value: 'education', child: Text('Education & Career')),
                  DropdownMenuItem(value: 'family', child: Text('Family Details')),
                  DropdownMenuItem(value: 'lifestyle', child: Text('Lifestyle & Astro')),
                  DropdownMenuItem(value: 'contact', child: Text('Contact Info')),
                  DropdownMenuItem(value: 'partner_preference', child: Text('Partner Preference')),
                ],
                onChanged: (v) {
                  if (v != null) setDlgState(() => section = v);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (labelCtrl.text.trim().isNotEmpty && valueCtrl.text.trim().isNotEmpty) {
                  final newField = CustomField(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    label: labelCtrl.text.trim(),
                    value: valueCtrl.text.trim(),
                    section: section,
                  );
                  final updatedList = [...widget.biodata.customFields, newField];
                  widget.onUpdate(widget.biodata.copyWith(customFields: updatedList));
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _removeCustomField(int index) {
    final updatedList = [...widget.biodata.customFields]..removeAt(index);
    widget.onUpdate(widget.biodata.copyWith(customFields: updatedList));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Contact & Partner Preference',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          'Enter contact info, partner expectations, or add custom fields',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Information',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _mobileCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    hintText: '+91 9876543210',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _whatsappCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'WhatsApp Number',
                    hintText: '+91 9876543210',
                    prefixIcon: Icon(Icons.chat_outlined),
                  ),
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'example@domain.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Residential Address',
                    hintText: 'Street / House No / Landmark',
                    prefixIcon: Icon(Icons.home_outlined),
                  ),
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cityCtrl,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          hintText: 'e.g. Mumbai',
                        ),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (_) => _update(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _stateCtrl,
                        decoration: const InputDecoration(
                          labelText: 'State',
                          hintText: 'e.g. Maharashtra',
                        ),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (_) => _update(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _countryCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    hintText: 'e.g. India',
                    prefixIcon: Icon(Icons.public_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => _update(),
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
                Text(
                  'Partner Preferences',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _prefAgeCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Preferred Age',
                          hintText: 'e.g. 24-28 yrs',
                        ),
                        onChanged: (_) => _update(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _prefHeightCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Preferred Height',
                          hintText: 'e.g. 5\'4" to 5\'8"',
                        ),
                        onChanged: (_) => _update(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _prefEducationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Preferred Education',
                    hintText: 'e.g. Graduate / Post Graduate',
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _prefOccupationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Preferred Occupation',
                    hintText: 'e.g. Working Professional / Business',
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _prefReligionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Preferred Caste / Religion',
                    hintText: 'e.g. Hindu / No caste bar',
                    prefixIcon: Icon(Icons.diversity_3_outlined),
                  ),
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _prefLocationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Preferred Location',
                    hintText: 'e.g. Mumbai, Pune or Abroad',
                    prefixIcon: Icon(Icons.location_city_outlined),
                  ),
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _expectationsCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Other Expectations',
                    hintText: 'Mention any values or lifestyle preferences',
                    alignLabelWithHint: true,
                  ),
                  onChanged: (_) => _update(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Custom Fields',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _showAddCustomFieldDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Field'),
                    ),
                  ],
                ),
                if (widget.biodata.customFields.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No custom fields added. Tap "Add Field" to include extra information (e.g. Passport status, Property details).',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  )
                else
                  ...widget.biodata.customFields.asMap().entries.map((entry) {
                    final index = entry.key;
                    final field = entry.value;
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(field.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('${field.value} (${field.section})'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _removeCustomField(index),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
