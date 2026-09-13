import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/features/biodata/presentation/bloc/form_bloc.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/live_preview_panel.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/multi_step_form.dart';

/// App-bar action for [CreateBiodataScreen]/[EditBiodataScreen]: on screens
/// too narrow for `MultiStepForm`'s side-by-side split preview
/// (see `kSplitPreviewBreakpoint`), this opens the same live preview
/// full-screen instead, so the user always has a way to see their data on
/// the selected template without finishing the whole form first.
List<Widget> wizardPreviewAppBarActions(BuildContext context) {
  if (MediaQuery.sizeOf(context).width >= kSplitPreviewBreakpoint) return const [];
  return [
    IconButton(
      icon: const Icon(Icons.visibility_outlined),
      tooltip: Strings.tr('Preview'),
      onPressed: () {
        final bloc = context.read<BiodataFormBloc>();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: Scaffold(
              appBar: AppBar(title: Text(Strings.tr('Live Preview'))),
              body: BlocBuilder<BiodataFormBloc, BiodataFormState>(
                builder: (context, state) {
                  final biodata = state.biodata;
                  if (biodata == null) return const SizedBox();
                  return LivePreviewPanel(biodata: biodata);
                },
              ),
            ),
          ),
        ));
      },
    ),
  ];
}
