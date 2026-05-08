import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/drive/drive_service.dart';
import '../data/characters_repository.dart';
import '../data/characters_repository_impl.dart';
import 'character_model.dart';

final charactersRepositoryProvider =
    Provider.family<CharactersRepository?, String>((ref, projectId) {
  final driveAsync = ref.watch(driveRepositoryProvider);
  return driveAsync.whenOrNull(
    data: (drive) =>
        drive == null ? null : CharactersRepositoryImpl(drive),
  );
});

final charactersProvider = StateNotifierProvider.family<CharactersNotifier,
    AsyncValue<List<CharacterModel>>, String>(
  (ref, projectId) {
    final repo = ref.watch(charactersRepositoryProvider(projectId));
    return CharactersNotifier(repo, projectId);
  },
);

class CharactersNotifier
    extends StateNotifier<AsyncValue<List<CharacterModel>>> {
  final CharactersRepository? _repo;
  final String _projectId;

  CharactersNotifier(this._repo, this._projectId)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    if (_repo == null) {
      state = const AsyncValue.data([]);
      return;
    }
    try {
      final chars = await _repo.getCharacters(_projectId);
      state = AsyncValue.data(chars);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createCharacter(String name) async {
    final char = CharacterModel.create(projectId: _projectId, name: name);
    await _repo?.saveCharacter(char);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([...current, char]
      ..sort((a, b) => a.name.compareTo(b.name)));
  }

  Future<void> saveCharacter(CharacterModel character) async {
    await _repo?.saveCharacter(character);
    final current = state.valueOrNull ?? [];
    final updated = current.map((c) => c.id == character.id ? character : c).toList();
    if (!updated.any((c) => c.id == character.id)) updated.add(character);
    updated.sort((a, b) => a.name.compareTo(b.name));
    state = AsyncValue.data(updated);
  }

  Future<void> deleteCharacter(String charId) async {
    await _repo?.deleteCharacter(_projectId, charId);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(current.where((c) => c.id != charId).toList());
  }
}
