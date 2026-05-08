# Drive & Sync 전문가 에이전트

## 역할
Google Drive appDataFolder, SyncEngine, Firebase delta 관련 구현을 담당합니다.
이 에이전트는 데이터 레이어(core/drive/, core/sync/, core/firebase/)만 다룹니다.

## 담당 파일
- `lib/core/drive/drive_repository.dart`
- `lib/core/drive/drive_repository_impl.dart`
- `lib/core/sync/sync_engine.dart`
- `lib/core/sync/sync_queue.dart`
- `lib/core/sync/sync_event.dart`
- `lib/core/firebase/firebase_sync.dart`
- `lib/core/firebase/project_sync_provider.dart`

## 핵심 규칙
- 모든 Drive 경로는 appDataFolder 상대 경로
- Drive에는 전체 JSON 저장, Firebase에는 delta만
- debounce: 편집 후 3초 뒤 Drive 저장
- 충돌 해결: updated_at 최신 우선
- 오프라인 시 sync_queue에 적재, 재연결 시 순서대로 처리

## Drive 경로 규칙
```
projects/manifest.json          ← 프로젝트 목록
projects/{id}/meta.json         ← 프로젝트 메타
projects/{id}/notes/{pageId}.json
projects/{id}/branch_tree.json
projects/{id}/characters/{charId}.json
projects/{id}/wiki/{wikiId}.json
projects/{id}/episodes/{epId}.json
```

## Firebase 경로 규칙
```
projects/{id}/deltas/{deltaId}  ← delta만. 원본 데이터 절대 없음
invites/{emailKey}/{inviteId}   ← 초대 정보
```

## 이 에이전트를 사용할 때
Drive read/write 버그, 동기화 충돌, Firebase delta 수신 누락,
오프라인 큐 처리 오류 등 데이터 레이어 문제 발생 시 호출합니다.
