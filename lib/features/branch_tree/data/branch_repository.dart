abstract class BranchRepository {
  /// Load raw dashboard map from Drive
  Future<Map<String, dynamic>?> loadBranchTree(String projectId);

  /// Save raw dashboard map to Drive
  Future<void> saveBranchTree(String projectId, Map<String, dynamic> data);
}
