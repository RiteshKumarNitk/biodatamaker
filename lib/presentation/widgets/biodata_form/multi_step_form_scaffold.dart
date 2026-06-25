import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biodata_maker/data/models/biodata.dart';
import 'package:biodata_maker/presentation/providers/app_providers.dart';
import 'package:biodata_maker/presentation/providers/form_provider.dart';
import 'package:biodata_maker/presentation/widgets/biodata_form/personal_details_step.dart';
import 'package:biodata_maker/presentation/widgets/biodata_form/education_career_step.dart';
import 'package:biodata_maker/presentation/widgets/biodata_form/family_details_step.dart';
import 'package:biodata_maker/presentation/widgets/biodata_form/lifestyle_contact_step.dart';
import 'package:biodata_maker/presentation/widgets/biodata_form/partner_preferences_step.dart';
import 'package:biodata_maker/presentation/widgets/biodata_form/photos_custom_fields_step.dart';

/// A scaffold that manages the multi-step biodata form with
/// a horizontal step indicator, next/back navigation, and auto-save.
class MultiStepFormScaffold extends ConsumerStatefulWidget {
  final String? existingBiodataId; // null = creating new
  final VoidCallback? onSaved;

  const MultiStepFormScaffold({
    super.key,
    this.existingBiodataId,
    this.onSaved,
  });

  @override
  ConsumerState<MultiStepFormScaffold> createState() =>
      _MultiStepFormScaffoldState();
}

class _MultiStepFormScaffoldState
    extends ConsumerState<MultiStepFormScaffold> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Initialize form data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(formDataProvider.notifier);
      if (widget.existingBiodataId != null) {
        notifier.loadExisting(widget.existingBiodataId!);
      } else if (ref.read(formDataProvider) == null) {
        notifier.initNew();
      }
      ref.read(formStepProvider.notifier).state = 0;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _nextStep() {
    final current = ref.read(formStepProvider);
    if (current < totalFormSteps - 1) {
      ref.read(formStepProvider.notifier).state = current + 1;
      _scrollToTop();
      _autoSave();
    }
  }

  void _prevStep() {
    final current = ref.read(formStepProvider);
    if (current > 0) {
      ref.read(formStepProvider.notifier).state = current - 1;
      _scrollToTop();
    }
  }

  Future<void> _autoSave() async {
    final settings = ref.read(settingsProvider);
    if (settings.autoSave) {
      await ref.read(formDataProvider.notifier).autoSave();
    }
  }

  Future<void> _save() async {
    final saved =
        await ref.read(formDataProvider.notifier).save();
    if (saved != null && mounted) {
      ref.invalidate(statsProvider);
      ref.invalidate(filteredBiodataProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biodata saved successfully!')),
      );
      widget.onSaved?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(formStepProvider);
    final biodata = ref.watch(formDataProvider);

    if (biodata == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingBiodataId != null ? 'Edit Biodata' : 'Create Biodata',
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Step Indicator
          _StepIndicator(
            currentStep: currentStep,
            labels: formStepLabels,
          ),

          // Form Content
          Expanded(
            child: _buildStepContent(currentStep, biodata),
          ),

          // Navigation Bar
          _NavigationBar(
            currentStep: currentStep,
            totalSteps: totalFormSteps,
            onBack: _prevStep,
            onNext: _nextStep,
            onSave: _save,
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(int step, Biodata biodata) {
    switch (step) {
      case 0:
        return PersonalDetailsStep(
          biodata: biodata,
          onChanged: (b) =>
              ref.read(formDataProvider.notifier).update(b),
        );
      case 1:
        return EducationCareerStep(
          biodata: biodata,
          onChanged: (b) =>
              ref.read(formDataProvider.notifier).update(b),
        );
      case 2:
        return FamilyDetailsStep(
          biodata: biodata,
          onChanged: (b) =>
              ref.read(formDataProvider.notifier).update(b),
        );
      case 3:
        return LifestyleContactStep(
          biodata: biodata,
          onChanged: (b) =>
              ref.read(formDataProvider.notifier).update(b),
        );
      case 4:
        return PartnerPreferencesStep(
          biodata: biodata,
          onChanged: (b) =>
              ref.read(formDataProvider.notifier).update(b),
        );
      case 5:
        return PhotosCustomFieldsStep(
          biodata: biodata,
          onChanged: (b) =>
              ref.read(formDataProvider.notifier).update(b),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─── Step Indicator ─────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> labels;

  const _StepIndicator({
    required this.currentStep,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isActive = index == currentStep;
          final isCompleted = index < currentStep;
          return Expanded(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Circle
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? theme.colorScheme.primary
                          : isCompleted
                              ? theme.colorScheme.primary.withOpacity(0.15)
                              : theme.colorScheme.surfaceVariant,
                      border: Border.all(
                        color: isActive
                            ? theme.colorScheme.primary
                            : isCompleted
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline.withOpacity(0.3),
                        width: isActive ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? Icon(
                              Icons.check,
                              size: 16,
                              color: theme.colorScheme.primary,
                            )
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurface
                                        .withOpacity(0.5),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Label
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
            ),
          );
        }),
      ),
    );
  }
}

// ─── Navigation Bar ─────────────────────────────────────────────────

class _NavigationBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSave;

  const _NavigationBar({
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
    required this.onNext,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFirst = currentStep == 0;
    final isLast = currentStep == totalSteps - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (!isFirst)
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  child: const Text('Back'),
                ),
              )
            else
              const Spacer(),
            const SizedBox(width: 12),
            if (isLast)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.save, size: 20),
                  label: const Text('Save Biodata'),
                ),
              )
            else
              Expanded(
                child: ElevatedButton(
                  onPressed: onNext,
                  child: const Text('Next'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
