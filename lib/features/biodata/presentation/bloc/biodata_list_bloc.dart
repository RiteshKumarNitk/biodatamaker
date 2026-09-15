import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/biodata/data/repositories/biodata_repository.dart';

class BiodataListState extends Equatable {
  final bool isLoading;
  final List<Biodata> biodatas;
  final String? error;
  final String filter;
  final String searchQuery;

  const BiodataListState({
    this.isLoading = false,
    this.biodatas = const [],
    this.error,
    this.filter = 'all',
    this.searchQuery = '',
  });

  BiodataListState copyWith({
    bool? isLoading,
    List<Biodata>? biodatas,
    String? error,
    String? filter,
    String? searchQuery,
    bool clearError = false,
  }) {
    return BiodataListState(
      isLoading: isLoading ?? this.isLoading,
      biodatas: biodatas ?? this.biodatas,
      error: clearError ? null : error ?? this.error,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [isLoading, biodatas, error, filter, searchQuery];
}

abstract class BiodataListEvent extends Equatable {
  const BiodataListEvent();

  @override
  List<Object?> get props => [];
}

class LoadBiodatas extends BiodataListEvent {
  const LoadBiodatas();
}

class SetFilter extends BiodataListEvent {
  final String filter;
  const SetFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SearchBiodatas extends BiodataListEvent {
  final String query;
  const SearchBiodatas(this.query);

  @override
  List<Object?> get props => [query];
}

class DeleteBiodata extends BiodataListEvent {
  final String id;
  const DeleteBiodata(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleFavorite extends BiodataListEvent {
  final String id;
  const ToggleFavorite(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleArchive extends BiodataListEvent {
  final String id;
  const ToggleArchive(this.id);

  @override
  List<Object?> get props => [id];
}

class DuplicateBiodata extends BiodataListEvent {
  final String id;
  const DuplicateBiodata(this.id);

  @override
  List<Object?> get props => [id];
}

class BiodataListBloc extends Bloc<BiodataListEvent, BiodataListState> {
  final BiodataRepository _repo;

  BiodataListBloc({BiodataRepository? repo})
      : _repo = repo ?? sl<BiodataRepository>(),
        super(const BiodataListState()) {
    on<LoadBiodatas>(_onLoad);
    on<SetFilter>(_onSetFilter);
    on<SearchBiodatas>(_onSearch);
    on<DeleteBiodata>(_onDelete);
    on<ToggleFavorite>(_onToggleFavorite);
    on<ToggleArchive>(_onToggleArchive);
    on<DuplicateBiodata>(_onDuplicate);
  }

  Future<List<Biodata>> _filterBiodatas(String filter, String query) async {
    List<Biodata> result;
    switch (filter) {
      case 'drafts':
        result = await _repo.getDrafts();
        break;
      case 'completed':
        result = await _repo.getCompleted();
        break;
      case 'favorites':
        result = await _repo.getFavorites();
        break;
      case 'archived':
        result = await _repo.getArchived();
        break;
      default:
        result = await _repo.getActive();
        break;
    }
    if (query.isNotEmpty) {
      final lower = query.toLowerCase();
      result = result.where((b) =>
          b.fullName.toLowerCase().contains(lower) ||
          b.occupation.toLowerCase().contains(lower) ||
          b.city.toLowerCase().contains(lower)).toList();
    }
    return result;
  }

  Future<void> _onLoad(LoadBiodatas event, Emitter<BiodataListState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final biodatas = await _filterBiodatas(state.filter, state.searchQuery);
      emit(state.copyWith(isLoading: false, biodatas: biodatas));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onSetFilter(SetFilter event, Emitter<BiodataListState> emit) {
    emit(state.copyWith(filter: event.filter, searchQuery: '', clearError: true));
    add(const LoadBiodatas());
  }

  void _onSearch(SearchBiodatas event, Emitter<BiodataListState> emit) {
    emit(state.copyWith(searchQuery: event.query, clearError: true));
    add(const LoadBiodatas());
  }

  Future<void> _onDelete(DeleteBiodata event, Emitter<BiodataListState> emit) async {
    try {
      await _repo.delete(event.id);
      add(const LoadBiodatas());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<BiodataListState> emit) async {
    try {
      await _repo.toggleFavorite(event.id);
      add(const LoadBiodatas());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onToggleArchive(ToggleArchive event, Emitter<BiodataListState> emit) async {
    try {
      await _repo.toggleArchive(event.id);
      add(const LoadBiodatas());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDuplicate(DuplicateBiodata event, Emitter<BiodataListState> emit) async {
    try {
      await _repo.duplicate(event.id);
      add(const LoadBiodatas());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
