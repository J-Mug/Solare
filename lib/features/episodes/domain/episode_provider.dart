import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/drive/drive_service.dart';
import '../data/episode_repository.dart';
import '../data/episode_repository_impl.dart';
import 'episode_model.dart';

final episodeRepositoryProvider =
    Provider.family<EpisodeRepository?, String>((ref, projectId) {
  final driveAsync = ref.watch(driveRepositoryProvider);
  return driveAsync.whenOrNull(
    data: (drive) =>
        drive == null ? null : EpisodeRepositoryImpl(drive),
  );
});

final episodesProvider = StateNotifierProvider.family<EpisodesNotifier,
    AsyncValue<List<EpisodeModel>>, String>(
  (ref, projectId) {
    final repo = ref.watch(episodeRepositoryProvider(projectId));
    return EpisodesNotifier(repo, projectId);
  },
);

class EpisodesNotifier
    extends StateNotifier<AsyncValue<List<EpisodeModel>>> {
  final EpisodeRepository? _repo;
  final String _projectId;

  EpisodesNotifier(this._repo, this._projectId)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    if (_repo == null) {
      state = const AsyncValue.data([]);
      return;
    }
    try {
      state = AsyncValue.data(await _repo.getEpisodes(_projectId));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createEpisode(String title, {int chapterNumber = 0}) async {
    final ep = EpisodeModel.create(
        projectId: _projectId, title: title, chapterNumber: chapterNumber);
    await _repo?.saveEpisode(ep);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([...current, ep]
      ..sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber)));
  }

  Future<void> saveEpisode(EpisodeModel episode) async {
    await _repo?.saveEpisode(episode);
    final current = state.valueOrNull ?? [];
    final updated =
        current.map((e) => e.id == episode.id ? episode : e).toList();
    if (!updated.any((e) => e.id == episode.id)) updated.add(episode);
    updated.sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
    state = AsyncValue.data(updated);
  }

  Future<void> deleteEpisode(String episodeId) async {
    await _repo?.deleteEpisode(_projectId, episodeId);
    final current = state.valueOrNull ?? [];
    state =
        AsyncValue.data(current.where((e) => e.id != episodeId).toList());
  }
}
