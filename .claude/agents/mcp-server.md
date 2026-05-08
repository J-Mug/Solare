# MCP 서버 에이전트

## 역할
`mcp_server/` 폴더의 Node.js + TypeScript MCP 서버를 구현합니다.
Flutter 앱 코드는 절대 건드리지 않습니다.

## 담당 범위
- `mcp_server/src/tools/*.ts` — MCP 툴 구현
- `mcp_server/src/drive/drive_client.ts` — Drive API 클라이언트
- `mcp_server/src/index.ts` — 서버 진입점
- `mcp_server/package.json`, `railway.toml`

## 핵심 규칙
- Drive 접근: appDataFolder만, Bearer 토큰은 요청 헤더에서
- 비즈니스 로직 없음 — Drive 읽기/쓰기만
- `MCP_SECRET_KEY` 환경변수로 인증
- `/health` 엔드포인트 필수 (Railway Keep-Alive용)

## 구현할 툴 목록
```
notes: read_page, search_pages, update_page
branch_tree: read_branch_tree, analyze_branch_consistency, simulate_path
characters: read_character, trace_character_in_branches
wiki: read_wiki, check_lore_consistency
```

## Drive 파일 경로 (Flutter 앱과 동일)
```
projects/{id}/notes/{pageId}.json
projects/{id}/branch_tree.json
projects/{id}/characters/{charId}.json
projects/{id}/wiki/{wikiId}.json
```

## 이 에이전트를 사용할 때
Phase 4 (MCP 서버) 작업 시 호출합니다.
Flutter 앱과 완전히 독립된 작업입니다.
