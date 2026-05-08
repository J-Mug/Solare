import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_sync.dart';
import '../sync/sync_event.dart';

/// Manages a single FirebaseSync connection for one collaborative project.
class ProjectSyncController {
  final FirebaseSync _sync;

  ProjectSyncController({
    required String projectId,
    required String userId,
  }) : _sync = FirebaseSync(projectId: projectId, userId: userId) {
    _sync.startListening();
    _sync.incomingDeltas.listen(_onDelta);
  }

  void _onDelta(SyncDelta delta) {
    emitSyncEvent(SyncEvent(
      projectId: delta.projectId,
      resourceType: delta.resourceType,
      resourceId: delta.resourceId,
      payload: delta.payload,
    ));
  }

  Future<void> pushDelta({
    required String resourceType,
    required String resourceId,
    required String operation,
    required Map<String, dynamic> payload,
  }) =>
      _sync.pushDelta(
        resourceType: resourceType,
        resourceId: resourceId,
        operation: operation,
        payload: payload,
      );

  /// Call after Drive write is confirmed to clean up Firebase relay entries.
  Future<void> clearMyDeltas() => _sync.clearMyDeltas();

  void dispose() => _sync.dispose();
}

/// Holds the currently active Firebase sync for the open project.
/// null = no collaborative project open / personal project.
/// Set by the project detail screen when opening a collaborative project.
final activeProjectSyncProvider =
    StateProvider<ProjectSyncController?>((_) => null);
