import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/biodata/data/repositories/biodata_repository.dart';

class BiodataFormState extends Equatable {
  final Biodata? biodata;
  final int currentStep;
  final bool isSaving;
  final bool isSaved;
  final String? error;

  static const int totalSteps = 8;

  const BiodataFormState({
    this.biodata,
    this.currentStep = 0,
    this.isSaving = false,
    this.isSaved = false,
    this.error,
  });

  BiodataFormState copyWith({
    Biodata? biodata,
    int? currentStep,
    bool? isSaving,
    bool? isSaved,
    String? error,
    bool clearError = false,
  }) {
    return BiodataFormState(
      biodata: biodata ?? this.biodata,
      currentStep: currentStep ?? this.currentStep,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [biodata, currentStep, isSaving, isSaved, error];
}

abstract class BiodataFormEvent extends Equatable {
  const BiodataFormEvent();

  @override
  List<Object?> get props => [];
}

class InitNewForm extends BiodataFormEvent {
  final String? templateId;
  const InitNewForm({this.templateId});

  @override
  List<Object?> get props => [templateId];
}

class InitEditForm extends BiodataFormEvent {
  final String biodataId;
  const InitEditForm(this.biodataId);

  @override
  List<Object?> get props => [biodataId];
}

class UpdateBiodata extends BiodataFormEvent {
  final Biodata biodata;
  const UpdateBiodata(this.biodata);

  @override
  List<Object?> get props => [biodata];
}

class NextStep extends BiodataFormEvent {
  const NextStep();
}

class PrevStep extends BiodataFormEvent {
  const PrevStep();
}

class GoToStep extends BiodataFormEvent {
  final int step;
  const GoToStep(this.step);

  @override
  List<Object?> get props => [step];
}

class SaveForm extends BiodataFormEvent {
  const SaveForm();
}

class AutoSaveForm extends BiodataFormEvent {
  const AutoSaveForm();
}

class ClearForm extends BiodataFormEvent {
  const ClearForm();
}

class BiodataFormBloc extends Bloc<BiodataFormEvent, BiodataFormState> {
  final BiodataRepository _repo;
  final Uuid _uuid;

  BiodataFormBloc({BiodataRepository? repo, Uuid? uuid})
      : _repo = repo ?? sl<BiodataRepository>(),
        _uuid = uuid ?? const Uuid(),
        super(const BiodataFormState()) {
    on<InitNewForm>(_onInitNew);
    on<InitEditForm>(_onInitEdit);
    on<UpdateBiodata>(_onUpdate);
    on<NextStep>(_onNextStep);
    on<PrevStep>(_onPrevStep);
    on<GoToStep>(_onGoToStep);
    on<SaveForm>(_onSave);
    on<AutoSaveForm>(_onAutoSave);
    on<ClearForm>(_onClear);
  }

  void _onInitNew(InitNewForm event, Emitter<BiodataFormState> emit) {
    final now = DateTime.now();
    final biodata = Biodata(
      id: _uuid.v4(),
      name: '',
      fullName: '',
      createdAt: now,
      updatedAt: now,
      templateId: event.templateId ?? '',
      isFavorite: false,
      isArchived: false,
      isDraft: true,
      downloadCount: 0,
    );
    emit(state.copyWith(
      biodata: biodata,
      currentStep: 0,
      isSaved: false,
      clearError: true,
    ));
  }

  void _onInitEdit(InitEditForm event, Emitter<BiodataFormState> emit) {
    try {
      final biodata = _repo.getById(event.biodataId);
      if (biodata == null) {
        emit(state.copyWith(error: 'Biodata not found'));
        return;
      }
      emit(state.copyWith(
        biodata: biodata,
        currentStep: 0,
        isSaved: false,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onUpdate(UpdateBiodata event, Emitter<BiodataFormState> emit) {
    emit(state.copyWith(
      biodata: event.biodata.copyWith(updatedAt: DateTime.now()),
      clearError: true,
    ));
  }

  void _onNextStep(NextStep event, Emitter<BiodataFormState> emit) {
    if (state.currentStep < BiodataFormState.totalSteps - 1) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void _onPrevStep(PrevStep event, Emitter<BiodataFormState> emit) {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  /// Steps cannot be jumped to beyond the first invalid step: the stepper
  /// stays free to navigate backwards or within completed territory, but a
  /// user cannot skip Personal (name required) or hop from step 1 to the
  /// Download step with an empty form.
  int maxReachableStep(Biodata? biodata) {
    if (biodata == null) return 0;
    if (biodata.fullName.trim().isEmpty) return 0;
    return BiodataFormState.totalSteps - 1;
  }

  void _onGoToStep(GoToStep event, Emitter<BiodataFormState> emit) {
    if (event.step >= 0 && event.step < BiodataFormState.totalSteps) {
      if (event.step > maxReachableStep(state.biodata)) {
        emit(state.copyWith(
          error: 'Please enter your full name to continue',
        ));
        return;
      }
      emit(state.copyWith(currentStep: event.step));
    }
  }

  Future<void> _onSave(SaveForm event, Emitter<BiodataFormState> emit) async {
    if (state.biodata == null) return;
    emit(state.copyWith(isSaving: true, clearError: true));
    try {
      final biodata = state.biodata!.copyWith(
        isDraft: false,
        updatedAt: DateTime.now(),
      );
      await _repo.save(biodata); // stamps the owning userId inside the repo
      emit(state.copyWith(
        biodata: biodata,
        isSaving: false,
        isSaved: true,
      ));
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Timer? _autoSaveTimer;

  @override
  Future<void> close() {
    _autoSaveTimer?.cancel();
    return super.close();
  }

  Future<void> _onAutoSave(AutoSaveForm event, Emitter<BiodataFormState> emit) async {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(milliseconds: 500), () async {
      if (state.biodata == null) return;
      try {
        final biodata = state.biodata!.copyWith(updatedAt: DateTime.now());
        await _repo.save(biodata);
      } catch (e) {
        debugPrint('Autosave failed: $e');
      }
    });
  }

  void _onClear(ClearForm event, Emitter<BiodataFormState> emit) {
    emit(const BiodataFormState());
  }
}
