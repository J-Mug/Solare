import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';
import 'package:go_router/go_router.dart';
import '../domain/branch_node_data.dart';
import '../domain/branch_provider.dart';
import 'widgets/node_editor_dialog.dart';

class BranchCanvasScreen extends ConsumerWidget {
  final String projectId;

  const BranchCanvasScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDashboard = ref.watch(branchProvider(projectId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('분기 수형도'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: '빈 곳을 클릭해 노드 추가\n핸들러를 드래그해 연결',
            onPressed: () => _showHelp(context),
          ),
        ],
      ),
      body: asyncDashboard.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (dashboard) => _BranchCanvas(
          projectId: projectId,
          dashboard: dashboard,
        ),
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('사용 방법'),
        content: const Text(
          '• 빈 캔버스 탭 → 노드 추가\n'
          '• 노드 탭 → 상세 보기 / 연결된 노트 열기\n'
          '• 노드 길게 누르기 → 편집 / 삭제\n'
          '• 노드 테두리 핸들러 드래그 → 노드 연결\n'
          '• 핀치로 줌 인/아웃',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}

class _BranchCanvas extends ConsumerWidget {
  final String projectId;
  final Dashboard<BranchNodeData> dashboard;

  const _BranchCanvas({
    required this.projectId,
    required this.dashboard,
  });

  Color _colorForType(BranchNodeType type) {
    switch (type) {
      case BranchNodeType.event:
        return Colors.blue.shade100;
      case BranchNodeType.choice:
        return Colors.orange.shade100;
      case BranchNodeType.condition:
        return Colors.purple.shade100;
      case BranchNodeType.result:
        return Colors.green.shade100;
    }
  }

  Color _borderForType(BranchNodeType type) {
    switch (type) {
      case BranchNodeType.event:
        return Colors.blue;
      case BranchNodeType.choice:
        return Colors.orange;
      case BranchNodeType.condition:
        return Colors.purple;
      case BranchNodeType.result:
        return Colors.green;
    }
  }

  ElementKind _kindForType(BranchNodeType type) {
    switch (type) {
      case BranchNodeType.event:
        return ElementKind.rectangle;
      case BranchNodeType.choice:
        return ElementKind.diamond;
      case BranchNodeType.condition:
        return ElementKind.parallelogram;
      case BranchNodeType.result:
        return ElementKind.oval;
    }
  }

  void _addNode(
    BuildContext context,
    WidgetRef ref,
    Offset position,
  ) async {
    final result = await showDialog<({String label, BranchNodeData data})>(
      context: context,
      builder: (_) => const NodeEditorDialog(title: '노드 추가'),
    );
    if (result == null) return;

    final element = FlowElement<BranchNodeData>(
      position: position,
      size: const Size(160, 60),
      text: result.label,
      kind: _kindForType(result.data.type),
      backgroundColor: _colorForType(result.data.type),
      borderColor: _borderForType(result.data.type),
      borderThickness: 2,
      elementData: result.data,
    );

    dashboard.addElement(element);
    ref.read(branchProvider(projectId).notifier).onChanged();
  }

  void _onElementPressed(
    BuildContext context,
    WidgetRef ref,
    FlowElement<BranchNodeData> element,
  ) {
    final data = element.elementData;
    if (data?.connectedPageId != null) {
      context.go('/projects/$projectId/notes/${data!.connectedPageId}');
      return;
    }
    _showNodeDetail(context, ref, element);
  }

  void _onElementLongPressed(
    BuildContext context,
    WidgetRef ref,
    FlowElement<BranchNodeData> element,
  ) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('편집'),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('삭제', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );

    if (action == 'edit' && context.mounted) {
      _editNode(context, ref, element);
    } else if (action == 'delete') {
      dashboard.removeElement(element);
      ref.read(branchProvider(projectId).notifier).onChanged();
    }
  }

  void _editNode(
    BuildContext context,
    WidgetRef ref,
    FlowElement<BranchNodeData> element,
  ) async {
    final result = await showDialog<({String label, BranchNodeData data})>(
      context: context,
      builder: (_) => NodeEditorDialog(
        title: '노드 편집',
        initial: element.elementData,
      ),
    );
    if (result == null) return;

    element.setText(result.label);
    element.setBackgroundColor(_colorForType(result.data.type));
    element.setBorderColor(_borderForType(result.data.type));
    element.setElementData(result.data);
    ref.read(branchProvider(projectId).notifier).onChanged();
  }

  void _showNodeDetail(
    BuildContext context,
    WidgetRef ref,
    FlowElement<BranchNodeData> element,
  ) {
    final data = element.elementData;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(element.text),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data != null) ...[
              Chip(label: Text(data.type.label)),
              if (data.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(data.description),
              ],
              if (data.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: data.tags
                      .map((t) => Chip(
                            label: Text(t, style: const TextStyle(fontSize: 12)),
                            visualDensity: VisualDensity.compact,
                          ))
                      .toList(),
                ),
              ],
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlowChart<BranchNodeData>(
      dashboard: dashboard,
      onDashboardTapped: (context, position) =>
          _addNode(context, ref, position),
      onElementPressed: (context, _, element) =>
          _onElementPressed(context, ref, element),
      onElementLongPressed: (context, _, element) =>
          _onElementLongPressed(context, ref, element),
      onNewConnection: (src, dest) =>
          ref.read(branchProvider(projectId).notifier).onChanged(),
    );
  }
}
