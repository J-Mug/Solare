import 'package:flutter/foundation.dart';

class SyncQueueItem {
  final String id;
  final String path;
  final String operation; 
  final dynamic payload;
  final DateTime timestamp;

  SyncQueueItem({
    required this.id,
    required this.path,
    required this.operation,
    required this.payload,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'path': path,
    'operation': operation,
    'payload': payload,
    'timestamp': timestamp.toIso8601String(),
  };

  factory SyncQueueItem.fromJson(Map<String, dynamic> json) => SyncQueueItem(
    id: json['id'],
    path: json['path'],
    operation: json['operation'],
    payload: json['payload'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

class SyncQueue {
  final List<SyncQueueItem> _queue = [];
  
  // In a real app, this should be backed by SQLite (Drift)
  Future<void> enqueue(SyncQueueItem item) async {
    _queue.add(item);
  }

  Future<void> remove(String id) async {
    _queue.removeWhere((item) => item.id == id);
  }

  Future<List<SyncQueueItem>> getItems() async {
    return List.unmodifiable(_queue);
  }

  Future<void> clear() async {
    _queue.clear();
  }
}
