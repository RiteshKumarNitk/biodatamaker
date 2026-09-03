import 'package:bloc/bloc.dart';

import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/templates/data/repositories/template_repository.dart';
import 'template_event.dart';
import 'template_state.dart';

class TemplateBloc extends Bloc<TemplateEvent, TemplateState> {
  final TemplateRepository _repository;

  TemplateBloc({TemplateRepository? repository})
      : _repository = repository ?? sl<TemplateRepository>(),
        super(TemplateInitial()) {
    on<LoadTemplates>(_onLoadTemplates);
    on<FilterByCategory>(_onFilterByCategory);
  }

  Future<void> _onLoadTemplates(
    LoadTemplates event,
    Emitter<TemplateState> emit,
  ) async {
    emit(TemplateLoading());
    try {
      var templates = _repository.getAll();
      if (templates.isEmpty) {
        await _repository.loadDefaultTemplates();
        templates = _repository.getAll();
      }
      final rawCategories = _repository.getCategories();
      final categories = ['All', ...rawCategories.where((c) => c != 'All')];

      emit(TemplateLoaded(
        templates: templates,
        categories: categories,
        selectedCategory: 'All',
      ));
    } catch (e) {
      emit(TemplateError(e.toString()));
    }
  }

  void _onFilterByCategory(
    FilterByCategory event,
    Emitter<TemplateState> emit,
  ) {
    if (state is TemplateLoaded) {
      final current = state as TemplateLoaded;
      final filtered = event.category == 'All'
          ? _repository.getAll()
          : _repository.getByCategory(event.category);
      emit(TemplateLoaded(
        templates: filtered,
        categories: current.categories,
        selectedCategory: event.category,
      ));
    }
  }
}
