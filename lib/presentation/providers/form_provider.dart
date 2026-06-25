import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:biodata_maker/presentation/providers/app_providers.dart';
import 'package:biodata_maker/data/models/biodata.dart';

const _uuid = Uuid();

/// Current step in the multi-step form (0-indexed)
final formStepProvider = StateProvider<int>((ref) => 0);

/// Total number of form steps
const int totalFormSteps = 6;

/// Step labels for the form
const List<String> formStepLabels = [
  'Personal',
  'Education',
  'Family',
  'Lifestyle',
  'Partner',
  'Photos',
];

/// Form data provider that holds the Biodata being edited/created.
/// When creating, it generates a new ID. When editing, it loads existing data.
final formDataProvider =
    StateNotifierProvider<FormDataNotifier, Biodata?>((ref) {
  return FormDataNotifier(ref);
});

class FormDataNotifier extends StateNotifier<Biodata?> {
  final Ref _ref;

  FormDataNotifier(this._ref) : super(null);

  /// Initialize a new blank biodata for creation
  void initNew() {
    state = Biodata(
      id: _uuid.v4(),
      name: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Load an existing biodata for editing
  void loadExisting(String id) {
    final hiveService = _ref.read(hiveServiceProvider);
    final existing = hiveService.getBiodata(id);
    if (existing != null) {
      state = existing;
    }
  }

  /// Update the Biodata directly (used by form steps)
  void update(Biodata updated) {
    state = updated.copyWith(updatedAt: DateTime.now());
  }

  /// Save to Hive and return the saved Biodata
  Future<Biodata?> save() async {
    if (state == null) return null;
    final hiveService = _ref.read(hiveServiceProvider);
    final saved = state!.copyWith(updatedAt: DateTime.now());
    await hiveService.saveBiodata(saved);
    state = saved;
    return saved;
  }

  /// Auto-save: saves without returning
  Future<void> autoSave() async {
    if (state == null) return;
    final hiveService = _ref.read(hiveServiceProvider);
    final saved = state!.copyWith(updatedAt: DateTime.now());
    await hiveService.saveBiodata(saved);
    state = saved;
  }

  /// Clear the form data
  void clear() {
    state = null;
  }
}
