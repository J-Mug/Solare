import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/drive/drive_service.dart';
import '../data/wiki_repository.dart';
import '../data/wiki_repository_impl.dart';
import 'wiki_model.dart';

final wikiRepositoryProvider =
    Provider.family<WikiRepository?, String>((ref, projectId) {
  final driveAsync = ref.watch(driveRepositoryProvider);
  return driveAsync.whenOrNull(
    data: (drive) => drive == null ? null : WikiRepositoryImpl(drive),
  );
});

final wikiProvider =
    StateNotifierProvider.family<WikiNotifier, AsyncValue<List<WikiEntry>>, String>(
  (ref, projectId) {
    final repo = ref.watch(wikiRepositoryProvider(projectId));
    return WikiNotifier(repo, projectId);
  },
);

class WikiNotifier extends StateNotifier<AsyncValue<List<WikiEntry>>> {
  final WikiRepository? _repo;
  final String _projectId;

  WikiNotifier(this._repo, this._projectId)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    if (_repo == null) {
      state = const AsyncValue.data([]);
      return;
    }
    try {
      state = AsyncValue.data(await _repo.getEntries(_projectId));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createEntry(String title, {String category = 'other'}) async {
    final entry =
        WikiEntry.create(projectId: _projectId, title: title, category: category);
    await _repo?.saveEntry(entry);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([...current, entry]
      ..sort((a, b) => a.title.compareTo(b.title)));
  }

  Future<void> saveEntry(WikiEntry entry) async {
    await _repo?.saveEntry(entry);
    final current = state.valueOrNull ?? [];
    final updated =
        current.map((e) => e.id == entry.id ? entry : e).toList();
    if (!updated.any((e) => e.id == entry.id)) updated.add(entry);
    updated.sort((a, b) => a.title.compareTo(b.title));
    state = AsyncValue.data(updated);
  }

  Future<void> deleteEntry(String entryId) async {
    await _repo?.deleteEntry(_projectId, entryId);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(current.where((e) => e.id != entryId).toList());
  }
}
