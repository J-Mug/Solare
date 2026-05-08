# 🏗️ Solare — Claude Code 개발 하네스

> **목적**: Claude Code가 ForgeWrite를 혼동 없이, 최소한의 지시로, 올바른 순서로 개발할 수 있도록 설계한 작업 구조. 이 문서 하나를 Claude Code에게 주면 전체 개발을 진행할 수 있다.
> 

> **연결 문서**: ForgeWrite 시스템 설계 최종본
> 

> **작성일**: 2026-05-08
> 

---

## 왜 하네스가 필요한가

Claude Code는 뛰어나지만 두 가지 약점이 있다.

첫째, **컨텍스트 붕괴**. 대화가 길어지면 앞에서 결정한 내용을 잊고 다른 방향으로 구현한다. 예를 들어 Drive 동기화를 appDataFolder로 하기로 했는데, 나중에 일반 Drive 폴더로 구현해버리는 경우.

둘째, **범위 초과**. "분기 수형도 만들어줘"라고 하면 갑자기 UI 전체를 다 만들거나, 요청하지 않은 기능까지 구현하려 한다.

하네스는 이 두 문제를 해결한다. Claude Code가 각 작업마다 **무엇을 만들지, 무엇을 만들지 않을지, 어떤 판단 기준을 쓸지**를 명확히 알 수 있도록 구조화한 것이다.

---

## 전체 레포지토리 구조

```
forgewrite/
│
├─ .claude/                          ← Claude Code 전용 설정
│    ├─ CLAUDE.md                    ← 핵심 판단 기준 (매 세션 참조)
│    ├─ context/
│    │    ├─ architecture.md         ← 전체 아키텍처 요약
│    │    ├─ data-models.md          ← 데이터 모델 정의
│    │    ├─ decisions.md            ← 확정된 기술 결정 목록
│    │    └─ api-contracts.md        ← 레이어 간 인터페이스 명세
│    └─ tasks/                       ← 단계별 작업 명세
│         ├─ phase0-setup.md
│         ├─ phase1-mvp.md
│         ├─ phase2-creative.md
│         ├─ phase3-polish.md
│         └─ phase4-mcp.md
│
├─ forgewrite_app/                   ← Flutter 앱 (웹 + exe)
│    ├─ lib/
│    │    ├─ core/                   ← 전체 공통 레이어
│    │    │    ├─ auth/              ← Google OAuth
│    │    │    ├─ drive/             ← Drive API 클라이언트
│    │    │    ├─ firebase/          ← Firebase 클라이언트
│    │    │    ├─ db/                ← SQLite (로컬 캐시)
│    │    │    ├─ sync/              ← 동기화 엔진
│    │    │    └─ platform/          ← 웹/exe 분기 처리
│    │    │
│    │    ├─ features/               ← 기능별 모듈
│    │    │    ├─ notes/             ← 노트 시스템
│    │    │    ├─ branch_tree/       ← 분기 수형도
│    │    │    ├─ characters/        ← 캐릭터 시트
│    │    │    ├─ wiki/              ← 세계관 위키
│    │    │    ├─ episodes/          ← 에피소드 에디터
│    │    │    ├─ moodboard/         ← 무드보드
│    │    │    ├─ timeline/          ← 타임라인
│    │    │    └─ collaboration/     ← 협업 (초대/권한)
│    │    │
│    │    ├─ shared/                 ← 공유 위젯/유틸
│    │    │    ├─ widgets/
│    │    │    └─ utils/
│    │    │
│    │    └─ main.dart
│    │
│    ├─ test/
│    │    ├─ unit/                   ← 유닛 테스트
│    │    ├─ integration/            ← 통합 테스트
│    │    └─ mocks/                  ← Drive/Firebase 목 객체
│    │
│    └─ pubspec.yaml
│
├─ mcp_server/                       ← MCP 서버 (Railway 배포)
│    ├─ src/
│    │    ├─ tools/                  ← MCP 툴 구현
│    │    │    ├─ notes.ts
│    │    │    ├─ branch_tree.ts
│    │    │    ├─ characters.ts
│    │    │    └─ wiki.ts
│    │    ├─ drive/                  ← Drive API 클라이언트
│    │    └─ index.ts                ← 서버 진입점
│    ├─ package.json
│    └─ railway.toml
│
└─ .github/
     └─ workflows/
          ├─ deploy-web.yml          ← GitHub Pages 배포
          ├─ deploy-windows.yml      ← exe 빌드 + Releases 업로드
          └─ mcp-keep-alive.yml      ← Railway 슬립 방지
```

---

## .claude/[CLAUDE.md](http://CLAUDE.md) — 핵심 판단 기준

이 파일이 하네스의 핵심이다. Claude Code는 모든 작업 전에 이 파일을 읽는다.

```markdown
# ForgeWrite — Claude Code 판단 기준

## 이 프로젝트가 무엇인가
노션형 노트 + 세계관 창작 + TRPG 분기 설계를 하나로 합친 창작 플랫폼.
Hemisphere 게임 개발에 직접 사용하며 검증 후 공개 배포 예정.

## 절대 변경하지 않는 결정들

### 스토리지
- 사용자 데이터는 무조건 Google Drive appDataFolder에 저장
- appDataFolder 외 일반 Drive 폴더 절대 사용 금지
- Firebase는 실시간 delta 중계만. 원본 데이터 저장 금지
- 로컬 SQLite는 Drive 동기화 전 임시 캐시 + 오프라인 작업용

### 인증
- Google OAuth만 사용. 자체 계정 시스템 만들지 말 것
- 최초 1회 로그인 후 signInSilently()로 자동 재인증
- 토큰은 flutter_secure_storage에만 저장

### 플랫폼
- Flutter 단일 코드베이스. 플랫폼별 분리 코드 최소화
- 웹/exe 분기는 core/platform/ 안에서만 처리
- 기능 제한 (웹 vs exe) 은 feature flags로 관리

### 아키텍처
- Feature-first 폴더 구조. 기능별로 완전히 독립
- 각 feature는 data / domain / presentation 3레이어
- feature 간 직접 import 금지. 반드시 core/ 경유
- Riverpod으로만 상태 관리. StatefulWidget 최소화

### AI / MCP
- 앱 자체에 AI 기능 없음
- AI는 오직 MCP 서버를 통해 Claude 앱에서만 연결
- MCP 서버는 Drive 읽기/쓰기만 담당. 비즈니스 로직 없음

## 판단이 필요할 때 우선순위
1. 데이터 안전 (유실 없을 것)
2. 오프라인 작동 (인터넷 없어도 작업 가능)
3. 단순함 (복잡한 해법보다 단순한 해법)
4. 성능
5. 코드 우아함

## 작업 범위 원칙
- 요청한 것만 만든다. 관련되어 보여도 요청 없으면 만들지 않는다
- 하나의 작업 = 하나의 feature 또는 하나의 레이어
- 완성되지 않은 기능은 TODO 주석으로 명시하고 stub으로 남긴다
- 테스트는 핵심 로직(sync, auth, drive)에만 작성한다
```

---

## .claude/context/[architecture.md](http://architecture.md)

```markdown
# ForgeWrite 아키텍처

## 데이터 흐름 전체

사용자 입력
    ↓
Presentation (Flutter Widget)
    ↓
Domain (Riverpod Provider + UseCase)
    ↓
Data (Repository)
    ├─ LocalRepository → SQLite (즉시 저장)
    └─ DriveRepository → Google Drive (3초 debounce)
         ↓ (동시에)
    FirebaseRepository → Firebase (즉시, delta만)

## 실시간 협업 흐름

내 편집
    ↓ 즉시
Firebase delta 전송 → 상대방 화면 반영
    ↓ 3초 후
Drive 저장 → Firebase delta 삭제

## 레이어 책임

Presentation: UI만. 비즈니스 로직 없음
Domain: 비즈니스 규칙. 외부 의존성 없음
Data: Drive/Firebase/SQLite 구현체
Core: 전역 서비스 (Auth, Sync, Platform)

## Feature 독립성

각 feature는 자신의 data/domain/presentation을 가짐
feature A가 feature B를 직접 import하면 안 됨
공유 데이터는 core/db 또는 Drive 파일로 교환
```

---

## .claude/context/[data-models.md](http://data-models.md)

```markdown
# 데이터 모델 정의

## Drive 파일 구조

appDataFolder/
  manifest.json
  settings.json
  projects/
    {project_id}/
      meta.json
      notes/{page_id}.json
      branch_tree.json
      characters/{char_id}.json
      wiki/{wiki_id}.json
      episodes/{ep_id}.json
      timeline.json
      moodboard/{board_id}.json
      snapshots/{timestamp}.json

## 핵심 모델

### Page (노트)
{
  id: string,           # UUID
  parent_id: string?,   # null이면 루트 페이지
  title: string,
  blocks: Block[],      # 순서 있는 블록 배열
  created_at: ISO8601,
  updated_at: ISO8601
}

### Block
{
  id: string,
  type: 'text'|'heading1'|'heading2'|'heading3'|
        'checklist'|'quote'|'divider'|'code'|'page',
  content: string,      # type='page'이면 page_id
  checked: bool?        # type='checklist'일 때만
}

### BranchNode (분기 수형도 노드)
{
  id: string,
  type: 'event'|'choice'|'condition'|'result',
  label: string,
  description: string,
  position: {x: float, y: float},
  connected_page_id: string?,   # 연결된 노트 페이지
  tags: string[],               # 조건 태그
  updated_at: ISO8601
}

### BranchEdge (노드 간 연결)
{
  id: string,
  from_node_id: string,
  to_node_id: string,
  condition: string?,   # 이 연결의 조건 설명
  label: string?
}

### Character
{
  id: string,
  name: string,
  mbti: string?,
  backstory: string,
  habits: string[],
  traumas: string[],
  relationships: [
    {target_id: string, type: string, description: string}
  ],
  updated_at: ISO8601
}

### Delta (Firebase 실시간 전송 단위)
{
  id: string,           # delta 고유 ID
  project_id: string,
  resource_type: 'page'|'branch_tree'|'character'|'wiki',
  resource_id: string,
  operation: 'update'|'delete'|'create',
  payload: object,      # 변경된 부분만
  user_id: string,
  timestamp: ISO8601
}
```

---

## .claude/context/[decisions.md](http://decisions.md)

```markdown
# 확정된 기술 결정

## 패키지 결정

| 용도 | 패키지 | 대안 채택 안 한 이유 |
|------|--------|--------------------|
| 블록 에디터 | appflowy_editor | flutter_quill보다 Notion에 가까움 |
| 상태관리 | flutter_riverpod | Provider는 유지보수 종료 예정 |
| 로컬 DB | drift | sqflite보다 타입 안전 |
| 캔버스 | flutter_flow_chart | 노드 연결 기능 내장 |
| 라우팅 | go_router | Navigator 2.0 직접 구현보다 단순 |
| 토큰 저장 | flutter_secure_storage | SharedPreferences는 암호화 없음 |

## 아키텍처 결정

- Riverpod Notifier 패턴 사용 (StateNotifier 아님)
- Repository 패턴: interface + 구현체 분리
- Drive 파일 하나 = 데이터 단위 하나 (page, character 등)
- Delta 방식: 전체 파일 덮어쓰기 금지, 변경분만 전송
- 충돌 해결: updated_at 타임스탬프 최신 우선

## 플랫폼 결정

- 웹: flutter build web --release --base-href /forgewrite/
- exe: flutter build windows --release
- 플랫폼 감지: kIsWeb + Platform.isWindows
- 웹 전용 제한 기능: feature_flags.dart에서 관리

## MCP 서버 결정

- 런타임: Node.js + TypeScript
- 배포: Railway 무료 티어
- 슬립 방지: GitHub Actions 10분 핑
- 인증: 사용자 Drive 토큰을 MCP 요청 헤더로 전달
- Drive 접근: 읽기/쓰기 모두 허용 (update_page 툴)
```

---

## .claude/context/[api-contracts.md](http://api-contracts.md)

```markdown
# 레이어 간 인터페이스 명세

## DriveRepository 인터페이스

abstract class DriveRepository {
  Future<T> readFile<T>(String path);
  Future<void> writeFile(String path, Object data);
  Future<void> deleteFile(String path);
  Future<List<String>> listFiles(String folder);
  Future<String> uploadBinary(String path, Uint8List bytes);
  Stream<DriveChange> watchChanges();  # Drive Watch API
}

## SyncEngine 인터페이스

abstract class SyncEngine {
  Future<void> initialize(String projectId);
  Future<void> push(Change change);
  Future<void> pull();
  Stream<Delta> get incomingDeltas;
  Future<void> resolveConflict(Change local, Change remote);
}

## FeatureFlags 인터페이스

abstract class FeatureFlags {
  bool get hasMoodboard;       # exe만 true
  bool get hasWorkspace;       # exe만 true
  bool get hasWidgets;         # exe만 true
  bool get hasFullOffline;     # exe만 true
  bool get hasCustomThemes;    # exe만 true
}

## AuthService 인터페이스

abstract class AuthService {
  Future<bool> signInSilently();
  Future<bool> signIn();
  Future<void> signOut();
  Future<Map<String,String>> getAuthHeaders();
  Stream<AuthState> get authStateChanges;
}
```

---

## .claude/tasks/ — 단계별 작업 명세

### [phase0-setup.md](http://phase0-setup.md)

```markdown
# Phase 0: 프로젝트 셋업

## 목표
코드 한 줄 없이 인프라만 완성. 이 단계에서 기능 구현 없음.

## 작업 목록

### 0-1. Flutter 프로젝트 생성
명령: flutter create --platforms=web,windows forgewrite_app
확인: flutter run -d chrome 정상 실행

### 0-2. 패키지 추가
 pubspec.yaml에 아래 패키지 추가 후 flutter pub get:
  google_sign_in: ^6.2.1
  googleapis: ^13.2.0
  googleapis_auth: ^1.6.0
  flutter_secure_storage: ^9.2.2
  firebase_core: ^3.6.0
  firebase_database: ^11.1.4
  drift: ^2.20.2
  drift_flutter: ^0.2.4
  sqlite3_flutter_libs: ^0.5.24
  appflowy_editor: ^4.1.0
  flutter_flow_chart: ^0.0.9
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  connectivity_plus: ^6.1.0
  go_router: ^14.6.2

### 0-3. 폴더 구조 생성
위 레포지토리 구조대로 빈 폴더와 placeholder 파일 생성.
각 폴더에 .gitkeep 추가.

### 0-4. GitHub Actions 설정
.github/workflows/deploy-web.yml 작성
.github/workflows/deploy-windows.yml 작성
.github/workflows/mcp-keep-alive.yml 작성
실제 배포는 하지 않음. 파일만 작성.

### 0-5. CLAUDE.md 등 컨텍스트 파일 배치
.claude/ 폴더에 위 문서들 그대로 저장.

## 완료 기준
- flutter run -d chrome 실행됨 (빈 화면이어도 됨)
- flutter build web --release 빌드 성공
- flutter build windows --release 빌드 성공
- 패키지 의존성 충돌 없음
```

---

### [phase1-mvp.md](http://phase1-mvp.md)

```markdown
# Phase 1: MVP — 노트 + 분기 수형도

## 목표
Hemisphere 작업을 이 앱 하나에서 할 수 있는 상태.
창작 도구(캐릭터, 위키 등)는 이 단계에서 만들지 않음.

## 작업 순서 (반드시 이 순서로)

### 1-1. AuthService 구현
파일: lib/core/auth/auth_service.dart
구현:
  - GoogleSignIn 초기화 (scopes: drive.appdata, email)
  - signInSilently() 구현
  - signIn() 구현 (최초 1회용)
  - getAuthHeaders() 구현
  - 토큰을 flutter_secure_storage에 저장
테스트: test/unit/auth_service_test.dart 작성
다음 작업 전 확인: 실제 Google 로그인 성공

### 1-2. DriveRepository 구현
파일: lib/core/drive/drive_repository_impl.dart
구현:
  - readFile<T>(path) — appDataFolder 기준 경로
  - writeFile(path, data)
  - listFiles(folder)
  - uploadBinary(path, bytes)
주의: appDataFolder 외 경로 접근 코드 작성 금지
테스트: test/unit/drive_repository_test.dart (목 사용)
다음 작업 전 확인: Drive에 test.json 쓰고 읽기 성공

### 1-3. LocalDatabase 구현
파일: lib/core/db/app_database.dart (drift)
테이블:
  - pages (id, parent_id, title, content_json, updated_at)
  - branch_nodes (id, type, label, position_json, tags_json, updated_at)
  - branch_edges (id, from_id, to_id, condition, label)
  - sync_queue (id, operation, resource_type, resource_id, payload_json, created_at)
다음 작업 전 확인: 마이그레이션 실행, CRUD 정상 동작

### 1-4. SyncEngine 구현
파일: lib/core/sync/sync_engine.dart
구현:
  - onAppStart(): manifest 비교 → pull 또는 push
  - onEdit(change): 로컬 저장 + Firebase delta + 3초 debounce Drive 저장
  - onDelta(delta): 상대방 변경사항 적용
  - resolveConflict(): updated_at 기준
테스트: test/unit/sync_engine_test.dart (목 사용)

### 1-5. FeatureFlags 구현
파일: lib/core/platform/feature_flags.dart
구현:
  - kIsWeb이면 웹 제한 적용
  - hasMoodboard, hasWorkspace, hasWidgets: exe만 true

### 1-6. Notes Feature 구현
폴더: lib/features/notes/
구현 순서:
  a. data/notes_repository.dart — Drive read/write
  b. domain/notes_provider.dart — Riverpod Notifier
  c. presentation/pages_list_screen.dart — 페이지 목록
  d. presentation/page_editor_screen.dart — appflowy_editor 연동
  e. presentation/widgets/page_tree_widget.dart — 무한 중첩 트리

appflowy_editor 연동 시 주의:
  - EditorState로 블록 관리
  - 변경 감지: editorState.transactionStream
  - 변경 발생 시 SyncEngine.onEdit() 호출

다음 작업 전 확인:
  - 페이지 생성/수정/삭제
  - 하위 페이지 생성 (무한 중첩)
  - Drive에 저장 확인
  - 앱 재시작 후 데이터 유지

### 1-7. BranchTree Feature 구현
폴더: lib/features/branch_tree/
구현 순서:
  a. data/branch_repository.dart — Drive read/write
  b. domain/branch_provider.dart — Riverpod Notifier
  c. presentation/branch_canvas_screen.dart — flutter_flow_chart 연동
  d. presentation/widgets/node_editor_dialog.dart — 노드 편집
  e. presentation/widgets/node_detail_panel.dart — 노드 클릭 시 사이드패널

flutter_flow_chart 연동 시 주의:
  - FlowChart 위젯 사용
  - 노드 위치 변경 시 SyncEngine.onEdit() 호출
  - 노드 클릭 → 연결된 page_id의 노트 페이지 열기

다음 작업 전 확인:
  - 노드 생성/이동/삭제
  - 노드 간 화살표 연결
  - 조건 태그 추가
  - 노드 클릭 → 노트 페이지 열림
  - Drive에 branch_tree.json 저장 확인

### 1-8. Firebase 협업 연동
파일: lib/core/firebase/firebase_sync.dart
구현:
  - Delta 전송
  - Delta 구독 (상대방 변경사항 수신)
  - Delta 삭제 (Drive 저장 후)

### 1-9. 협업 초대 시스템
파일: lib/features/collaboration/
구현:
  - Drive API로 폴더 공유 권한 부여
  - Firebase 멤버 등록
  - 초대 링크 생성

### 1-10. 라우팅 설정
파일: lib/main.dart + lib/shared/router.dart
라우트:
  / → 로그인 화면 (비로그인 시)
  /projects → 프로젝트 목록
  /projects/:id → 프로젝트 내부 (노트 + 분기 탭)
  /projects/:id/notes/:pageId → 노트 편집
  /projects/:id/tree → 분기 수형도

## Phase 1 완료 기준
- Google 로그인 → 자동 재인증 작동
- 노트 페이지 CRUD + 무한 중첩
- 분기 수형도 노드 CRUD + 연결
- 노드 → 노트 페이지 연결
- Drive 저장/로드
- Firebase delta 기반 실시간 협업
- GitHub Pages 배포 완료
- exe 빌드 + GitHub Releases 업로드 완료
```

---

### [phase2-creative.md](http://phase2-creative.md)

```markdown
# Phase 2: 창작 도구

## 목표
ForgeTales 스타일 창작 도구 추가.
Phase 1이 완전히 완료된 후 시작.

## 작업 순서

### 2-1. Characters Feature
폴더: lib/features/characters/
데이터: characters/{char_id}.json
기능: MBTI, 배경, 습관, 트라우마, 관계망
관계망 시각화: flutter_flow_chart 재사용 (BranchTree와 동일 위젯)

### 2-2. Wiki Feature
폴더: lib/features/wiki/
데이터: wiki/{wiki_id}.json
기능: appflowy_editor 재사용 (Notes와 동일 에디터)
내부 링크: [[페이지명]] 형식 → 해당 페이지 열기

### 2-3. Episodes Feature
폴더: lib/features/episodes/
데이터: episodes/{ep_id}.json
기능: appflowy_editor 재사용
추가: 글자 수 카운터, 타입라이터 스크롤

### 2-4. Moodboard Feature (exe 전용)
폴더: lib/features/moodboard/
FeatureFlags.hasMoodboard = false이면 잠금 UI 표시
기능: 캔버스 자유 배치, 색상/텍스트 블록, 이미지 업로드
이미지 저장: Drive의 moodboard/images/ 폴더

### 2-5. Timeline Feature
폴더: lib/features/timeline/
기능: 이벤트 추가, 캐릭터 연결, 커스텀 달력 시스템

## Phase 2 완료 기준
- 캐릭터 시트 CRUD + 관계망 시각화
- 세계관 위키 CRUD + 내부 링크
- 에피소드 에디터
- 무드보드 (exe)
- 타임라인
```

---

### [phase4-mcp.md](http://phase4-mcp.md)

```markdown
# Phase 4: MCP 서버

## 목표
Claude 앱에서 ForgeWrite 데이터에 접근하는 MCP 서버 구현.
Phase 1 이후 언제든 병행 가능 (Flutter 앱과 독립).

## 작업 순서

### 4-1. 프로젝트 생성
mcp_server/ 폴더에서:
  npm init -y
  npm install @modelcontextprotocol/sdk googleapis typescript ts-node
  tsconfig.json 설정

### 4-2. Drive 클라이언트 구현
파일: src/drive/drive_client.ts
기능: readFile, writeFile (appDataFolder 기준)
인증: 요청 헤더의 Bearer 토큰 사용

### 4-3. 툴 구현 순서

a. src/tools/notes.ts
   - read_page
   - search_pages
   - summarize_notes
   - generate_tags
   - update_page

b. src/tools/branch_tree.ts
   - read_branch_tree
   - read_subtree
   - analyze_branch_consistency  ← 핵심
   - simulate_path               ← 핵심
   - find_unreachable_nodes
   - suggest_branch

c. src/tools/characters.ts
   - read_character
   - trace_character_in_branches
   - suggest_character_traits

d. src/tools/wiki.ts
   - read_wiki
   - check_lore_consistency      ← 핵심
   - summarize_episode

### 4-4. 서버 진입점
파일: src/index.ts
- MCP Server 초기화
- 모든 툴 등록
- /health 엔드포인트 (Keep-Alive용)
- 포트: 3000

### 4-5. Railway 배포
railway.toml 작성:
  [build]
  builder = "nixpacks"
  [deploy]
  startCommand = "npm start"

### 4-6. Keep-Alive 설정
.github/workflows/mcp-keep-alive.yml:
  10분마다 /health 핑
  Railway URL을 GitHub Secrets에 저장

### 4-7. Claude 앱 연결 테스트
claude_desktop_config.json에 서버 URL 추가
Claude 앱 재시작 후 ForgeWrite 커넥터 확인
"내 프로젝트 목록 보여줘" 테스트

## Phase 4 완료 기준
- Railway 배포 완료
- Keep-Alive 작동 (슬립 없음)
- Claude 앱에서 ForgeWrite 커넥터 연결됨
- read_branch_tree, analyze_branch_consistency 정상 동작
- simulate_path로 Hemisphere 경로 시뮬레이션 성공
```

---

## 이렇게 구조화한 이유

### [CLAUDE.md](http://CLAUDE.md)를 별도 파일로 분리한 이유

Claude Code는 대화가 길어지면 초반 지시를 잊는다. `.claude/CLAUDE.md`에 핵심 판단 기준을 두면, 새 세션을 시작할 때마다 `이 파일을 먼저 읽어`라고 한 줄만 말해도 전체 맥락이 복원된다. 시스템 프롬프트와 같은 역할을 한다.

### Feature-first 폴더 구조를 선택한 이유

`lib/screens/`, `lib/models/`, `lib/services/` 같은 타입별 구조는 기능이 늘어날수록 파일을 찾기 어렵다. Feature-first는 `lib/features/notes/` 안에 data/domain/presentation이 전부 들어가서, Claude Code가 "노트 기능 수정"이라는 지시를 받으면 해당 폴더만 보면 된다. 다른 기능을 건드릴 위험이 낮아진다.

### 작업 순서를 phase 파일로 강제한 이유

Claude Code는 전체를 한 번에 만들려는 경향이 있다. phase 파일에 `반드시 이 순서로`라고 명시하고, 각 단계마다 `다음 작업 전 확인` 체크포인트를 두면 중간에 검증 없이 달려나가는 것을 막는다. Drive 연결도 안 된 상태에서 UI를 다 만들어버리는 사태를 방지한다.

### [api-contracts.md](http://api-contracts.md)로 인터페이스를 선 정의한 이유

Claude Code가 feature를 만들 때, 아직 구현 안 된 다른 레이어에 의존하는 코드를 작성해야 한다. 인터페이스가 미리 정의되어 있으면 실제 구현 없이도 올바른 signature로 코드를 작성할 수 있다. 나중에 실제 구현체를 끼워 넣기만 하면 된다.

### MCP 서버를 Flutter 앱과 완전히 분리한 이유

두 가지가 같은 레포에 있어도 폴더를 분리하면, Claude Code에게 `mcp_server/ 폴더만 작업해`라고 지시할 수 있다. Flutter 앱과 Node.js 서버가 섞이면 패키지 의존성 충돌, 빌드 오류가 발생한다. 폴더 분리로 이를 원천 차단한다.

### [data-models.md](http://data-models.md)를 별도로 둔 이유

Drive 파일 구조와 데이터 모델은 Flutter 앱과 MCP 서버가 공유한다. 이것이 두 곳에 흩어져 있으면 불일치가 생긴다. 한 곳에서 정의하고 양쪽이 참조하면 `branch_tree.json`의 필드명이 앱과 MCP 서버에서 다른 사태를 막는다.

### 테스트를 핵심 로직에만 제한한 이유

Claude Code에게 테스트를 모두 작성하라고 하면 UI 테스트까지 만들다가 시간을 다 쓴다. 실제로 버그가 치명적인 곳은 auth, sync, drive 세 곳이다. 나머지는 눈으로 확인하는 게 빠르다.

---

## Claude Code 세션 시작 템플릿

매번 새 세션을 시작할 때 이 메시지로 시작한다:

```
.claude/CLAUDE.md 파일을 먼저 읽어줘.
그 다음 .claude/context/ 폴더의 파일들을 읽어줘.
그 다음 .claude/tasks/phase1-mvp.md 를 읽고
지금 어디까지 완료됐는지 확인한 후
다음 작업인 [작업명]을 진행해줘.
```

이 한 블록으로 Claude Code는 전체 맥락을 복원하고 올바른 작업을 이어서 진행한다.

---

> 📅 작성일: 2026-05-08
> 

> 🔗 연결: ForgeWrite 시스템 설계 최종본
> 

---

## Windows exe 빌드 가이드

### Flutter 빌드 시스템 개요

Flutter는 빌드 시스템이 이미 내장되어 있다. Unity의 Build Settings, Android의 Gradle처럼 별도로 설정할 것이 거의 없다.

```bash
# 이게 전부다
flutter build windows --release
```

이 명령어 하나로 exe가 생성된다.

---

### 다른 빌드 시스템과 비교

| 항목 | Unity | Gradle (Android) | Flutter Windows |
| --- | --- | --- | --- |
| 빌드 명령 | Build Settings → Build | ./gradlew assembleRelease | flutter build windows |
| 결과물 | .exe + 폴더 | .apk / .aab | .exe + 폴더 |
| 설정 파일 | Build Settings UI | build.gradle | pubspec.yaml |
| 서명 필요 | 선택 | 필수 (Play Store) | 불필요 (비공식 배포) |
| 빌드 시간 | 수 분 | 수 분 | 1~3분 |
| 핫리로드 | 없음 | 없음 | ✅ 있음 |

---

### 빌드 결과물 구조

```
flutter build windows --release 실행 후
        ↓
build/windows/x64/runner/Release/
  ├─ forgewrite.exe          ← 실행 파일
  ├─ flutter_windows.dll     ← Flutter 런타임
  ├─ google_sign_in_windows_plugin.dll  ← 플러그인
  ├─ data/
  │    ├─ flutter_assets/    ← 앱 리소스 (폰트, 이미지 등)
  │    └─ icudtl.dat         ← 텍스트 처리 데이터
  └─ (기타 dll 파일들)
```

**중요**: Unity처럼 exe 하나짜리가 아니다. `Release/` 폴더 전체를 배포해야 한다.

```
❌ forgewrite.exe 파일 하나만 전달  → 실행 안 됨 (dll 없음)
✅ Release/ 폴더 전체 zip 압축 전달 → 정상 실행
```

---

### 개발 중 실행 방법

```bash
# Windows 앱으로 실행 (Unity의 Play 버튼과 동일)
flutter run -d windows

# 웹앱으로 실행
flutter run -d chrome

# 사용 가능한 디바이스 목록 확인
flutter devices
```

코드를 저장하면 핫리로드로 즉시 반영된다. 전체 재빌드 없이 UI 변경이 바로 보인다.

---

### 배포 방법 3단계

```
1. 빌드
   flutter build windows --release
        ↓
2. 압축
   Release/ 폴더 전체를 zip으로 압축
   → ForgeWrite-v1.0.0-windows.zip
        ↓
3. 배포
   GitHub Releases에 zip 업로드
   사용자는 다운로드 → 압축 해제 → exe 실행
```

---

### exe 단일 파일로 만들기 (선택사항)

폴더째 배포가 불편하다면 인스톨러를 만들 수 있다.

**Inno Setup 사용 시**

```
Inno Setup (무료 툴) 설치
        ↓
.iss 스크립트 작성
  → Release/ 폴더 전체를 하나의 setup.exe로 묶음
        ↓
setup.exe 하나만 배포
  → 사용자가 실행하면 자동 설치
```

초기에는 zip 배포로 충분. 사용자가 늘면 그때 Inno Setup 검토.

---

### GitHub Actions 자동 빌드

main 브랜치에 push하면 자동으로 빌드하고 GitHub Releases에 올라간다.

```yaml
# .github/workflows/deploy-windows.yml
name: Deploy Windows

on:
  push:
    branches: [main]

jobs:
  build-windows:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'

      - name: Build Windows exe
        run: flutter build windows --release

      - name: Zip Release folder
        run: |
          Compress-Archive `
            -Path build\windows\x64\runner\Release\* `
            -DestinationPath ForgeWrite-windows.zip

      - name: Upload to GitHub Releases
        uses: softprops/action-gh-release@v1
        with:
          files: ForgeWrite-windows.zip
          tag_name: v${{ github.run_number }}
```

push 한 번 → 자동 빌드 → GitHub Releases에 zip 자동 업로드.

직접 빌드 명령을 칠 필요가 없다.

---

### 웹앱과 exe 동시 빌드

```yaml
# 한 번의 push로 웹앱 + exe 동시 배포
jobs:
  # 웹앱 → GitHub Pages
  deploy-web:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter build web --release --base-href /forgewrite/
      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web

  # exe → GitHub Releases
  deploy-windows:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter build windows --release
      - name: Zip
        run: Compress-Archive -Path build\windows\x64\runner\Release\* -DestinationPath ForgeWrite-windows.zip
      - uses: softprops/action-gh-release@v1
        with:
          files: ForgeWrite-windows.zip
```

---

### 빌드 관련 자주 묻는 것

**Q. Windows가 없으면 exe를 만들 수 없나?**

GitHub Actions의 `runs-on: windows-latest`가 Windows 서버에서 빌드해준다. 본인 PC가 Mac이어도 exe 빌드 가능.

**Q. 빌드된 exe에 서명이 필요한가?**

개인/소규모 배포는 서명 없이도 된다. 다만 Windows Defender가 "알 수 없는 게시자" 경고를 띄울 수 있다. 사용자가 많아지면 코드 서명 인증서 구매 검토 (연 10~30만원).

**Q. exe 실행 시 Google 로그인 창이 어떻게 뜨나?**

시스템 기본 브라우저(Chrome, Edge 등)가 자동으로 열리면서 Google 로그인 페이지가 표시된다. 로그인 완료 후 브라우저가 닫히고 앱이 인증 완료 상태가 된다.

**Q. 업데이트는 어떻게 하나?**

초기에는 사용자가 새 버전 zip을 다운받아 덮어쓰는 방식. 사용자가 늘면 자동 업데이트 패키지(package:auto_updater) 적용 검토.

---

## 배포 방식: 폴더 zip vs 단일 exe

### 두 방식 비교

| 항목 | 폴더 zip (현재) | 단일 exe (추후) |
| --- | --- | --- |
| ------ | :--------------: | :--------------: |
| 추가 툴 필요 | ❌ 없음 | ✅ Inno Setup |
| 사용자 경험 | zip 해제 후 실행 | exe 하나 실행 |
| 시작 메뉴 등록 | ❌ | ✅ 자동 |
| 바탕화면 아이콘 | 수동 | ✅ 자동 |
| 프로그램 추가/제거 | ❌ | ✅ 등록됨 |
| 자동 업데이트 연동 | 어려움 | ✅ 용이 |
| 배포 파일 크기 | zip 그대로 | 비슷하거나 약간 큼 |
| 개발 초기 적합성 | ✅ 적합 | 나중에 전환 |

---

### 방식 1: 폴더 zip 배포 (지금 당장)

Flutter 기본 빌드 결과물을 그대로 zip으로 묶어서 배포. 추가 툴 없음.

```
flutter build windows --release
        ↓
build/windows/x64/runner/Release/ 폴더 전체 zip 압축
        ↓
ForgeWrite-v1.0-windows.zip → GitHub Releases 업로드
        ↓
사용자: zip 다운로드 → 압축 해제 → forgewrite.exe 실행
```

**폴더 구조 (사용자가 받는 것)**

```
ForgeWrite-v1.0-windows/
  ├─ forgewrite.exe       ← 이걸 실행
  ├─ flutter_windows.dll
  ├─ data/
  │    ├─ flutter_assets/
  │    └─ icudtl.dat
  └─ (기타 dll 파일들)
```

**GitHub Actions**

```yaml
- name: Build
  run: flutter build windows --release

- name: Zip
  run: |
    Compress-Archive `
      -Path build\windows\x64\runner\Release\* `
      -DestinationPath ForgeWrite-v${{ github.run_number }}-windows.zip

- name: Upload
  uses: softprops/action-gh-release@v1
  with:
    files: ForgeWrite-v${{ github.run_number }}-windows.zip
```

---

### 방식 2: 단일 exe 인스톨러 (추후 전환)

Inno Setup을 사용해 폴더 전체를 하나의 setup.exe로 패키징.

**Inno Setup이 하는 일**

```
Release/ 폴더 전체
        ↓ Inno Setup이 묶음
ForgeWrite-Setup-v1.0.exe (단일 파일)
        ↓ 사용자가 실행하면
  - C:\Program Files\ForgeWrite\ 에 자동 설치
  - 시작 메뉴에 ForgeWrite 등록
  - 바탕화면 아이콘 생성 (선택)
  - 프로그램 추가/제거에 등록
  - 제거 프로그램(uninstall.exe) 자동 생성
```

**Inno Setup 설치 및 설정**

```
1. https://jrsoftware.org/isinfo.php 에서 Inno Setup 무료 다운로드
2. 설치 후 새 스크립트 파일 생성 (.iss)
```

**스크립트 파일 (forgewrite.iss)**

```pascal
[Setup]
AppName=ForgeWrite
AppVersion=1.0
AppPublisher=개발자이름
DefaultDirName={autopf}\ForgeWrite
DefaultGroupName=ForgeWrite
OutputDir=installer
OutputBaseFilename=ForgeWrite-Setup-v1.0
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "korean"; MessagesFile: "compiler:Languages\Korean.isl"

[Tasks]
Name: "desktopicon"; Description: "바탕화면 아이콘 생성"; Flags: unchecked

[Files]
; Release 폴더 전체를 설치 대상에 포함
Source: "build\windows\x64\runner\Release\*"; \
  DestDir: "{app}"; Flags: ignoreversion recursesubdirs

[Icons]
; 시작 메뉴 아이콘
Name: "{group}\ForgeWrite"; Filename: "{app}\forgewrite.exe"
; 바탕화면 아이콘 (사용자가 선택한 경우)
Name: "{autodesktop}\ForgeWrite"; \
  Filename: "{app}\forgewrite.exe"; \
  Tasks: desktopicon

[Run]
; 설치 완료 후 바로 실행 옵션
Filename: "{app}\forgewrite.exe"; \
  Description: "ForgeWrite 바로 실행"; \
  Flags: nowait postinstall skipifsilent
```

**빌드 순서**

```
1. flutter build windows --release
2. Inno Setup에서 forgewrite.iss 열기
3. Build → Compile (단축키 F9)
4. installer/ForgeWrite-Setup-v1.0.exe 생성됨
5. GitHub Releases에 업로드
```

**GitHub Actions 자동화 (Inno Setup 포함)**

```yaml
deploy-windows-installer:
  runs-on: windows-latest
  steps:
    - uses: actions/checkout@v4
    - uses: subosito/flutter-action@v2

    - name: Flutter Build
      run: flutter build windows --release

    - name: Install Inno Setup
      run: choco install innosetup -y

    - name: Build Installer
      run: iscc forgewrite.iss

    - name: Upload Installer
      uses: softprops/action-gh-release@v1
      with:
        files: installer/ForgeWrite-Setup-v1.0.exe
```

push 한 번으로 setup.exe까지 자동 생성.

---

### 전환 시점 판단 기준

```
지금 → 폴더 zip
  이유: 추가 설정 없음, 빠른 배포, 검증 단계

아래 조건 중 하나라도 해당되면 → 단일 exe 전환
  ✅ 사용자가 "설치 방법이 불편하다" 피드백
  ✅ 사용자 100명 이상
  ✅ 자동 업데이트 기능 추가할 때
  ✅ 공식 서비스 느낌이 필요할 때
```

**전환 비용**: Inno Setup 스크립트 작성 1~2시간,

GitHub Actions 수정 30분. 어렵지 않다.

---

### Windows Defender 경고 (두 방식 공통)

코드 서명 인증서 없이 배포하면 처음 실행 시 경고가 뜬다.

```
"Windows에서 PC를 보호했습니다"
→ 추가 정보 클릭 → 실행 클릭으로 넘길 수 있음
```

| 단계 | 대응 방법 |
| --- | --- |
| 초기 (지금) | 경고 무시, README에 안내 문구 추가 |
| 사용자 증가 후 | 코드 서명 인증서 구매 (연 10~30만원) |

인증서 구매 후 빌드 시 서명하면 경고가 사라지고

"확인된 게시자" 로 표시된다.