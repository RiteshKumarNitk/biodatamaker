import 'package:biodata_maker/core/services/hive_service.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/auth/data/repositories/auth_repository.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';

/// Repository over the biodata box, scoped to the currently signed-in user.
///
/// Every read filters by the active user's id; every write stamps the id.
/// Biodatas saved with an empty [Biodata.userId] (legacy rows from before
/// multi-user support, and the shared sample) are treated as visible to
/// everyone so existing installs never lose data after an upgrade.
class BiodataRepository {
  final HiveService _hiveService;

  BiodataRepository({HiveService? hiveService})
      : _hiveService = hiveService ?? sl<HiveService>();

  /// Resolves the active user id on every call — cheap (Hive + a small box)
  /// and immune to stale scope after sign-in/sign-out.
  Future<String> _userId() async {
    try {
      final user = await sl<AuthRepository>().getCurrentUser();
      return user?.id ?? '';
    } catch (_) {
      return '';
    }
  }

  bool _ownedByCurrentUser(Biodata b, String uid) =>
      b.userId.isEmpty || b.userId == uid;

  Future<void> save(Biodata biodata) async {
    final uid = await _userId();
    await _hiveService.saveBiodata(
      // Never clear an already-stamped owner; fill it in when empty.
      biodata.userId.isNotEmpty
          ? biodata
          : biodata.copyWith(userId: uid.isEmpty ? biodata.userId : uid),
    );
  }

  Biodata? getById(String id) {
    // Single-row read: ownership is enforced by the caller's navigation
    // (lists are already scoped), and legacy rows are shared by design.
    return _hiveService.getBiodata(id);
  }

  List<Biodata> getAll() => _hiveService.getAllBiodata();

  /// All biodatas owned by the current user (or legacy unowned rows).
  Future<List<Biodata>> getAllScoped() async {
    final uid = await _userId();
    return _hiveService
        .getAllBiodata()
        .where((b) => _ownedByCurrentUser(b, uid))
        .toList();
  }

  Future<List<Biodata>> getActive() async {
    final list = (await getAllScoped()).where((b) => !b.isArchived).toList();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  Future<List<Biodata>> getDrafts() async =>
      (await getAllScoped()).where((b) => b.isDraft).toList();

  Future<List<Biodata>> getCompleted() async => (await getAllScoped())
      .where((b) => !b.isDraft && !b.isArchived)
      .toList();

  Future<List<Biodata>> getFavorites() async => (await getAllScoped())
      .where((b) => b.isFavorite && !b.isArchived)
      .toList();

  Future<List<Biodata>> getArchived() async =>
      (await getAllScoped()).where((b) => b.isArchived).toList();

  Future<List<Biodata>> search(String query) async {
    final scoped = await getAllScoped();
    if (query.isEmpty) return scoped;
    final lower = query.toLowerCase();
    return scoped.where((b) {
      return b.fullName.toLowerCase().contains(lower) ||
          b.occupation.toLowerCase().contains(lower) ||
          b.city.toLowerCase().contains(lower) ||
          b.religion.toLowerCase().contains(lower) ||
          b.caste.toLowerCase().contains(lower);
    }).toList();
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
    final uid = await _userId();
    final original = _hiveService.getBiodata(id);
    if (original == null) return;
    final duplicate = original.copyWith(
      id: '${original.id}_copy_${DateTime.now().millisecondsSinceEpoch}',
      name: '${original.name} (Copy)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDraft: true,
      isFavorite: false,
      isArchived: false,
      downloadCount: 0,
      userId: uid,
    );
    await _hiveService.saveBiodata(duplicate);
  }

  Future<void> incrementDownloadCount(String id) async {
    final biodata = _hiveService.getBiodata(id);
    if (biodata == null) return;
    final updated = biodata.copyWith(
      downloadCount: biodata.downloadCount + 1,
    );
    await _hiveService.saveBiodata(updated);
  }

  Future<Map<String, int>> getStats() async {
    final scoped = await getAllScoped();
    return {
      'total': scoped.length,
      'favorites': scoped.where((b) => b.isFavorite).length,
      'archived': scoped.where((b) => b.isArchived).length,
    };
  }

  Future<List<Biodata>> getRecent({int limit = 5}) async {
    final list = (await getAllScoped()).where((b) => !b.isArchived).toList();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list.take(limit).toList();
  }
}
