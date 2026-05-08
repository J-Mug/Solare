새 feature 폴더 구조를 생성합니다.

$ARGUMENTS: feature 이름 (예: `characters`, `wiki`, `episodes`)

생성할 파일들:
```
lib/features/$ARGUMENTS/
  data/
    {name}_repository.dart          ← abstract interface만
    {name}_repository_impl.dart     ← Drive read/write stub (TODO 주석)
  domain/
    {name}_model.dart               ← 데이터 모델 (data-models.md 기준)
    {name}_provider.dart            ← Riverpod StateNotifier stub
  presentation/
    {name}_screen.dart              ← 빈 ConsumerWidget
```

규칙:
- 구현체는 TODO 주석으로 stub만 작성
- interface는 `.claude/context/api-contracts.md` 패턴 따름
- feature 간 직접 import 없음 — core/ 경유만
- Drive 경로: `projects/{projectId}/{feature_name}/{id}.json`

생성 후 `.claude/tasks/phase1-mvp.md` 또는 roadmap.md에서 해당 항목 상태를 업데이트하세요.
