import '../domain/character_model.dart';

abstract class CharactersRepository {
  Future<List<CharacterModel>> getCharacters(String projectId);
  Future<CharacterModel?> getCharacter(String projectId, String charId);
  Future<void> saveCharacter(CharacterModel character);
  Future<void> deleteCharacter(String projectId, String charId);
}
