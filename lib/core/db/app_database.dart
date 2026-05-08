import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

class Pages extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get contentJson => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class BranchNodes extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text()();
  TextColumn get type => text()(); // 'event' | 'choice' | 'condition' | 'result'
  TextColumn get label => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get positionJson => text()(); // {"x": 0.0, "y": 0.0}
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();
  TextColumn get connectedPageId => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class BranchEdges extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text()();
  TextColumn get fromId => text()();
  TextColumn get toId => text()();
  TextColumn get condition => text().nullable()();
  TextColumn get label => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Queued Drive writes. Processed in order when connectivity is restored.
class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get operation => text()(); // 'create' | 'update' | 'delete'
  TextColumn get resourceType => text()(); // 'page' | 'branch_tree' | etc.
  TextColumn get resourceId => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

@DriftDatabase(tables: [Pages, BranchNodes, BranchEdges, SyncQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  static QueryExecutor _open() => driftDatabase(name: 'solare');

  @override
  int get schemaVersion => 1;

  // ---- Pages ---------------------------------------------------------------

  Future<List<PageData>> getPagesForProject(
    String projectId, {
    String? parentId,
  }) {
    final query = select(pages)
      ..where((p) =>
          p.projectId.equals(projectId) &
          (parentId == null
              ? p.parentId.isNull()
              : p.parentId.equals(parentId)));
    return query.get();
  }

  Future<PageData?> getPage(String pageId) =>
      (select(pages)..where((p) => p.id.equals(pageId))).getSingleOrNull();

  Future<void> upsertPage(PagesCompanion page) =>
      into(pages).insertOnConflictUpdate(page);

  Future<void> deletePage(String pageId) =>
      (delete(pages)..where((p) => p.id.equals(pageId))).go();

  // ---- BranchNodes ---------------------------------------------------------

  Future<List<BranchNodeData>> getNodesForProject(String projectId) =>
      (select(branchNodes)
            ..where((n) => n.projectId.equals(projectId)))
          .get();

  Future<void> upsertNode(BranchNodesCompanion node) =>
      into(branchNodes).insertOnConflictUpdate(node);

  Future<void> deleteNode(String nodeId) =>
      (delete(branchNodes)..where((n) => n.id.equals(nodeId))).go();

  Future<void> deleteNodesForProject(String projectId) =>
      (delete(branchNodes)
            ..where((n) => n.projectId.equals(projectId)))
          .go();

  // ---- BranchEdges ---------------------------------------------------------

  Future<List<BranchEdgeData>> getEdgesForProject(String projectId) =>
      (select(branchEdges)
            ..where((e) => e.projectId.equals(projectId)))
          .get();

  Future<void> upsertEdge(BranchEdgesCompanion edge) =>
      into(branchEdges).insertOnConflictUpdate(edge);

  Future<void> deleteEdgesForProject(String projectId) =>
      (delete(branchEdges)
            ..where((e) => e.projectId.equals(projectId)))
          .go();

  // ---- SyncQueue -----------------------------------------------------------

  Future<List<SyncQueueData>> getPendingItems() =>
      (select(syncQueue)..orderBy([(q) => OrderingTerm.asc(q.createdAt)])).get();

  Future<void> enqueue(SyncQueueCompanion item) =>
      into(syncQueue).insert(item);

  Future<void> dequeue(String itemId) =>
      (delete(syncQueue)..where((q) => q.id.equals(itemId))).go();

  Future<void> clearQueue() => delete(syncQueue).go();
}
