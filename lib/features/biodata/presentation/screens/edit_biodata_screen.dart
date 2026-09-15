import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:biodata_maker/features/biodata/presentation/bloc/form_bloc.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/multi_step_form.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/wizard_preview_action.dart';

class EditBiodataScreen extends StatelessWidget {
  final String biodataId;

  const EditBiodataScreen({super.key, required this.biodataId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BiodataFormBloc()..add(InitEditForm(biodataId)),
      child: BlocListener<BiodataFormBloc, BiodataFormState>(
        listenWhen: (prev, curr) => !prev.isSaved && curr.isSaved,
        listener: (context, state) {
          if (state.biodata != null) {
            context.go('/preview/${state.biodata!.id}');
          }
        },
        child: Builder(
          builder: (context) {
            final isSaved = context.select<BiodataFormBloc, bool>((b) => b.state.isSaved);
            return Scaffold(
              appBar: AppBar(
                title: const Text('Edit Biodata'),
                actions: isSaved
                    ? []
                    : [Builder(builder: (innerContext) => Row(mainAxisSize: MainAxisSize.min, children: wizardPreviewAppBarActions(innerContext)))],
              ),
              body: const MultiStepForm(),
            );
          },
        ),
      ),
    );
  }
}
