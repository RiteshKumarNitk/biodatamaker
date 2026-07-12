import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:biodata_maker/features/biodata/presentation/bloc/form_bloc.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/photo_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/basic_details_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/family_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/additional_details_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/template_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/preview_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/download_step.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/settings/data/repositories/settings_repository.dart';

class MultiStepForm extends StatefulWidget {
  const MultiStepForm({super.key});

  @override
  State<MultiStepForm> createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  final _settingsRepo = sl<SettingsRepository>();
  int _previousStep = 0;

  static const _stepLabels = [
    'Photo',
    'Basic Details',
    'Family',
    'Additional',
    'Template',
    'Preview',
    'Download',
  ];

  static const _stepIcons = [
    Icons.camera_alt,
    Icons.person,
    Icons.family_restroom,
    Icons.info_outline,
    Icons.dashboard,
    Icons.preview,
    Icons.download,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<BiodataFormBloc, BiodataFormState>(
      builder: (context, state) {
        final biodata = state.biodata;
        if (biodata == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text('Initializing...', style: theme.textTheme.bodyLarge),
              ],
            ),
          );
        }

        final isForward = state.currentStep >= _previousStep;
        _previousStep = state.currentStep;

        return Column(
          children: [
            _StepIndicator(
              key: ValueKey(state.currentStep),
              currentStep: state.currentStep,
              totalSteps: BiodataFormState.totalSteps,
              labels: _stepLabels,
              icons: _stepIcons,
              onStepTapped: (step) {
                context.read<BiodataFormBloc>().add(GoToStep(step));
              },
            ).animate().fadeIn(duration: 300.ms),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  final beginOffset = isForward
                      ? const Offset(0.5, 0)
                      : const Offset(-0.5, 0);
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: beginOffset,
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    )),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey(state.currentStep),
                  child: _buildStepContent(context, state.currentStep, biodata),
                ),
              ),
            ),
            _BottomNav(
              currentStep: state.currentStep,
              totalSteps: BiodataFormState.totalSteps,
              isSaving: state.isSaving,
              onBack: () => context.read<BiodataFormBloc>().add(const PrevStep()),
              onNext: () {
                if (state.currentStep == BiodataFormState.totalSteps - 1) {
                  context.read<BiodataFormBloc>().add(const SaveForm());
                } else {
                  context.read<BiodataFormBloc>().add(const NextStep());
                }
              },
            ).animate().slideY(begin: 0.2, duration: 300.ms),
          ],
        );
      },
    );
  }

  Widget _buildStepContent(BuildContext context, int step, dynamic biodata) {
    void onUpdate(dynamic updated) {
      context.read<BiodataFormBloc>().add(UpdateBiodata(updated));
      _autoSave();
    }

    switch (step) {
      case 0:
        return PhotoStep(biodata: biodata, onUpdate: onUpdate);
      case 1:
        return BasicDetailsStep(biodata: biodata, onUpdate: onUpdate);
      case 2:
        return FamilyStep(biodata: biodata, onUpdate: onUpdate);
      case 3:
        return AdditionalDetailsStep(biodata: biodata, onUpdate: onUpdate);
      case 4:
        return TemplateStep(biodata: biodata, onUpdate: onUpdate);
      case 5:
        return PreviewStep(biodata: biodata);
      case 6:
        return DownloadStep(biodata: biodata);
      default:
        return const SizedBox();
    }
  }

  void _autoSave() {
    final settings = _settingsRepo.getSettings();
    if (settings.autoSave) {
      context.read<BiodataFormBloc>().add(const AutoSaveForm());
    }
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;
  final List<IconData> icons;
  final void Function(int) onStepTapped;

  const _StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
    required this.icons,
    required this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(totalSteps, (index) {
          final isCompleted = index < currentStep;
          final isActive = index == currentStep;
          Color circleColor;
          Widget circleChild;
          if (isCompleted) {
            circleColor = theme.colorScheme.primary;
            circleChild = Icon(Icons.check, size: 14, color: theme.colorScheme.onPrimary);
          } else if (isActive) {
            circleColor = theme.colorScheme.primary;
            circleChild = Icon(icons[index], size: 14, color: theme.colorScheme.onPrimary);
          } else {
            circleColor = theme.colorScheme.outlineVariant;
            circleChild = Icon(icons[index], size: 14, color: theme.colorScheme.onSurfaceVariant);
          }
          return GestureDetector(
            onTap: () => onStepTapped(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                  ),
                  child: circleChild,
                ),
                const SizedBox(height: 2),
                Text(
                  labels[index],
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool isSaving;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const _BottomNav({
    required this.currentStep,
    required this.totalSteps,
    required this.isSaving,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastStep = currentStep == totalSteps - 1;
    final isFirstStep = currentStep == 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          if (!isFirstStep)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
              ),
            )
          else
            const Expanded(child: SizedBox()),
          const SizedBox(width: 16),
          Expanded(
            child: FilledButton.icon(
              onPressed: isSaving ? null : onNext,
              icon: isSaving
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(isLastStep ? Icons.save : Icons.arrow_forward),
              label: Text(isLastStep ? (isSaving ? 'Saving...' : 'Save') : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}
