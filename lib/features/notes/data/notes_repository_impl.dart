import '../../../core/drive/drive_repository.dart';
import '../domain/page_model.dart';
import 'notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  final DriveRepository _drive;
  // In-memory cache to avoid redundant Drive reads
  final Map<String, PageModel> _cache = {};

  NotesRepositoryImpl(this._drive);

  String _pagePath(String projectId, String pageId) =>
      'projects/$projectId/notes/$pageId.json';

  @override
  Future<List<PageModel>> getPages(String projectId,
      {String? parentId}) async {
    try {
      final fileNames =
          await _drive.listFiles('projects/$projectId/notes');
      final pages = <PageModel>[];

      for (final fileName in fileNames) {
        if (!fileName.endsWith('.json')) continue;
        final pageId = fileName.replaceAll('.json', '');
        final page = await getPage(projectId, pageId);
        if (page != null && page.parentId == parentId) {
          pages.add(page);
        }
      }

      pages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return pages;
    } catch (_) {
      // Offline fallback: return cached pages
      return _cache.values
          .where((p) =>
              p.projectId == projectId && p.parentId == parentId)
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
  }

  @override
  Future<PageModel?> getPage(String projectId, String pageId) async {
    if (_cache.containsKey(pageId)) return _cache[pageId];

    try {
      final data = await _drive.readFile<Map<String, dynamic>>(
        _pagePath(projectId, pageId),
      );
      if (data == null) return null;
      final page = PageModel.fromJson(data);
      _cache[pageId] = page;
      return page;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> savePage(PageModel page) async {
    _cache[page.id] = page;
    await _drive.writeFile(
      _pagePath(page.projectId, page.id),
      page.toJson(),
    );
  }

  @override
  Future<void> deletePage(String projectId, String pageId) async {
    _cache.remove(pageId);
    await _drive.deleteFile(_pagePath(projectId, pageId));
  }

  /// Applies an incoming sync delta directly to the in-memory cache.
  /// The caller must still invalidate the relevant Riverpod provider.
  void applyDelta(PageModel page) {
    _cache[page.id] = page;
  }
}
