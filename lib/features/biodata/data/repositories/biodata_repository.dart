import 'package:biodata_maker/core/services/hive_service.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';

class BiodataRepository {
  final HiveService _hiveService;

  BiodataRepository({HiveService? hiveService})
      : _hiveService = hiveService ?? sl<HiveService>();

  Future<void> save(Biodata biodata) async {
    await _hiveService.saveBiodata(biodata);
  }

  Biodata? getById(String id) {
    return _hiveService.getBiodata(id);
  }

  List<Biodata> getAll() {
    return _hiveService.getAllBiodata();
  }

  List<Biodata> getActive() {
    final list =
        _hiveService.getAllBiodata().where((b) => !b.isArchived).toList();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  List<Biodata> getDrafts() {
    return _hiveService.getAllBiodata().where((b) => b.isDraft).toList();
  }

  List<Biodata> getCompleted() {
    return _hiveService
        .getAllBiodata()
        .where((b) => !b.isDraft && !b.isArchived)
        .toList();
  }

  List<Biodata> getFavorites() {
    return _hiveService.getFavoriteBiodata();
  }

  List<Biodata> getArchived() {
    return _hiveService.getArchivedBiodata();
  }

  List<Biodata> search(String query) {
    return _hiveService.searchBiodata(query);
  }

  Future<void> delete(String id) async {
    await _hiveService.deleteBiodata(id);
  }

  Future<void> toggleFavorite(String id) async {
    await _hiveService.toggleFavorite(id);
  }

  Future<void> toggleArchive(String id) async {
    await _hiveService.toggleArchive(id);
  }

  Future<void> duplicate(String id) async {
    await _hiveService.duplicateBiodata(id);
  }

  Future<void> incrementDownloadCount(String id) async {
    final biodata = _hiveService.getBiodata(id);
    if (biodata == null) return;
    final updated = biodata.copyWith(
      downloadCount: biodata.downloadCount + 1,
    );
    await _hiveService.saveBiodata(updated);
  }

  Map<String, int> getStats() {
    return {
      'total': _hiveService.totalBiodatas(),
      'favorites': _hiveService.totalFavorites(),
      'archived': _hiveService.totalArchived(),
    };
  }

  List<Biodata> getRecent({int limit = 5}) {
    final list =
        _hiveService.getAllBiodata().where((b) => !b.isArchived).toList();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list.take(limit).toList();
  }
}
