import 'package:flutter/material.dart';
import '../../domain/branch_node_data.dart';

class NodeEditorDialog extends StatefulWidget {
  final BranchNodeData? initial;
  final String title;

  const NodeEditorDialog({
    super.key,
    this.initial,
    required this.title,
  });

  @override
  State<NodeEditorDialog> createState() => _NodeEditorDialogState();
}

class _NodeEditorDialogState extends State<NodeEditorDialog> {
  late TextEditingController _labelController;
  late TextEditingController _descController;
  late TextEditingController _tagsController;
  late BranchNodeType _type;

  @override
  void initState() {
    super.initState();
    _type = widget.initial?.type ?? BranchNodeType.event;
    _labelController = TextEditingController();
    _descController =
        TextEditingController(text: widget.initial?.description ?? '');
    _tagsController = TextEditingController(
      text: widget.initial?.tags.join(', ') ?? '',
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _descController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  List<String> get _parsedTags => _tagsController.text
      .split(',')
      .map((t) => t.trim())
      .where((t) => t.isNotEmpty)
      .toList();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Node type selector
            SegmentedButton<BranchNodeType>(
              segments: BranchNodeType.values
                  .map((t) => ButtonSegment(
                        value: t,
                        label: Text(t.label, style: const TextStyle(fontSize: 12)),
                      ))
                  .toList(),
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.first),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _labelController,
              decoration: const InputDecoration(
                labelText: '노드 이름',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: '설명 (선택)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: '태그 (쉼표로 구분)',
                border: OutlineInputBorder(),
                hintText: '조건1, 조건2',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            final label = _labelController.text.trim();
            if (label.isEmpty) return;
            Navigator.pop(context, (
              label: label,
              data: BranchNodeData(
                type: _type,
                description: _descController.text.trim(),
                tags: _parsedTags,
              ),
            ));
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}
