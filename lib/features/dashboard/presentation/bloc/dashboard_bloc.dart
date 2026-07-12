import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/biodata/data/repositories/biodata_repository.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {
  const LoadDashboard();
}

class DashboardState extends Equatable {
  final bool isLoading;
  final List<Biodata> recentBiodatas;
  final List<Biodata> draftBiodatas;
  final int totalCount;
  final int favoriteCount;
  final int archivedCount;
  final int downloadCount;
  final String? error;

  const DashboardState({
    this.isLoading = true,
    this.recentBiodatas = const [],
    this.draftBiodatas = const [],
    this.totalCount = 0,
    this.favoriteCount = 0,
    this.archivedCount = 0,
    this.downloadCount = 0,
    this.error,
  });

  DashboardState copyWith({
    bool? isLoading,
    List<Biodata>? recentBiodatas,
    List<Biodata>? draftBiodatas,
    int? totalCount,
    int? favoriteCount,
    int? archivedCount,
    int? downloadCount,
    String? error,
    bool clearError = false,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      recentBiodatas: recentBiodatas ?? this.recentBiodatas,
      draftBiodatas: draftBiodatas ?? this.draftBiodatas,
      totalCount: totalCount ?? this.totalCount,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      archivedCount: archivedCount ?? this.archivedCount,
      downloadCount: downloadCount ?? this.downloadCount,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        recentBiodatas,
        draftBiodatas,
        totalCount,
        favoriteCount,
        archivedCount,
        downloadCount,
        error,
      ];
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final BiodataRepository _biodataRepo = sl<BiodataRepository>();

  DashboardBloc() : super(const DashboardState()) {
    on<LoadDashboard>(_onLoad);
  }

  Future<void> _onLoad(LoadDashboard event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final recent = _biodataRepo.getRecent(limit: 5);
      final drafts = _biodataRepo.getDrafts();
      final stats = _biodataRepo.getStats();
      final filteredDrafts = drafts.where((d) => !recent.contains(d)).take(3).toList();
      emit(state.copyWith(
        isLoading: false,
        recentBiodatas: recent,
        draftBiodatas: filteredDrafts,
        totalCount: stats['total'] ?? 0,
        favoriteCount: stats['favorites'] ?? 0,
        archivedCount: stats['archived'] ?? 0,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
