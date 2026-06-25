import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:biodata_maker/data/models/biodata.dart';
import 'package:biodata_maker/presentation/providers/app_providers.dart';

class CreateBiodataScreen extends ConsumerWidget {
  const CreateBiodataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Biodata'),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Save biodata
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Biodata form coming in Phase 2!')),
              );
            },
            child: const Text('Save'),
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
                'Biodata Form',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'The multi-step biodata form with auto-save\nwill be implemented in Phase 2.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                    ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Create a demo biodata and navigate to edit
                  final hiveService = ref.read(hiveServiceProvider);
                  final demoId =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  final demoBiodata = Biodata(
                    id: demoId,
                    name: 'Demo Biodata',
                    fullName: 'Rahul Sharma',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    occupation: 'Software Engineer',
                    city: 'Mumbai',
                    religion: 'Hindu',
                    age: 28,
                    gender: 'Male',
                  );
                  hiveService.saveBiodata(demoBiodata);
                  ref.invalidate(statsProvider);
                  ref.invalidate(filteredBiodataProvider);
                  context.push('/edit/$demoId');
                },
                icon: const Icon(Icons.add),
                label: const Text('Create Demo Biodata'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
