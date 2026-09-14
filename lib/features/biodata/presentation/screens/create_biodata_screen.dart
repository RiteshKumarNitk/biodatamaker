import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:biodata_maker/features/biodata/presentation/bloc/form_bloc.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/multi_step_form.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/wizard_preview_action.dart';

class CreateBiodataScreen extends StatelessWidget {
  final String? templateId;

  const CreateBiodataScreen({super.key, this.templateId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BiodataFormBloc()..add(InitNewForm(templateId: templateId)),
      child: BlocListener<BiodataFormBloc, BiodataFormState>(
        listenWhen: (prev, curr) => !prev.isSaved && curr.isSaved,
        listener: (context, state) {
          if (state.biodata != null) {
            context.go('/preview/${state.biodata!.id}');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Create Biodata'),
            // Builder gives a context inside BlocProvider's subtree, unlike
            // this build method's own context (its parent).
            actions: [Builder(builder: (innerContext) => Row(mainAxisSize: MainAxisSize.min, children: wizardPreviewAppBarActions(innerContext)))],
          ),
          body: const MultiStepForm(),
        ),
      ),
    );
  }
}
