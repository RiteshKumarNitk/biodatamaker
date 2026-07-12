import 'package:bloc/bloc.dart';

import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/settings/data/models/user_settings.dart';
import 'package:biodata_maker/features/settings/data/repositories/settings_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;

  SettingsBloc({SettingsRepository? repository})
      : _repository = repository ?? sl<SettingsRepository>(),
        super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateThemeMode>(_onUpdateThemeMode);
    on<UpdateLanguage>(_onUpdateLanguage);
    on<UpdatePdfQuality>(_onUpdatePdfQuality);
    on<UpdatePdfPageSize>(_onUpdatePdfPageSize);
    on<ToggleAutoSave>(_onToggleAutoSave);
    on<ResetSettings>(_onResetSettings);
  }

  void _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) {
    final settings = _repository.getSettings();
    emit(SettingsLoaded(settings: settings));
  }

  Future<void> _onUpdateThemeMode(
    UpdateThemeMode event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsSaving());
    await _repository.updateSettings(
      _repository.getSettings().copyWith(themeMode: event.mode),
    );
    final settings = _repository.getSettings();
    emit(SettingsLoaded(settings: settings));
  }

  Future<void> _onUpdateLanguage(
    UpdateLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsSaving());
    await _repository.updateSettings(
      _repository.getSettings().copyWith(language: event.lang),
    );
    final settings = _repository.getSettings();
    emit(SettingsLoaded(settings: settings));
  }

  Future<void> _onUpdatePdfQuality(
    UpdatePdfQuality event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsSaving());
    await _repository.updateSettings(
      _repository.getSettings().copyWith(pdfQuality: event.quality),
    );
    final settings = _repository.getSettings();
    emit(SettingsLoaded(settings: settings));
  }

  Future<void> _onUpdatePdfPageSize(
    UpdatePdfPageSize event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsSaving());
    await _repository.updateSettings(
      _repository.getSettings().copyWith(pdfPageSize: event.size),
    );
    final settings = _repository.getSettings();
    emit(SettingsLoaded(settings: settings));
  }

  Future<void> _onToggleAutoSave(
    ToggleAutoSave event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsSaving());
    final current = _repository.getSettings();
    await _repository.updateSettings(
      current.copyWith(autoSave: !current.autoSave),
    );
    final settings = _repository.getSettings();
    emit(SettingsLoaded(settings: settings));
  }

  Future<void> _onResetSettings(
    ResetSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsSaving());
    final defaultSettings = UserSettings(id: 'default_settings');
    await _repository.updateSettings(defaultSettings);
    emit(SettingsLoaded(settings: defaultSettings));
  }
}
