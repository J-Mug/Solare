# Phase 1: MVP — 노트 + 분기 수형도

## 목표
Hemisphere 작업을 이 앱 하나에서 할 수 있는 상태.
창작 도구(캐릭터, 위키 등)는 이 단계에서 만들지 않음.

## 작업 순서 (반드시 이 순서로)

### [x] 1-1. AuthService 구현
파일: lib/core/auth/auth_service.dart, auth_provider.dart, desktop_auth.dart
완료:
  - 웹: google_sign_in (GoogleSignIn은 kIsWeb일 때만 생성)
  - 데스크톱: googleapis_auth clientViaUserConsent + rundll32로 브라우저 오픈
  - AuthUser 공통 모델 (GoogleSignInAccount 의존성 제거)
  - flutter_secure_storage에 토큰 저장
확인:
  - [x] Windows 데스크톱 로그인 성공 (2026-05-08)
  - [ ] 웹(Chrome) 로그인 확인 필요

### [x] 1-2. DriveRepository 구현
파일: lib/core/drive/drive_repository.dart, drive_repository_impl.dart
완료: appDataFolder 기준 CRUD 구현됨
수정: stream.toBytes() → toList() 패치 완료

### [x] 1-3. LocalDatabase 구현
파일: lib/core/db/app_database.dart, db_provider.dart
완료: Drift 스키마 (pages, branch_nodes, branch_edges, sync_queue)
      app_database.g.dart 코드 생성 완료 (2339줄)
      db_provider.dart — appDatabaseProvider (Riverpod)
      빌드: dart.exe run build_runner build (run_build.ps1 참고)
확인:
  - [ ] 마이그레이션 실행 확인
  - [ ] Repository에서 Drift 캐시 통합 (현재 in-memory map 사용 중)

### [x] 1-4. SyncEngine 구현
파일: lib/core/sync/sync_engine.dart, sync_queue.dart
완료: debounce 3초 Drive 저장, Firebase delta stub 있음

### [x] 1-5. FeatureFlags 구현
파일: lib/core/platform/feature_flags.dart
완료: kIsWeb 기반 hasMoodboard/hasWorkspace/hasWidgets

### [x] 1-6. Notes Feature 구현
폴더: lib/features/notes/
완료:
  - domain/page_model.dart
  - data/notes_repository.dart + notes_repository_impl.dart
  - domain/notes_provider.dart
  - presentation/pages_list_screen.dart
  - presentation/page_editor_screen.dart (appflowy_editor 6.2.0)
  - presentation/widgets/page_tree_widget.dart
확인:
  - [x] 페이지 생성/수정/삭제
  - [x] 하위 페이지 생성 (무한 중첩)
  - [ ] Drive에 저장 확인 (로그인 성공 후 테스트 필요)
  - [ ] 앱 재시작 후 데이터 유지

### [ ] 1-7. BranchTree Feature 구현
폴더: lib/features/branch_tree/
현재: tree_canvas_screen.dart, tree_view.dart stub 상태
구현 순서:
  a. data/branch_repository.dart — interface
  b. data/branch_repository_impl.dart — Drive read/write
  c. domain/branch_models.dart — BranchNode, BranchEdge, BranchTree
  d. domain/branch_provider.dart — Riverpod StateNotifier
  e. presentation/branch_canvas_screen.dart — flutter_flow_chart 4.1.1 연동
  f. presentation/widgets/node_editor_dialog.dart — 노드 편집 다이얼로그
확인:
  - [ ] 노드 생성/이동/삭제
  - [ ] 노드 간 화살표 연결
  - [ ] 조건 태그 추가
  - [ ] 노드 클릭 → 노트 페이지 열림
  - [ ] Drive에 branch_tree.json 저장 확인

### [ ] 1-8. Firebase 협업 연동
파일: lib/core/firebase/firebase_sync.dart

### [ ] 1-9. 협업 초대 시스템
파일: lib/features/collaboration/

### [ ] 1-10. 라우팅 설정 완성
현재: notes 라우트 있음. branch_tree 라우트 추가 필요.

## Phase 1 완료 기준
- Google 로그인 → 자동 재인증 작동
- 노트 페이지 CRUD + 무한 중첩
- 분기 수형도 노드 CRUD + 연결
- 노드 → 노트 페이지 연결
- Drive 저장/로드
- Firebase delta 기반 실시간 협업
- GitHub Pages 배포 완료
- exe 빌드 + GitHub Releases 업로드 완료
