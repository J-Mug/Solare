# Solare 전체 개발 로드맵 (TODO)

> 최종 설계 기준: 2026-05-08
> 현재 진행: Phase 1 완료 (코드), 배포 파이프라인 구성 완료

---

## Phase 0 — 프로젝트 셋업

- [x] Flutter 프로젝트 생성 (web + windows)
- [x] 패키지 추가 및 의존성 해결
  - [x] appflowy_editor ^6.2.0 (4.x → 업그레이드)
  - [x] flutter_flow_chart ^4.1.1 (0.0.9 존재 안 함)
- [x] 폴더 구조 생성 (feature-first)
- [x] CLAUDE.md / context/ / tasks/ 하네스 구성
- [ ] GitHub Repository 생성
- [x] GitHub Actions 설정 (deploy-web, deploy-windows)
- [x] 개인정보처리방침 페이지 (web/privacy.html)

---

## Phase 1 — MVP (노트 + 분기 수형도)

> 목표: Hemisphere 작업을 이 앱 하나에서 할 수 있는 상태

### 인증 & 인프라
- [x] 1-1. AuthService
  - [x] 웹: google_sign_in (kIsWeb 분기)
  - [x] Windows: googleapis_auth clientViaUserConsent
  - [x] AuthUser 공통 모델
  - [x] flutter_secure_storage 토큰 저장
  - [x] Windows 로그인 실제 동작 확인
  - [ ] 웹(Chrome) 로그인 확인
  - [ ] 자동 재인증 (signInSilently) 동작 확인

- [x] 1-2. DriveRepository
  - [x] appDataFolder 기준 CRUD
  - [x] stream.toBytes() 패치
  - [ ] 실제 Drive에 파일 쓰기/읽기 확인

- [ ] 1-3. LocalDatabase (Drift)
  - [ ] pages 테이블
  - [ ] branch_nodes 테이블
  - [ ] branch_edges 테이블
  - [ ] sync_queue 테이블
  - [ ] 마이그레이션 실행 확인

- [x] 1-4. SyncEngine
  - [x] debounce 3초 Drive 저장
  - [ ] onAppStart manifest 비교 (pull/push)
  - [ ] Firebase delta 실제 연결

- [x] 1-5. FeatureFlags
  - [x] kIsWeb 기반 hasMoodboard / hasWorkspace / hasWidgets

- [x] 1-8. Firebase 연동
  - [x] firebase_options.dart (웹/데스크톱 설정)
  - [x] firebase_config.dart 업데이트
  - [x] firebase_sync.dart (SyncDelta 전송/수신/삭제)
  - [ ] 실제 Firebase 연결 동작 확인
  - [ ] Realtime DB 보안 규칙 설정

### 노트 시스템
- [x] 1-6. Notes Feature
  - [x] page_model.dart
  - [x] notes_repository.dart + impl
  - [x] notes_provider.dart (Riverpod)
  - [x] pages_list_screen.dart (트리 뷰)
  - [x] page_editor_screen.dart (AppFlowy 에디터)
  - [x] page_tree_widget.dart (무한 중첩)
  - [ ] 페이지 생성 → Drive 저장 확인
  - [ ] 앱 재시작 후 데이터 유지 확인
  - [ ] 하위 페이지 무한 중첩 동작 확인

### 분기 수형도
- [x] 1-7. BranchTree Feature
  - [x] branch_node_data.dart (BranchNodeData + Serializer)
  - [x] branch_repository.dart + impl
  - [x] branch_provider.dart (Riverpod StateNotifier)
  - [x] branch_canvas_screen.dart (FlowChart 연동)
  - [x] node_editor_dialog.dart
  - [x] 라우터 연결 (/projects/:id/tree)
  - [ ] 노드 생성/이동/삭제 동작 확인
  - [ ] 노드 간 화살표 연결 확인
  - [ ] Drive branch_tree.json 저장 확인
  - [ ] 노드 클릭 → 연결된 노트 열기 확인

### 협업
- [x] 1-9. 협업 초대 시스템
  - [x] 프로젝트 유형 선택 (개인 / 협업)
  - [ ] Firebase 설정 입력 UI (향후 — 현재 공유 Firebase 사용)
  - [x] 팀원 이메일 입력 → Firebase invites에 초대 기록
  - [x] 앱 시작 시 초대 감지 → 알림 팝업
  - [x] 수락 시 프로젝트 로컬 저장
  - [ ] 프로젝트별 Firebase 자동 전환 (향후)

- [x] SyncEngine + FirebaseSync 실제 연결
  - [x] 편집 시 pushDelta 호출
  - [x] incomingDeltas 구독 → 화면 반영
  - [x] Drive 저장 후 clearMyDeltas 호출

### 라우팅 & UI
- [x] 1-10. 기본 라우팅
  - [x] / → 로그인
  - [x] /projects → 프로젝트 목록
  - [x] /projects/:id → 프로젝트 상세
  - [x] /projects/:id/notes → 노트 목록
  - [x] /projects/:id/notes/:pageId → 에디터
  - [x] /projects/:id/tree → 분기 수형도
  - [x] 로그인 후 자동 리다이렉트 (GoRouter routerProvider + refreshListenable)
  - [x] 프로젝트 생성 UI (이름 입력, 유형 선택)
  - [x] 프로젝트 목록 Drive에서 로드

### Phase 1 완료 기준
- [ ] Google 로그인 → 자동 재인증 동작 (코드 완료, 실제 확인 필요)
- [ ] 노트 CRUD + 무한 중첩 + Drive 저장 (코드 완료, 실제 확인 필요)
- [ ] 분기 수형도 노드 CRUD + 연결 + Drive 저장 (코드 완료, 실제 확인 필요)
- [ ] 노드 → 노트 페이지 연결 (코드 완료, 실제 확인 필요)
- [ ] Firebase delta 실시간 협업 (코드 완료, 실제 확인 필요)
- [ ] GitHub Pages 배포 (Actions 준비 완료, GitHub 레포 필요)
- [ ] exe GitHub Releases 배포 (Actions 준비 완료, GitHub 레포 필요)

---

## Phase 2 — 창작 도구

> Phase 1 완전 완료 후 시작

- [ ] 2-1. Characters Feature
  - [ ] character_model.dart (MBTI, 배경, 습관, 트라우마, 관계)
  - [ ] characters_repository.dart + impl
  - [ ] character_editor_screen.dart
  - [ ] 관계망 시각화 (flutter_flow_chart 재사용)

- [ ] 2-2. Wiki Feature
  - [ ] wiki_model.dart
  - [ ] wiki_repository.dart + impl
  - [ ] wiki_editor_screen.dart (appflowy_editor 재사용)
  - [ ] [[내부 링크]] 파싱 및 이동

- [ ] 2-3. Episodes Feature
  - [ ] episode_model.dart
  - [ ] episode_editor_screen.dart (appflowy_editor 재사용)
  - [ ] 글자 수 카운터
  - [ ] 타이프라이터 스크롤

- [ ] 2-4. Moodboard Feature (exe 전용)
  - [ ] FeatureFlags.hasMoodboard 체크
  - [ ] 캔버스 자유 배치
  - [ ] 색상/텍스트 블록
  - [ ] 이미지 업로드 → Drive moodboard/images/

- [ ] 2-5. Timeline Feature
  - [ ] timeline_model.dart
  - [ ] 이벤트 추가/수정/삭제
  - [ ] 캐릭터 연결
  - [ ] 커스텀 달력 시스템

- [ ] 2-6. Hemisphere 전용 기능
  - [ ] 플레이어 상태 태그 추적 시스템
    - [ ] 노드에 태그 부여/제거 설정
    - [ ] 태그 조건 분기 시각화 (회색 ↔ 활성)
    - [ ] 전역 태그 현황판
  - [ ] 회차 레이어 뷰 (1회차 / 2회차 토글)
  - [ ] 월드 상태 변수 대시보드

### Phase 2 완료 기준
- [ ] 캐릭터 시트 CRUD + 관계망
- [ ] 위키 CRUD + 내부 링크
- [ ] 에피소드 에디터
- [ ] 무드보드 (exe)
- [ ] 타임라인

---

## Phase 3 — 완성도

- [ ] 3-1. 테마 커스터마이징 (exe 전체, 웹 기본)
- [ ] 3-2. 버전 스냅샷 고도화
  - [ ] 스냅샷 생성/복원
  - [ ] diff 뷰 (삭제 빨강, 추가 초록, 변경 노란색)
- [ ] 3-3. 프로젝트 전체 통합 검색
  - [ ] 노트 / 캐릭터 / 위키 / 분기 노드 통합
  - [ ] 카테고리별 결과 분류
- [ ] 3-4. 인물 관계 타임라인 (동적)
  - [ ] 시간 슬라이더
  - [ ] 분기별 시뮬레이션
- [ ] 3-5. 에피소드 분량 히트맵
- [ ] 3-6. 다국어 (한/영)
- [ ] 3-7. 성능 최적화
- [ ] 3-8. Drive Watch API (변경 감지 자동 로드)

---

## Phase 4 — MCP 서버

> Phase 1 완료 후 병행 가능

- [ ] 4-1. mcp_server/ 프로젝트 생성
  - [ ] Node.js + TypeScript 설정
  - [ ] @modelcontextprotocol/sdk 설치
  - [ ] railway.toml 작성

- [ ] 4-2. Drive 클라이언트 (TypeScript)
  - [ ] readFile / writeFile (appDataFolder)
  - [ ] Bearer 토큰 인증

- [ ] 4-3. MCP 툴 구현
  - [ ] notes.ts: read_page, search_pages, summarize_notes, generate_tags, update_page
  - [ ] branch_tree.ts: read_branch_tree, read_subtree, analyze_branch_consistency, simulate_path, find_unreachable_nodes, suggest_branch
  - [ ] characters.ts: read_character, trace_character_in_branches, suggest_character_traits
  - [ ] wiki.ts: read_wiki, check_lore_consistency, summarize_episode

- [ ] 4-4. 서버 진입점 (index.ts)
  - [ ] 모든 툴 등록
  - [ ] /health 엔드포인트
  - [ ] MCP_SECRET_KEY 인증
  - [ ] KST 활성 시간 체크 (09~13, 13~17, 20~02)

- [ ] 4-5. Railway 배포
  - [ ] railway.toml 설정
  - [ ] 환경변수 설정 (MCP_SECRET_KEY)
  - [ ] 배포 확인

- [ ] 4-6. GitHub Actions Keep-Alive
  - [ ] mcp-keep-alive.yml 작성
  - [ ] KST 활성 시간대 cron 설정
  - [ ] Railway URL GitHub Secrets 등록

- [ ] 4-7. Claude 앱 연결 테스트
  - [ ] claude_desktop_config.json 설정
  - [ ] ForgeWrite 커넥터 연결 확인
  - [ ] 주요 툴 동작 확인

### Phase 4 완료 기준
- [ ] Railway 배포 + Keep-Alive 동작
- [ ] Claude 앱에서 ForgeWrite 연결
- [ ] read_branch_tree, analyze_branch_consistency 동작
- [ ] simulate_path로 Hemisphere 경로 시뮬레이션 성공

---

## Phase 5 — 배포 & 공개

- [ ] GitHub Pages 웹앱 배포
  - [ ] deploy-web.yml GitHub Actions
  - [ ] base-href 설정
  - [ ] OAuth 동의 화면 프로덕션 전환
  - [ ] Google Drive API 검수 신청

- [ ] exe GitHub Releases 배포
  - [ ] deploy-windows.yml GitHub Actions
  - [ ] Release/ 폴더 zip 압축 자동화
  - [ ] Windows Defender 경고 안내 README

- [ ] 템플릿 시스템 (Phase 4 이후)
  - [ ] template.json 포맷 정의
  - [ ] 내보내기 기능 (내용 제거 + 구조만)
  - [ ] 링크 임포트 기능
  - [ ] forgewrite-templates GitHub 레포

---

## Phase 6 — 모바일 (조건부)

> 사용자 충분히 증가 시 검토

- [ ] iOS 빌드 설정
- [ ] Android 빌드 설정
- [ ] App Store / Play Store 등록
