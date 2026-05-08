# 레이어 간 인터페이스 명세

## AuthService 인터페이스

```dart
class AuthUser {
  final String email;
}

class AuthService {
  AuthUser? get currentUser;
  Future<AuthUser?> signInSilently();
  Future<AuthUser?> signIn();
  Future<void> signOut();
  Future<String?> getAccessToken();
}
```

## DriveRepository 인터페이스

```dart
abstract class DriveRepository {
  Future<T?> readFile<T>(String path);
  Future<void> writeFile(String path, Object data);
  Future<void> deleteFile(String path);
  Future<List<String>> listFiles(String folder);
  Future<String> uploadBinary(String path, Uint8List bytes);
  Stream<void> watchChanges();
}
```

경로 규칙: appDataFolder 기준 상대경로
예: 'projects/proj-123/notes/page-456.json'

## NotesRepository 인터페이스

```dart
abstract class NotesRepository {
  Future<List<Page>> getPages(String projectId);
  Future<Page?> getPage(String projectId, String pageId);
  Future<void> savePage(String projectId, Page page);
  Future<void> deletePage(String projectId, String pageId);
}
```

## BranchRepository 인터페이스 (1-7 구현 예정)

```dart
abstract class BranchRepository {
  Future<BranchTree?> getBranchTree(String projectId);
  Future<void> saveBranchTree(String projectId, BranchTree tree);
}
```

Drive 경로: 'projects/{projectId}/branch_tree.json'

## SyncEngine 인터페이스

```dart
abstract class SyncEngine {
  Future<void> initialize(String projectId);
  Future<void> push(Change change);
  Future<void> pull();
  Stream<Delta> get incomingDeltas;
}
```

## FeatureFlags 인터페이스

```dart
abstract class FeatureFlags {
  bool get hasMoodboard;    // exe만 true
  bool get hasWorkspace;    // exe만 true
  bool get hasWidgets;      // exe만 true
  bool get hasFullOffline;  // exe만 true
  bool get hasCustomThemes; // exe만 true
}
```

## Riverpod Provider 목록

```dart
// core
authServiceProvider   → AuthService
authProvider          → StateNotifier<AuthState>
driveRepositoryProvider → DriveRepository
syncEngineProvider    → SyncEngine

// features/notes
notesRepositoryProvider → NotesRepository
pagesProvider(projectId) → AsyncNotifier<List<Page>>
pageProvider(projectId, pageId) → AsyncNotifier<Page?>

// features/branch_tree (1-7 예정)
branchRepositoryProvider → BranchRepository
branchTreeProvider(projectId) → AsyncNotifier<BranchTree?>
```
