import '../domain/wiki_model.dart';

abstract class WikiRepository {
  Future<List<WikiEntry>> getEntries(String projectId);
  Future<WikiEntry?> getEntry(String projectId, String entryId);
  Future<void> saveEntry(WikiEntry entry);
  Future<void> deleteEntry(String projectId, String entryId);
}
