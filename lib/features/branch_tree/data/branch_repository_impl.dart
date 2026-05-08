import '../../../core/drive/drive_repository.dart';
import 'branch_repository.dart';

class BranchRepositoryImpl implements BranchRepository {
  final DriveRepository _drive;

  BranchRepositoryImpl(this._drive);

  String _path(String projectId) => 'projects/$projectId/branch_tree.json';

  @override
  Future<Map<String, dynamic>?> loadBranchTree(String projectId) async {
    return _drive.readFile<Map<String, dynamic>>(_path(projectId));
  }

  @override
  Future<void> saveBranchTree(
      String projectId, Map<String, dynamic> data) async {
    await _drive.writeFile(_path(projectId), data);
  }
}
