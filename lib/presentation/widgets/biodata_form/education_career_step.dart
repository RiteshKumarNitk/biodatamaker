import 'package:flutter/material.dart';
import 'package:biodata_maker/data/models/biodata.dart';

/// Step 2: Education & Career
class EducationCareerStep extends StatelessWidget {
  final Biodata biodata;
  final ValueChanged<Biodata> onChanged;

  const EducationCareerStep({
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
        _SectionHeader(title: 'Education', theme: theme),
        const SizedBox(height: 12),
        _FormField(
          label: 'Highest Qualification',
          value: biodata.qualification,
          onChanged: (v) => onChanged(biodata.copyWith(qualification: v)),
          icon: Icons.school_outlined,
          hint: 'e.g. B.Tech, MBA, MBBS',
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'College / University',
          value: biodata.college,
          onChanged: (v) => onChanged(biodata.copyWith(college: v)),
          icon: Icons.account_balance_outlined,
          hint: 'e.g. IIT Bombay',
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'University',
          value: biodata.university,
          onChanged: (v) => onChanged(biodata.copyWith(university: v)),
          icon: Icons.account_balance_outlined,
          hint: 'e.g. Mumbai University',
        ),

        const SizedBox(height: 24),
        _SectionHeader(title: 'Career', theme: theme),
        const SizedBox(height: 12),
        _FormField(
          label: 'Occupation',
          value: biodata.occupation,
          onChanged: (v) => onChanged(biodata.copyWith(occupation: v)),
          icon: Icons.work_outline,
          hint: 'e.g. Software Engineer',
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Designation',
          value: biodata.designation,
          onChanged: (v) => onChanged(biodata.copyWith(designation: v)),
          icon: Icons.badge_outlined,
          hint: 'e.g. Senior Manager',
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Company / Organization',
          value: biodata.company,
          onChanged: (v) => onChanged(biodata.copyWith(company: v)),
          icon: Icons.business_outlined,
          hint: 'e.g. TCS, Infosys',
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Business (if applicable)',
          value: biodata.business,
          onChanged: (v) => onChanged(biodata.copyWith(business: v)),
          icon: Icons.store_outlined,
          hint: 'e.g. Family business details',
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'Annual Income',
          value: biodata.annualIncome,
          onChanged: (v) => onChanged(biodata.copyWith(annualIncome: v)),
          icon: Icons.currency_rupee_outlined,
          hint: 'e.g. ₹10-15 LPA',
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

  const _FormField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.icon,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}
