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

### BranchTree (Drive 저장 단위)
{
  project_id: string,
  nodes: BranchNode[],
  edges: BranchEdge[],
  updated_at: ISO8601
}
