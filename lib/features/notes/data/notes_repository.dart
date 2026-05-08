import '../domain/page_model.dart';

abstract class NotesRepository {
  Future<List<PageModel>> getPages(String projectId, {String? parentId});
  Future<PageModel?> getPage(String projectId, String pageId);
  Future<void> savePage(PageModel page);
  Future<void> deletePage(String projectId, String pageId);
}
