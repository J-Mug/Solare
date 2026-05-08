import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/drive/drive_service.dart';
import '../../../core/drive/drive_repository.dart';
import 'timeline_model.dart';

final timelineProvider = StateNotifierProvider.family<TimelineNotifier,
    AsyncValue<TimelineData>, String>(
  (ref, projectId) {
    final driveAsync = ref.watch(driveRepositoryProvider);
    final drive = driveAsync.valueOrNull;
    return TimelineNotifier(drive, projectId);
  },
);

class TimelineNotifier extends StateNotifier<AsyncValue<TimelineData>> {
  final DriveRepository? _drive;
  final String _projectId;
  Timer? _debounce;

  static String _path(String projectId) =>
      'projects/$projectId/timeline.json';

  TimelineNotifier(this._drive, this._projectId)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    if (_drive == null) {
      state = AsyncValue.data(TimelineData.empty(_projectId));
      return;
    }
    try {
      final data =
          await _drive.readFile<Map<String, dynamic>>(_path(_projectId));
      state = AsyncValue.data(data == null
          ? TimelineData.empty(_projectId)
          : TimelineData.fromJson(data));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addEvent(TimelineEvent event) {
    final current = state.valueOrNull;
    if (current == null) return;
    final events = [...current.events, event]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    state = AsyncValue.data(current.copyWith(events: events));
    _scheduleSave();
  }

  void updateEvent(TimelineEvent updated) {
    final current = state.valueOrNull;
    if (current == null) return;
    final events = current.events
        .map((e) => e.id == updated.id ? updated : e)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    state = AsyncValue.data(current.copyWith(events: events));
    _scheduleSave();
  }

  void removeEvent(String eventId) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(
      events: current.events.where((e) => e.id != eventId).toList(),
    ));
    _scheduleSave();
  }

  void _scheduleSave() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 3), _save);
  }

  Future<void> _save() async {
    final data = state.valueOrNull;
    if (data == null || _drive == null) return;
    await _drive.writeFile(_path(_projectId), data.toJson());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
