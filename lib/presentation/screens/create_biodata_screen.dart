import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:biodata_maker/presentation/widgets/biodata_form/multi_step_form_scaffold.dart';

class CreateBiodataScreen extends ConsumerWidget {
  const CreateBiodataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MultiStepFormScaffold(
      onSaved: () {
        if (context.mounted) {
          context.go('/my-biodatas');
        }
      },
    );
  }
}
