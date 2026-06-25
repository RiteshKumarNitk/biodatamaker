import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:biodata_maker/presentation/widgets/biodata_form/multi_step_form_scaffold.dart';

class EditBiodataScreen extends ConsumerWidget {
  final String biodataId;

  const EditBiodataScreen({super.key, required this.biodataId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MultiStepFormScaffold(
      existingBiodataId: biodataId,
      onSaved: () {
        if (context.mounted) {
          context.go('/preview/$biodataId');
        }
      },
    );
  }
}
