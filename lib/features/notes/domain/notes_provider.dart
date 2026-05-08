import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/drive/drive_service.dart';
import '../../../core/firebase/project_sync_provider.dart';
import '../../../core/sync/sync_event.dart';
import '../data/notes_repository.dart';
import '../data/notes_repository_impl.dart';
import 'page_model.dart';

// --- Repository Provider ---

final notesRepositoryProvider = Provider<NotesRepository?>((ref) {
  return ref.watch(driveRepositoryProvider).whenOrNull(
        data: (drive) =>
            drive != null ? NotesRepositoryImpl(drive) : null,
      );
});

// --- Read Providers ---

/// Pages at a given level: (projectId, parentId).
/// parentId = null means root-level pages.
final pagesProvider = FutureProvider.autoDispose
    .family<List<PageModel>, (String, String?)>((ref, args) async {
  final (projectId, parentId) = args;
  final repo = ref.watch(notesRepositoryProvider);
  if (repo == null) return [];
  return repo.getPages(projectId, parentId: parentId);
});

/// Single page content.
final pageProvider = FutureProvider.autoDispose
    .family<PageModel?, (String, String)>((ref, args) async {
  final (projectId, pageId) = args;
  final repo = ref.watch(notesRepositoryProvider);
  if (repo == null) return null;
  return repo.getPage(projectId, pageId);
});

// --- Mutation Controller ---

class NotesController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  StreamSubscription<SyncEvent>? _syncSub;

  NotesController(this._ref) : super(const AsyncData(null)) {
    _syncSub = incomingSyncEvents
        .where((e) => e.resourceType == 'page')
        .listen(_applyIncomingDelta);
  }

  void _applyIncomingDelta(SyncEvent event) {
    final repo = _ref.read(notesRepositoryProvider);
    if (repo is NotesRepositoryImpl) {
      final page = PageModel.fromJson(event.payload);
      repo.applyDelta(page);
    }
    _ref.invalidate(pageProvider((event.projectId, event.resourceId)));
    _ref.invalidate(pagesProvider((event.projectId, null)));
  }

  @override
  void dispose() {
    _syncSub?.cancel();
    super.dispose();
  }

  NotesRepository? get _repo => _ref.read(notesRepositoryProvider);

  Future<PageModel?> createPage(
    String projectId, {
    String? parentId,
    String title = '제목 없음',
  }) async {
    final repo = _repo;
    if (repo == null) return null;

    final page = PageModel.create(
      projectId: projectId,
      parentId: parentId,
      title: title,
    );
    await repo.savePage(page);
    // Invalidate the list so the UI refreshes
    _ref.invalidate(pagesProvider((projectId, parentId)));
    return page;
  }

  Future<void> savePage(PageModel page) async {
    final repo = _repo;
    if (repo == null) return;
    await repo.savePage(page);
    _ref.invalidate(pageProvider((page.projectId, page.id)));
    _ref.invalidate(pagesProvider((page.projectId, page.parentId)));

    // Push delta to Firebase if in a collaborative project
    final sync = _ref.read(activeProjectSyncProvider);
    if (sync != null) {
      await sync.pushDelta(
        resourceType: 'page',
        resourceId: page.id,
        operation: 'update',
        payload: page.toJson(),
      );
      // Drive write is immediate, so clear relay entries right away
      await sync.clearMyDeltas();
    }
  }

  Future<void> deletePage(
    String projectId,
    String pageId, {
    String? parentId,
  }) async {
    final repo = _repo;
    if (repo == null) return;
    await repo.deletePage(projectId, pageId);
    _ref.invalidate(pagesProvider((projectId, parentId)));

    final sync = _ref.read(activeProjectSyncProvider);
    if (sync != null) {
      await sync.pushDelta(
        resourceType: 'page',
        resourceId: pageId,
        operation: 'delete',
        payload: {'projectId': projectId, 'pageId': pageId},
      );
      await sync.clearMyDeltas();
    }
  }

  Future<void> renamePage(PageModel page, String newTitle) async {
    await savePage(page.copyWith(title: newTitle));
  }
}

final notesControllerProvider =
    StateNotifierProvider<NotesController, AsyncValue<void>>(
  (ref) => NotesController(ref),
);
