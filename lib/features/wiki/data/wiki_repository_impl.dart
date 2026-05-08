import '../../../core/drive/drive_repository.dart';
import '../domain/wiki_model.dart';
import 'wiki_repository.dart';

class WikiRepositoryImpl implements WikiRepository {
  final DriveRepository _drive;
  final Map<String, WikiEntry> _cache = {};

  WikiRepositoryImpl(this._drive);

  String _path(String projectId, String entryId) =>
      'projects/$projectId/wiki/$entryId.json';

  @override
  Future<List<WikiEntry>> getEntries(String projectId) async {
    try {
      final files = await _drive.listFiles('projects/$projectId/wiki');
      final result = <WikiEntry>[];
      for (final f in files) {
        if (!f.endsWith('.json')) continue;
        final id = f.replaceAll('.json', '');
        final e = await getEntry(projectId, id);
        if (e != null) result.add(e);
      }
      result.sort((a, b) => a.title.compareTo(b.title));
      return result;
    } catch (_) {
      return _cache.values
          .where((e) => e.projectId == projectId)
          .toList()
        ..sort((a, b) => a.title.compareTo(b.title));
    }
  }

  @override
  Future<WikiEntry?> getEntry(String projectId, String entryId) async {
    if (_cache.containsKey(entryId)) return _cache[entryId];
    try {
      final data =
          await _drive.readFile<Map<String, dynamic>>(_path(projectId, entryId));
      if (data == null) return null;
      final entry = WikiEntry.fromJson(data);
      _cache[entryId] = entry;
      return entry;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveEntry(WikiEntry entry) async {
    _cache[entry.id] = entry;
    await _drive.writeFile(_path(entry.projectId, entry.id), entry.toJson());
  }

  @override
  Future<void> deleteEntry(String projectId, String entryId) async {
    _cache.remove(entryId);
    await _drive.deleteFile(_path(projectId, entryId));
  }
}
