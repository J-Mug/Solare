import '../../../core/drive/drive_repository.dart';
import '../domain/project_model.dart';
import 'project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final DriveRepository _drive;

  static const _manifestPath = 'projects/manifest.json';

  ProjectRepositoryImpl(this._drive);

  @override
  Future<List<ProjectModel>> getProjects() async {
    final data = await _drive.readFile<Map<String, dynamic>>(_manifestPath);
    if (data == null) return [];
    final list = data['projects'] as List<dynamic>? ?? [];
    return list
        .map((e) => ProjectModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveProject(ProjectModel project) async {
    final projects = await getProjects();
    final idx = projects.indexWhere((p) => p.id == project.id);
    if (idx >= 0) {
      projects[idx] = project;
    } else {
      projects.add(project);
    }
    await _drive.writeFile(_manifestPath, {
      'projects': projects.map((p) => p.toMap()).toList(),
    });
  }

  @override
  Future<void> deleteProject(String projectId) async {
    final projects = await getProjects();
    projects.removeWhere((p) => p.id == projectId);
    await _drive.writeFile(_manifestPath, {
      'projects': projects.map((p) => p.toMap()).toList(),
    });
  }
}
