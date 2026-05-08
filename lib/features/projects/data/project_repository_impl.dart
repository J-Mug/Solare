import '../../../core/drive/drive_repository.dart';
import '../domain/project_model.dart';
import 'project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final DriveRepository _drive;
  List<ProjectModel>? _cache;

  static const _manifestPath = 'projects/manifest.json';

  ProjectRepositoryImpl(this._drive);

  @override
  Future<List<ProjectModel>> getProjects() async {
    try {
      final data = await _drive.readFile<Map<String, dynamic>>(_manifestPath);
      if (data == null) return _cache ?? [];
      final list = data['projects'] as List<dynamic>? ?? [];
      _cache = list
          .map((e) => ProjectModel.fromMap(e as Map<String, dynamic>))
          .toList();
      return _cache!;
    } catch (_) {
      return _cache ?? [];
    }
  }

  @override
  Future<void> saveProject(ProjectModel project) async {
    // Optimistic cache update
    final projects = List<ProjectModel>.from(_cache ?? []);
    final idx = projects.indexWhere((p) => p.id == project.id);
    if (idx >= 0) {
      projects[idx] = project;
    } else {
      projects.add(project);
    }
    _cache = projects;
    await _drive.writeFile(_manifestPath, {
      'projects': projects.map((p) => p.toMap()).toList(),
    });
  }

  @override
  Future<void> deleteProject(String projectId) async {
    _cache = (_cache ?? []).where((p) => p.id != projectId).toList();
    await _drive.writeFile(_manifestPath, {
      'projects': (_cache ?? []).map((p) => p.toMap()).toList(),
    });
  }
}
