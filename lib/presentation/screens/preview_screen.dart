import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biodata_maker/presentation/providers/app_providers.dart';

class PreviewScreen extends ConsumerWidget {
  final String biodataId;

  const PreviewScreen({super.key, required this.biodataId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hiveService = ref.read(hiveServiceProvider);
    final biodata = hiveService.getBiodata(biodataId);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        actions: [
          if (biodata != null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // TODO: Implement share
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share coming in Phase 6!')),
                );
              },
              tooltip: 'Share',
            ),
          ],
        ],
      ),
      floatingActionButton: biodata != null
          ? FloatingActionButton.extended(
              onPressed: () {
                // TODO: Implement PDF export
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PDF export coming in Phase 6!')),
                );
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export PDF'),
            )
          : null,
      body: biodata == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Biodata not found',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Preview placeholder
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 600),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                size: 48,
                                color: theme.colorScheme.primary.withOpacity(0.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              biodata.fullName.isNotEmpty
                                  ? biodata.fullName
                                  : biodata.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (biodata.occupation.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Center(
                              child: Text(
                                biodata.occupation,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),
                          _PreviewSection(
                            title: 'Personal Details',
                            items: {
                              'Age': '${biodata.age}',
                              'Religion': biodata.religion,
                              'Caste': biodata.caste,
                              'Mother Tongue': biodata.motherTongue,
                              'Height': biodata.height,
                              'Complexion': biodata.complexion,
                            },
                          ),
                          const SizedBox(height: 16),
                          _PreviewSection(
                            title: 'Education & Career',
                            items: {
                              'Qualification': biodata.qualification,
                              'Occupation': biodata.occupation,
                              'Company': biodata.company,
                              'Annual Income': biodata.annualIncome,
                            },
                          ),
                          const SizedBox(height: 16),
                          _PreviewSection(
                            title: 'Family',
                            items: {
                              'Father': biodata.fatherName,
                              'Mother': biodata.motherName,
                              'Family Type': biodata.familyType,
                              'Native Place': biodata.nativePlace,
                            },
                          ),
                          const SizedBox(height: 16),
                          _PreviewSection(
                            title: 'Contact',
                            items: {
                              'Mobile': biodata.mobile,
                              'City': biodata.city,
                              'State': biodata.state,
                            },
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: Text(
                              'Theme Engine Preview coming in Phase 4',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  final String title;
  final Map<String, String> items;

  const _PreviewSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final validItems =
        items.entries.where((e) => e.value.isNotEmpty).toList();
    if (validItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        ...validItems.map(
          (entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    '${entry.key}:',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    entry.value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
