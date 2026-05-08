import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/drive/drive_service.dart';
import '../data/project_repository.dart';
import '../data/project_repository_impl.dart';
import 'project_model.dart';

final projectRepositoryProvider = Provider<ProjectRepository?>((ref) {
  return ref.watch(driveRepositoryProvider).whenOrNull(
        data: (drive) =>
            drive != null ? ProjectRepositoryImpl(drive) : null,
      );
});

final projectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  final repo = ref.watch(projectRepositoryProvider);
  if (repo == null) return [];
  return repo.getProjects();
});

// Single project by ID
final projectProvider =
    FutureProvider.autoDispose.family<ProjectModel?, String>((ref, id) async {
  final projects = await ref.watch(projectsProvider.future);
  try {
    return projects.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
});

class ProjectsController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  ProjectsController(this._ref) : super(const AsyncData(null));

  ProjectRepository? get _repo => _ref.read(projectRepositoryProvider);

  Future<ProjectModel?> createProject({
    required String name,
    required String ownerEmail,
    bool isCollaborative = false,
  }) async {
    final repo = _repo;
    if (repo == null) return null;
    state = const AsyncLoading();
    try {
      final project = ProjectModel.create(
        name: name,
        ownerEmail: ownerEmail,
        isCollaborative: isCollaborative,
      );
      await repo.saveProject(project);
      _ref.invalidate(projectsProvider);
      state = const AsyncData(null);
      return project;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }

  Future<void> deleteProject(String projectId) async {
    final repo = _repo;
    if (repo == null) return;
    state = const AsyncLoading();
    try {
      await repo.deleteProject(projectId);
      _ref.invalidate(projectsProvider);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addMember(ProjectModel project, String email) async {
    final repo = _repo;
    if (repo == null) return;
    if (project.memberEmails.contains(email)) return;
    final updated = project.copyWith(
      memberEmails: [...project.memberEmails, email],
      updatedAt: DateTime.now(),
    );
    await repo.saveProject(updated);
    _ref.invalidate(projectsProvider);
  }
}

final projectsControllerProvider =
    StateNotifierProvider<ProjectsController, AsyncValue<void>>(
  (ref) => ProjectsController(ref),
);
