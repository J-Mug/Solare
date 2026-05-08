import '../../../core/drive/drive_repository.dart';
import '../domain/episode_model.dart';
import 'episode_repository.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  final DriveRepository _drive;
  final Map<String, EpisodeModel> _cache = {};

  EpisodeRepositoryImpl(this._drive);

  String _path(String projectId, String episodeId) =>
      'projects/$projectId/episodes/$episodeId.json';

  @override
  Future<List<EpisodeModel>> getEpisodes(String projectId) async {
    try {
      final files =
          await _drive.listFiles('projects/$projectId/episodes');
      final result = <EpisodeModel>[];
      for (final f in files) {
        if (!f.endsWith('.json')) continue;
        final id = f.replaceAll('.json', '');
        final e = await getEpisode(projectId, id);
        if (e != null) result.add(e);
      }
      result.sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
      return result;
    } catch (_) {
      return _cache.values
          .where((e) => e.projectId == projectId)
          .toList()
        ..sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
    }
  }

  @override
  Future<EpisodeModel?> getEpisode(
      String projectId, String episodeId) async {
    if (_cache.containsKey(episodeId)) return _cache[episodeId];
    try {
      final data = await _drive
          .readFile<Map<String, dynamic>>(_path(projectId, episodeId));
      if (data == null) return null;
      final ep = EpisodeModel.fromJson(data);
      _cache[episodeId] = ep;
      return ep;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveEpisode(EpisodeModel episode) async {
    _cache[episode.id] = episode;
    await _drive.writeFile(
        _path(episode.projectId, episode.id), episode.toJson());
  }

  @override
  Future<void> deleteEpisode(String projectId, String episodeId) async {
    _cache.remove(episodeId);
    await _drive.deleteFile(_path(projectId, episodeId));
  }
}
