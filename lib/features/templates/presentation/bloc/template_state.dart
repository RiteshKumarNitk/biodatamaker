import 'package:equatable/equatable.dart';

import 'package:biodata_maker/features/templates/data/models/theme_config.dart';

abstract class TemplateState extends Equatable {
  const TemplateState();

  @override
  List<Object?> get props => [];
}

class TemplateInitial extends TemplateState {
  const TemplateInitial();
}

class TemplateLoading extends TemplateState {
  const TemplateLoading();
}

class TemplateLoaded extends TemplateState {
  final List<ThemeConfig> templates;
  final List<String> categories;
  final String selectedCategory;

  const TemplateLoaded({
    required this.templates,
    required this.categories,
    required this.selectedCategory,
  });

  @override
  List<Object?> get props => [templates, categories, selectedCategory];
}

class TemplateError extends TemplateState {
  final String message;

  const TemplateError(this.message);

  @override
  List<Object?> get props => [message];
}
