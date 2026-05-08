import '../domain/project_model.dart';

abstract class ProjectRepository {
  Future<List<ProjectModel>> getProjects();
  Future<void> saveProject(ProjectModel project);
  Future<void> deleteProject(String projectId);
}
