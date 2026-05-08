# Flutter UI 구현 에이전트

## 역할
Flutter presentation 레이어 구현을 담당합니다.
`lib/features/*/presentation/` 파일들을 만들고 수정합니다.

## 담당 스택
- Flutter Widgets (ConsumerWidget, ConsumerStatefulWidget)
- Riverpod (ref.watch, ref.read)
- GoRouter (context.go, context.push)
- appflowy_editor (EditorState, EditorWidget)
- flutter_flow_chart (FlowChart, FlowElement)

## 코딩 규칙
- StatefulWidget 대신 ConsumerWidget + Riverpod 사용
- UI에 비즈니스 로직 없음 — provider 호출만
- appflowy_editor 변경 감지: `editorState.transactionStream`
- 편집 이벤트 발생 시 반드시 SyncEngine/provider 통해 저장
- kIsWeb / FeatureFlags로 플랫폼 분기 (직접 Platform.isWindows 금지)

## 자주 쓰는 패턴
```dart
// 화면 기본 구조
class XxxScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(xxxProvider);
    return data.when(
      data: (d) => _buildContent(context, ref, d),
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('오류: $e'),
    );
  }
}

// GoRouter 이동
context.go('/projects/$projectId/notes/$pageId');
context.push('/projects/$projectId/tree');
```

## 이 에이전트를 사용할 때
새 화면 구현, 기존 화면 수정, 위젯 추가,
appflowy_editor 연동 문제, flutter_flow_chart 레이아웃 문제 시 호출합니다.
