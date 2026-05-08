import '../../../core/drive/drive_repository.dart';
import '../domain/character_model.dart';
import 'characters_repository.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final DriveRepository _drive;
  final Map<String, CharacterModel> _cache = {};

  CharactersRepositoryImpl(this._drive);

  String _path(String projectId, String charId) =>
      'projects/$projectId/characters/$charId.json';

  @override
  Future<List<CharacterModel>> getCharacters(String projectId) async {
    try {
      final files = await _drive.listFiles('projects/$projectId/characters');
      final result = <CharacterModel>[];
      for (final f in files) {
        if (!f.endsWith('.json')) continue;
        final id = f.replaceAll('.json', '');
        final c = await getCharacter(projectId, id);
        if (c != null) result.add(c);
      }
      result.sort((a, b) => a.name.compareTo(b.name));
      return result;
    } catch (_) {
      return _cache.values
          .where((c) => c.projectId == projectId)
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    }
  }

  @override
  Future<CharacterModel?> getCharacter(
      String projectId, String charId) async {
    if (_cache.containsKey(charId)) return _cache[charId];
    try {
      final data = await _drive
          .readFile<Map<String, dynamic>>(_path(projectId, charId));
      if (data == null) return null;
      final c = CharacterModel.fromJson(data);
      _cache[charId] = c;
      return c;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveCharacter(CharacterModel character) async {
    _cache[character.id] = character;
    await _drive.writeFile(
        _path(character.projectId, character.id), character.toJson());
  }

  @override
  Future<void> deleteCharacter(String projectId, String charId) async {
    _cache.remove(charId);
    await _drive.deleteFile(_path(projectId, charId));
  }
}
