import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:biodata_maker/features/biodata/presentation/bloc/form_bloc.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/multi_step_form.dart';

class EditBiodataScreen extends StatelessWidget {
  final String biodataId;

  const EditBiodataScreen({super.key, required this.biodataId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BiodataFormBloc()..add(InitEditForm(biodataId)),
      child: BlocListener<BiodataFormBloc, BiodataFormState>(
        listener: (context, state) {
          if (state.isSaved && state.biodata != null) {
            context.go('/preview/${state.biodata!.id}');
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Edit Biodata')),
          body: const MultiStepForm(),
        ),
      ),
    );
  }
}
