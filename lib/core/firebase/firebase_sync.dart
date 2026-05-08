import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_config.dart';

/// Delta 전송/수신 단위
class SyncDelta {
  final String id;
  final String projectId;
  final String resourceType; // 'page' | 'branch_tree' | 'character' | 'wiki'
  final String resourceId;
  final String operation;    // 'create' | 'update' | 'delete'
  final Map<String, dynamic> payload;
  final String userId;
  final DateTime timestamp;

  SyncDelta({
    required this.id,
    required this.projectId,
    required this.resourceType,
    required this.resourceId,
    required this.operation,
    required this.payload,
    required this.userId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'projectId': projectId,
        'resourceType': resourceType,
        'resourceId': resourceId,
        'operation': operation,
        'payload': payload,
        'userId': userId,
        'timestamp': timestamp.toIso8601String(),
      };

  factory SyncDelta.fromMap(String id, Map<dynamic, dynamic> map) => SyncDelta(
        id: id,
        projectId: map['projectId'] as String,
        resourceType: map['resourceType'] as String,
        resourceId: map['resourceId'] as String,
        operation: map['operation'] as String,
        payload: Map<String, dynamic>.from(map['payload'] as Map),
        userId: map['userId'] as String,
        timestamp: DateTime.parse(map['timestamp'] as String),
      );
}

/// Firebase Realtime DB 기반 delta 중계
/// DB 경로: projects/{projectId}/deltas/{deltaId}
class FirebaseSync {
  final String _projectId;
  final String _userId;
  StreamSubscription<DatabaseEvent>? _subscription;
  final _deltaController = StreamController<SyncDelta>.broadcast();

  FirebaseSync({required String projectId, required String userId})
      : _projectId = projectId,
        _userId = userId;

  Stream<SyncDelta> get incomingDeltas => _deltaController.stream;

  DatabaseReference get _deltasRef =>
      FirebaseConfig.dbRoot.child('projects/$_projectId/deltas');

  /// 상대방 delta 수신 시작
  void startListening() {
    _subscription = _deltasRef.onChildAdded.listen((event) {
      final data = event.snapshot.value;
      if (data == null) return;
      final delta = SyncDelta.fromMap(
        event.snapshot.key!,
        data as Map<dynamic, dynamic>,
      );
      // 내가 보낸 delta는 무시
      if (delta.userId == _userId) return;
      _deltaController.add(delta);
    });
  }

  /// Delta 전송
  Future<void> pushDelta({
    required String resourceType,
    required String resourceId,
    required String operation,
    required Map<String, dynamic> payload,
  }) async {
    final ref = _deltasRef.push();
    final delta = SyncDelta(
      id: ref.key!,
      projectId: _projectId,
      resourceType: resourceType,
      resourceId: resourceId,
      operation: operation,
      payload: payload,
      userId: _userId,
      timestamp: DateTime.now(),
    );
    await ref.set(delta.toMap());
  }

  /// Drive 저장 완료 후 처리된 delta 삭제
  Future<void> deleteDelta(String deltaId) async {
    await _deltasRef.child(deltaId).remove();
  }

  /// 오래된 delta 일괄 삭제 (Drive 저장 완료 후 호출)
  Future<void> clearMyDeltas() async {
    final snapshot = await _deltasRef.get();
    if (!snapshot.exists) return;
    final data = snapshot.value as Map<dynamic, dynamic>;
    for (final entry in data.entries) {
      final delta = entry.value as Map<dynamic, dynamic>;
      if (delta['userId'] == _userId) {
        await _deltasRef.child(entry.key as String).remove();
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
    _deltaController.close();
  }
}
