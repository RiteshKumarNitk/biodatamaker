import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/features/biodata/presentation/bloc/form_bloc.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/basic_details_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/education_career_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/family_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/additional_details_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/contact_partner_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/font_selection_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/template_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/steps/download_step.dart';
import 'package:biodata_maker/features/biodata/presentation/widgets/live_preview_panel.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/settings/data/repositories/settings_repository.dart';

/// Minimum width at which the live preview shows side by side with the form
/// (see [_MultiStepFormState.build]) instead of behind the app bar's
/// "Preview" toggle (`wizard_preview_action.dart`). Shared so both stay in
/// sync about where the layout switches over.
const double kSplitPreviewBreakpoint = 900;

class MultiStepForm extends StatefulWidget {
  const MultiStepForm({super.key});

  @override
  State<MultiStepForm> createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  final _settingsRepo = sl<SettingsRepository>();
  int _previousStep = 0;

  static const _stepLabels = [
    'Personal',
    'Education',
    'Family',
    'Lifestyle',
    'Contact',
    'Font',
    'Template',
    'Download',
  ];

  static const _stepIcons = [
    Icons.person,
    Icons.school,
    Icons.family_restroom,
    Icons.spa,
    Icons.contact_phone,
    Icons.font_download,
    Icons.dashboard_customize,
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
              labels: [for (final label in _stepLabels) Strings.tr(label)],
              icons: _stepIcons,
              onStepTapped: (step) {
                // Bloc rejects jumps past the first invalid step and sets a
                // visible error (shown as a snackbar below).
                final bloc = context.read<BiodataFormBloc>();
                bloc.add(GoToStep(step));
                if (bloc.state.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(Strings.tr(bloc.state.error!)),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ).animate().fadeIn(duration: 300.ms),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final stepContent = AnimatedSwitcher(
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
                  );

                  // On wide/tablet screens, show the live template preview
                  // side by side with every data-entry step (Template
                  // through Contact); Review/Download already dedicate their
                  // own screen to reviewing the result. Narrower screens get
                  // a toggle action in the app bar instead (see
                  // wizard_preview_action.dart).
                  final showSplitPreview = constraints.maxWidth >= kSplitPreviewBreakpoint && state.currentStep <= 4;
                  if (!showSplitPreview) return stepContent;

                  return Row(
                    children: [
                      Expanded(flex: 3, child: stepContent),
                      VerticalDivider(width: 1, color: Theme.of(context).colorScheme.outlineVariant),
                      Expanded(flex: 2, child: LivePreviewPanel(biodata: biodata)),
                    ],
                  );
                },
              ),
            ),
            _BottomNav(
              currentStep: state.currentStep,
              totalSteps: BiodataFormState.totalSteps,
              isSaving: state.isSaving,
              onBack: () => context.read<BiodataFormBloc>().add(const PrevStep()),
              onNext: () {
                final name = (state.biodata?.fullName ?? '').trim();
                final isLast = state.currentStep == BiodataFormState.totalSteps - 1;
                if (name.isEmpty && (state.currentStep == 0 || isLast)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          Strings.tr('Please enter your full name to continue')),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                if (isLast) {
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
        return BasicDetailsStep(biodata: biodata, onUpdate: onUpdate);
      case 1:
        return EducationCareerStep(biodata: biodata, onUpdate: onUpdate);
      case 2:
        return FamilyStep(biodata: biodata, onUpdate: onUpdate);
      case 3:
        return AdditionalDetailsStep(biodata: biodata, onUpdate: onUpdate);
      case 4:
        return ContactPartnerStep(biodata: biodata, onUpdate: onUpdate);
      case 5:
        return FontSelectionStep(biodata: biodata, onUpdate: onUpdate);
      case 6:
        return TemplateStep(biodata: biodata, onUpdate: onUpdate);
      case 7:
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
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
                    const SizedBox(height: 4),
                    Text(
                      labels[index],
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        color: isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
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
                label: Text(Strings.tr('Back')),
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
              label: Text(isLastStep
                  ? (isSaving ? Strings.tr('Saving...') : Strings.tr('Save'))
                  : Strings.tr('Next')),
            ),
          ),
        ],
      ),
    );
  }
}
