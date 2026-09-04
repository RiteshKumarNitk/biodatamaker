import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:biodata_maker/core/constants/app_constants.dart';
import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/shared/widgets/custom_fields_editor.dart';

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
  late TextEditingController _contactPersonCtrl;
  late TextEditingController _mobileCtrl;
  late TextEditingController _alternateCtrl;
  late TextEditingController _whatsappCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _pinCodeCtrl;
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
    _contactPersonCtrl = TextEditingController(text: b.contactPerson);
    _mobileCtrl = TextEditingController(text: b.mobile);
    _alternateCtrl = TextEditingController(text: b.alternateNumber);
    _whatsappCtrl = TextEditingController(text: b.whatsapp);
    _emailCtrl = TextEditingController(text: b.email);
    _addressCtrl = TextEditingController(text: b.address);
    _cityCtrl = TextEditingController(text: b.city);
    _stateCtrl = TextEditingController(text: b.state);
    _pinCodeCtrl = TextEditingController(text: b.pinCode);
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
    _contactPersonCtrl.dispose();
    _mobileCtrl.dispose();
    _alternateCtrl.dispose();
    _whatsappCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _pinCodeCtrl.dispose();
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
      contactPerson: _contactPersonCtrl.text,
      mobile: _mobileCtrl.text,
      alternateNumber: _alternateCtrl.text,
      whatsapp: _whatsappCtrl.text,
      email: _emailCtrl.text,
      address: _addressCtrl.text,
      city: _cityCtrl.text,
      state: _stateCtrl.text,
      pinCode: _pinCodeCtrl.text,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = widget.biodata;

    InputDecoration deco(String label, {String? hint, Widget? prefixIcon}) {
      return InputDecoration(
        labelText: Strings.tr(label),
        hintText: hint,
        prefixIcon: prefixIcon,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          Strings.tr('Contact & Partner Preference'),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          Strings.tr('Enter contact info, partner expectations, or add custom fields'),
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.tr('Contact Details'),
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
                        controller: _contactPersonCtrl,
                        decoration: deco('Contact Person', hint: 'Who should be contacted?'),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (_) => _update(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: b.contactPersonRelation.isEmpty
                            ? null
                            : (AppConstants.relationships.contains(b.contactPersonRelation)
                                ? b.contactPersonRelation
                                : null),
                        decoration: deco('Relationship'),
                        items: AppConstants.relationships.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                        onChanged: (v) => widget.onUpdate(widget.biodata.copyWith(contactPersonRelation: v ?? '')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _mobileCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: deco('Contact Number', hint: '+91 9876543210', prefixIcon: const Icon(Icons.phone_outlined)),
                        onChanged: (_) => _update(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _alternateCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: deco('Alternate Number', hint: 'Optional', prefixIcon: const Icon(Icons.phone_android_outlined)),
                        onChanged: (_) => _update(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _whatsappCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: deco('WhatsApp Number', hint: '+91 9876543210', prefixIcon: const Icon(Icons.chat_outlined)),
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: deco('Email Address', hint: 'example@domain.com', prefixIcon: const Icon(Icons.email_outlined)),
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressCtrl,
                  maxLines: 2,
                  decoration: deco('Residential Address', hint: 'Street / House No / Landmark', prefixIcon: const Icon(Icons.home_outlined)),
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cityCtrl,
                        decoration: deco('City', hint: 'e.g. Mumbai'),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (_) => _update(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _stateCtrl,
                        decoration: deco('State', hint: 'e.g. Maharashtra'),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (_) => _update(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _pinCodeCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                        decoration: deco('PIN Code', hint: 'e.g. 400001', prefixIcon: const Icon(Icons.markunread_mailbox_outlined)),
                        onChanged: (_) => _update(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _countryCtrl,
                        decoration: deco('Country', hint: 'e.g. India', prefixIcon: const Icon(Icons.public_outlined)),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (_) => _update(),
                      ),
                    ),
                  ],
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
                Text(
                  Strings.tr('Partner Preferences'),
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
                        decoration: deco('Preferred Age', hint: 'e.g. 24-28 yrs'),
                        onChanged: (_) => _update(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _prefHeightCtrl,
                        decoration: deco('Preferred Height', hint: "e.g. 5'4\" to 5'8\""),
                        onChanged: (_) => _update(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _prefEducationCtrl,
                  decoration: deco('Preferred Education', hint: 'e.g. Graduate / Post Graduate', prefixIcon: const Icon(Icons.school_outlined)),
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _prefOccupationCtrl,
                  decoration: deco('Preferred Occupation', hint: 'e.g. Working Professional / Business', prefixIcon: const Icon(Icons.work_outline)),
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _prefReligionCtrl,
                  decoration: deco('Preferred Caste / Religion', hint: 'e.g. Hindu / No caste bar', prefixIcon: const Icon(Icons.diversity_3_outlined)),
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _prefLocationCtrl,
                  decoration: deco('Preferred Location', hint: 'e.g. Mumbai, Pune or Abroad', prefixIcon: const Icon(Icons.location_city_outlined)),
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
        CustomFieldsEditor(
          section: 'contact',
          sectionLabel: 'Contact Details',
          fields: widget.biodata.customFields,
          onChanged: (fields) =>
              widget.onUpdate(widget.biodata.copyWith(customFields: fields)),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
