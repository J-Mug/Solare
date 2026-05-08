import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../drive/drive_repository.dart';
import 'sync_queue.dart';

class SyncEngine {
  final DriveRepository _drive;
  final SyncQueue _queue;
  final bool isCollaborative;
  
  Timer? _debounceTimer;

  SyncEngine({
    required DriveRepository drive,
    required SyncQueue queue,
    this.isCollaborative = false,
  }) : _drive = drive, _queue = queue;

  Future<void> initialize() async {
    try {
      // 1. Check Drive manifest.json
      final manifest = await _drive.readFile<Map<String, dynamic>>('manifest.json');
      
      // If remote is newer, pull. If local queue exists, push.
      final localChanges = await _queue.getItems();
      
      if (localChanges.isNotEmpty) {
        await _processQueue();
      } else {
        // Pull logic here: Compare manifest versions, resolve conflicts via updated_at
      }

      if (isCollaborative) {
        // Subscribe to Firebase Delta
        // ProjectFirebaseSync.subscribeToDelta().listen(...);
      }
    } catch (e) {
      if (kDebugMode) print('Initialization or manifest read error: $e');
    }
  }

  Future<void> processEdit({
    required String path,
    required String operation,
    required dynamic payload,
  }) async {
    // 1. Save to local SQLite immediately (Expected to be handled by local DB layer)

    final item = SyncQueueItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      path: path,
      operation: operation,
      payload: payload,
      timestamp: DateTime.now(),
    );
    
    // 2. Add to local offline queue
    await _queue.enqueue(item);

    // 3. If collaborative, send delta to Firebase immediately
    if (isCollaborative) {
       // ProjectFirebaseSync.sendDelta(item.toJson());
    }

    // 4. Debounce 3s, then save to Drive
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 3), () {
      _syncToDrive();
    });
  }

  Future<void> processImage(String path, Uint8List bytes) async {
    // 3. Upload directly to Drive
    final fileId = await _drive.uploadBinary(path, bytes);
    
    // Send only file ID to Firebase delta
    if (isCollaborative) {
      // ProjectFirebaseSync.sendDelta({ 'operation': 'image_upload', 'fileId': fileId, ... });
    }
  }

  Future<void> _syncToDrive() async {
    await _processQueue();
  }

  Future<void> _processQueue() async {
    final items = await _queue.getItems();
    if (items.isEmpty) return;

    for (final item in items) {
      try {
        if (item.operation == 'update' || item.operation == 'create') {
          await _drive.writeFile(item.path, item.payload);
        } else if (item.operation == 'delete') {
          await _drive.deleteFile(item.path);
        }
        
        await _queue.remove(item.id);

        if (isCollaborative) {
          // After Drive save, delete Firebase delta
          // ProjectFirebaseSync.deleteDelta(item.id);
        }
      } catch (e) {
        if (kDebugMode) print('Drive Sync Error ($item): $e');
        // Keep in queue and retry later
      }
    }
  }
}
