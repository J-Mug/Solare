import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/platform/feature_flags.dart';
import '../domain/moodboard_model.dart';
import '../domain/moodboard_provider.dart';

class MoodboardScreen extends ConsumerWidget {
  final String projectId;
  const MoodboardScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // exe 전용 기능 가드
    if (!FeatureFlags.hasMoodboard) {
      return Scaffold(
        appBar: AppBar(title: const Text('무드보드')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(FeatureFlags.webRestrictionMessage,
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    final async = ref.watch(moodboardProvider(projectId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('무드보드'),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            tooltip: '텍스트 추가',
            onPressed: () => _addText(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            tooltip: '색상 블록 추가',
            onPressed: () => _addColorBlock(ref),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (data) => _MoodboardCanvas(
          projectId: projectId,
          data: data,
        ),
      ),
    );
  }

  void _addText(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('텍스트 블록'),
        content: TextField(controller: ctrl, autofocus: true, maxLines: 3),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, ctrl.text),
              child: const Text('추가')),
        ],
      ),
    );
    if (text == null || text.trim().isEmpty) return;

    final item = MoodboardItem(
      id: 'mb_${DateTime.now().millisecondsSinceEpoch}',
      type: MoodboardItemType.text,
      x: 80,
      y: 80,
      content: text.trim(),
    );
    ref.read(moodboardProvider(projectId).notifier).addItem(item);
  }

  void _addColorBlock(WidgetRef ref) {
    const colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.teal,
    ];
    final color = colors[DateTime.now().millisecondsSinceEpoch % colors.length];
    final item = MoodboardItem(
      id: 'mb_${DateTime.now().millisecondsSinceEpoch}',
      type: MoodboardItemType.colorBlock,
      x: 80,
      y: 80,
      colorValue: color.value,
    );
    ref.read(moodboardProvider(projectId).notifier).addItem(item);
  }
}

class _MoodboardCanvas extends ConsumerStatefulWidget {
  final String projectId;
  final MoodboardData data;

  const _MoodboardCanvas({required this.projectId, required this.data});

  @override
  ConsumerState<_MoodboardCanvas> createState() => _MoodboardCanvasState();
}

class _MoodboardCanvasState extends ConsumerState<_MoodboardCanvas> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.items.isEmpty) {
      return const Center(
        child: Text('아이템이 없습니다.\n위 버튼으로 텍스트나 색상 블록을 추가하세요.'),
      );
    }

    return Stack(
      children: widget.data.items.map((item) => _buildItem(item)).toList(),
    );
  }

  Widget _buildItem(MoodboardItem item) {
    return Positioned(
      left: item.x,
      top: item.y,
      child: GestureDetector(
        onPanUpdate: (details) {
          ref.read(moodboardProvider(widget.projectId).notifier).updateItem(
                item.copyWith(
                  x: item.x + details.delta.dx,
                  y: item.y + details.delta.dy,
                ),
              );
        },
        onLongPress: () => _showContextMenu(item),
        child: _buildItemContent(item),
      ),
    );
  }

  Widget _buildItemContent(MoodboardItem item) {
    switch (item.type) {
      case MoodboardItemType.text:
        return Container(
          width: item.width,
          constraints: BoxConstraints(minHeight: item.height),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(2, 2))
            ],
          ),
          child: Text(item.content),
        );
      case MoodboardItemType.colorBlock:
        return Container(
          width: item.width,
          height: item.height,
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(2, 2))
            ],
          ),
        );
      case MoodboardItemType.imageRef:
        return Container(
          width: item.width,
          height: item.height,
          color: Colors.grey.shade200,
          child: const Center(child: Icon(Icons.image, color: Colors.grey)),
        );
    }
  }

  void _showContextMenu(MoodboardItem item) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('삭제', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                ref
                    .read(moodboardProvider(widget.projectId).notifier)
                    .removeItem(item.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
