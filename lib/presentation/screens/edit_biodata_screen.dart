import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:biodata_maker/presentation/providers/app_providers.dart';

class EditBiodataScreen extends ConsumerWidget {
  final String biodataId;

  const EditBiodataScreen({super.key, required this.biodataId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hiveService = ref.read(hiveServiceProvider);
    final biodata = hiveService.getBiodata(biodataId);

    return Scaffold(
      appBar: AppBar(
        title: Text(biodata != null ? 'Edit ${biodata.name}' : 'Edit Biodata'),
        actions: [
          if (biodata != null)
            TextButton(
              onPressed: () {
                context.push('/preview/$biodataId');
              },
              child: const Text('Preview'),
            ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.edit_note,
                size: 64,
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'Biodata Editor',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'The multi-step form editor with live preview\nwill be implemented in Phase 2.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                    ),
              ),
              if (biodata != null) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow('Name', biodata.fullName),
                        _InfoRow('Occupation', biodata.occupation),
                        _InfoRow('City', biodata.city),
                        _InfoRow('Religion', biodata.religion),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.5),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
