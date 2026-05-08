import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/drive/drive_service.dart';
import '../../../core/drive/drive_repository.dart';
import 'moodboard_model.dart';

final moodboardProvider = StateNotifierProvider.family<MoodboardNotifier,
    AsyncValue<MoodboardData>, String>(
  (ref, projectId) {
    final driveAsync = ref.watch(driveRepositoryProvider);
    final drive = driveAsync.valueOrNull;
    return MoodboardNotifier(drive, projectId);
  },
);

class MoodboardNotifier extends StateNotifier<AsyncValue<MoodboardData>> {
  final DriveRepository? _drive;
  final String _projectId;
  Timer? _debounce;

  static String _path(String projectId) =>
      'projects/$projectId/moodboard.json';

  MoodboardNotifier(this._drive, this._projectId)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    if (_drive == null) {
      state = AsyncValue.data(MoodboardData.empty(_projectId));
      return;
    }
    try {
      final data = await _drive
          .readFile<Map<String, dynamic>>(_path(_projectId));
      state = AsyncValue.data(data == null
          ? MoodboardData.empty(_projectId)
          : MoodboardData.fromJson(data));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addItem(MoodboardItem item) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data(
        current.copyWith(items: [...current.items, item]));
    _scheduleSave();
  }

  void updateItem(MoodboardItem updated) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(
      items: current.items.map((i) => i.id == updated.id ? updated : i).toList(),
    ));
    _scheduleSave();
  }

  void removeItem(String itemId) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(
      items: current.items.where((i) => i.id != itemId).toList(),
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
