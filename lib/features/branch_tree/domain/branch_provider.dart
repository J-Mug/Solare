import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';
import '../../../core/drive/drive_service.dart';
import '../../../core/firebase/project_sync_provider.dart';
import '../../../core/sync/sync_event.dart';
import '../data/branch_repository.dart';
import '../data/branch_repository_impl.dart';
import 'branch_node_data.dart';

final branchRepositoryProvider =
    Provider.family<BranchRepository?, String>((ref, projectId) {
  final driveAsync = ref.watch(driveRepositoryProvider);
  return driveAsync.whenOrNull(
    data: (drive) => drive == null ? null : BranchRepositoryImpl(drive),
  );
});

final branchProvider = StateNotifierProvider.family<BranchNotifier,
    AsyncValue<Dashboard<BranchNodeData>>, String>(
  (ref, projectId) {
    final repo = ref.watch(branchRepositoryProvider(projectId));
    return BranchNotifier(repo, projectId, ref);
  },
);

class BranchNotifier
    extends StateNotifier<AsyncValue<Dashboard<BranchNodeData>>> {
  final BranchRepository? _repo;
  final String _projectId;
  final Ref _ref;
  Timer? _saveDebounce;
  StreamSubscription<SyncEvent>? _syncSub;

  BranchNotifier(this._repo, this._projectId, this._ref)
      : super(const AsyncValue.loading()) {
    _load();
    _syncSub = incomingSyncEvents
        .where((e) =>
            e.projectId == _projectId && e.resourceType == 'branch_tree')
        .listen(_applyIncomingDelta);
  }

  void _applyIncomingDelta(SyncEvent event) {
    final dashboard = Dashboard.fromMap(
      event.payload,
      dataSerializer: BranchNodeDataSerializer(),
    );
    state = AsyncValue.data(dashboard);
  }

  Dashboard<BranchNodeData> _newDashboard() => Dashboard<BranchNodeData>(
        defaultArrowStyle: ArrowStyle.curve,
        dataSerializer: BranchNodeDataSerializer(),
      );

  Future<void> _load() async {
    if (_repo == null) {
      state = AsyncValue.data(_newDashboard());
      return;
    }
    try {
      final map = await _repo.loadBranchTree(_projectId);
      if (map == null) {
        state = AsyncValue.data(_newDashboard());
      } else {
        state = AsyncValue.data(
          Dashboard.fromMap(map, dataSerializer: BranchNodeDataSerializer()),
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Call after any dashboard mutation to persist changes
  void onChanged() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(seconds: 3), _save);
  }

  Future<void> _save() async {
    final dashboard = state.valueOrNull;
    if (dashboard == null || _repo == null) return;
    final map = dashboard.toMap();
    await _repo.saveBranchTree(_projectId, map);

    // After Drive write, push delta so collaborators get the update
    final sync = _ref.read(activeProjectSyncProvider);
    if (sync != null) {
      await sync.pushDelta(
        resourceType: 'branch_tree',
        resourceId: _projectId,
        operation: 'update',
        payload: map,
      );
      await sync.clearMyDeltas();
    }
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    _syncSub?.cancel();
    super.dispose();
  }
}
