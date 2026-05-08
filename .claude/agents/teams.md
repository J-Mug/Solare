# 에이전트 팀 구성

## Phase 1 MVP 팀

### 팀 A: 데이터 레이어 팀
동시 진행 가능한 독립 작업들.
- `drive-sync` 에이전트 → Drive/Firebase 구현
- 담당: core/drive/, core/sync/, core/firebase/

### 팀 B: Feature 팀
데이터 레이어 완료 후 feature별 병렬 진행.
- `flutter-ui` 에이전트 → notes 화면
- `flutter-ui` 에이전트 → branch_tree 화면
- 각 feature는 독립적이라 동시 작업 가능

### 팀 C: 검증 팀
각 팀 작업 완료 후 실행.
- `architect` 에이전트 → 아키텍처 규칙 검증
- `/arch-check` 스킬 실행

## Phase 2 창작 도구 팀

### 병렬 진행 가능 (서로 독립)
- characters feature
- wiki feature
- episodes feature

### 순서 필요
- timeline → characters 완료 후 (캐릭터 연결 필요)
- moodboard → Drive 이미지 업로드 패턴 확립 후

## Phase 4 MCP 팀 (Flutter와 완전 독립)

### Flutter 팀과 동시 진행 가능
- `mcp-server` 에이전트가 단독으로 `mcp_server/` 폴더 담당
- Flutter 앱 Phase 1 완료 후 병행 시작 권장 (Drive 파일 구조 확정 후)

## 팀 사용법

병렬 작업이 필요할 때 Agent 툴을 사용합니다:

```
# 예시: notes와 branch_tree를 동시에 작업
Agent(subagent_type='default', prompt='[flutter-ui 에이전트 역할로] notes feature 화면 구현...')
Agent(subagent_type='default', prompt='[flutter-ui 에이전트 역할로] branch_tree 화면 구현...')
```

단, feature 간 의존성이 있으면 반드시 순서대로 진행합니다.
