import 'dart:async';

/// Represents an incoming sync delta from a collaborator.
class SyncEvent {
  final String projectId;
  final String resourceType; // 'page' | 'branch_tree'
  final String resourceId;
  final Map<String, dynamic> payload;

  const SyncEvent({
    required this.projectId,
    required this.resourceType,
    required this.resourceId,
    required this.payload,
  });
}

// Global broadcast stream shared across the app.
// Emitted by core/firebase layer; consumed by feature providers.
final _syncEventController = StreamController<SyncEvent>.broadcast();

/// The stream of incoming sync events. Features listen to this.
Stream<SyncEvent> get incomingSyncEvents => _syncEventController.stream;

/// Called by the Firebase sync layer when a collaborator's delta arrives.
void emitSyncEvent(SyncEvent event) => _syncEventController.add(event);
