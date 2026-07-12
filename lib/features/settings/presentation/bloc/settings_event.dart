import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class UpdateThemeMode extends SettingsEvent {
  final String mode;

  const UpdateThemeMode(this.mode);

  @override
  List<Object?> get props => [mode];
}

class UpdateLanguage extends SettingsEvent {
  final String lang;

  const UpdateLanguage(this.lang);

  @override
  List<Object?> get props => [lang];
}

class UpdatePdfQuality extends SettingsEvent {
  final String quality;

  const UpdatePdfQuality(this.quality);

  @override
  List<Object?> get props => [quality];
}

class UpdatePdfPageSize extends SettingsEvent {
  final String size;

  const UpdatePdfPageSize(this.size);

  @override
  List<Object?> get props => [size];
}

class ToggleAutoSave extends SettingsEvent {
  const ToggleAutoSave();
}

class ResetSettings extends SettingsEvent {
  const ResetSettings();
}
