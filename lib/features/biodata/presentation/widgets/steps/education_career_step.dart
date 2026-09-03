import 'package:flutter/material.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';

class EducationCareerStep extends StatefulWidget {
  final Biodata biodata;
  final void Function(Biodata) onUpdate;

  const EducationCareerStep({
    super.key,
    required this.biodata,
    required this.onUpdate,
  });

  @override
  State<EducationCareerStep> createState() => _EducationCareerStepState();
}

class _EducationCareerStepState extends State<EducationCareerStep> {
  late TextEditingController _qualificationCtrl;
  late TextEditingController _collegeCtrl;
  late TextEditingController _universityCtrl;
  late TextEditingController _occupationCtrl;
  late TextEditingController _companyCtrl;
  late TextEditingController _businessCtrl;
  late TextEditingController _designationCtrl;
  late TextEditingController _annualIncomeCtrl;

  @override
  void initState() {
    super.initState();
    _qualificationCtrl = TextEditingController(text: widget.biodata.qualification);
    _collegeCtrl = TextEditingController(text: widget.biodata.college);
    _universityCtrl = TextEditingController(text: widget.biodata.university);
    _occupationCtrl = TextEditingController(text: widget.biodata.occupation);
    _companyCtrl = TextEditingController(text: widget.biodata.company);
    _businessCtrl = TextEditingController(text: widget.biodata.business);
    _designationCtrl = TextEditingController(text: widget.biodata.designation);
    _annualIncomeCtrl = TextEditingController(text: widget.biodata.annualIncome);
  }

  @override
  void dispose() {
    _qualificationCtrl.dispose();
    _collegeCtrl.dispose();
    _universityCtrl.dispose();
    _occupationCtrl.dispose();
    _companyCtrl.dispose();
    _businessCtrl.dispose();
    _designationCtrl.dispose();
    _annualIncomeCtrl.dispose();
    super.dispose();
  }

  void _update() {
    widget.onUpdate(widget.biodata.copyWith(
      qualification: _qualificationCtrl.text,
      college: _collegeCtrl.text,
      university: _universityCtrl.text,
      occupation: _occupationCtrl.text,
      company: _companyCtrl.text,
      business: _businessCtrl.text,
      designation: _designationCtrl.text,
      annualIncome: _annualIncomeCtrl.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Education & Career',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          'Add your educational qualifications and professional career details',
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
                  'Education',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _qualificationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Highest Qualification',
                    hintText: 'e.g. B.Tech / MBA / MBBS',
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _collegeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'College / Institute',
                    hintText: 'e.g. IIT Bombay / Stanford',
                    prefixIcon: Icon(Icons.account_balance_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _universityCtrl,
                  decoration: const InputDecoration(
                    labelText: 'University / Board',
                    hintText: 'e.g. Mumbai University',
                    prefixIcon: Icon(Icons.apartment_outlined),
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
                  'Professional Career',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _occupationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Occupation / Field',
                    hintText: 'e.g. Software Engineer / Doctor / Business',
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _companyCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Company / Organization',
                    hintText: 'e.g. Google / Private Practice',
                    prefixIcon: Icon(Icons.business_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _designationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Designation / Job Role',
                    hintText: 'e.g. Senior Tech Lead',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _businessCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Business / Firm Details (Optional)',
                    hintText: 'e.g. Family Retail Business',
                    prefixIcon: Icon(Icons.storefront_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => _update(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _annualIncomeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Annual Income',
                    hintText: 'e.g. ₹18 LPA / \$120k USD',
                    prefixIcon: Icon(Icons.currency_rupee_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => _update(),
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
