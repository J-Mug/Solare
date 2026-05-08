import '../domain/episode_model.dart';

abstract class EpisodeRepository {
  Future<List<EpisodeModel>> getEpisodes(String projectId);
  Future<EpisodeModel?> getEpisode(String projectId, String episodeId);
  Future<void> saveEpisode(EpisodeModel episode);
  Future<void> deleteEpisode(String projectId, String episodeId);
}
