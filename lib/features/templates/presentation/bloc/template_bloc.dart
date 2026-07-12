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
      final templates = _repository.getAll();
      final categories = _repository.getCategories();
      if (categories.isEmpty) {
        await _repository.loadDefaultTemplates();
        final loaded = _repository.getAll();
        final cats = _repository.getCategories();
        emit(TemplateLoaded(
          templates: loaded,
          categories: cats,
          selectedCategory: cats.isNotEmpty ? cats.first : '',
        ));
      } else {
        emit(TemplateLoaded(
          templates: templates,
          categories: categories,
          selectedCategory: categories.isNotEmpty ? categories.first : '',
        ));
      }
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
      final filtered = _repository.getByCategory(event.category);
      emit(TemplateLoaded(
        templates: filtered,
        categories: current.categories,
        selectedCategory: event.category,
      ));
    }
  }
}
