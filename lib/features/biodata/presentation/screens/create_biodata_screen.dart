import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:biodata_maker/core/config/app_config.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/auth/data/repositories/auth_repository.dart';
import 'package:biodata_maker/features/biodata/data/repositories/biodata_repository.dart';
import 'package:biodata_maker/features/biodata/presentation/bloc/form_bloc.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/multi_step_form.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/wizard_preview_action.dart';

class CreateBiodataScreen extends StatelessWidget {
  final String? templateId;

  const CreateBiodataScreen({super.key, this.templateId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _canCreate(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.data == false) {
          return Scaffold(
            appBar: AppBar(title: const Text('Create Biodata')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outlined, size: 64, color: Theme.of(context).colorScheme.error),
                    const SizedBox(height: 16),
                    Text(
                      'Free Limit Reached',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You can create up to ${AppConfig.maxFreeBiodatas} biodatas on the free plan. Please sign in or upgrade to create more.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
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
                actions: [Builder(builder: (innerContext) => Row(mainAxisSize: MainAxisSize.min, children: wizardPreviewAppBarActions(innerContext)))],
              ),
              body: const MultiStepForm(),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _canCreate(BuildContext context) async {
    final user = await sl<AuthRepository>().getCurrentUser();
    if (user == null || !user.isGuest) return true;
    final count = sl<BiodataRepository>().getAll().length;
    return count < AppConfig.maxFreeBiodatas;
  }
}
