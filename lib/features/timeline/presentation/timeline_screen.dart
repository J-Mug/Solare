import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/timeline_model.dart';
import '../domain/timeline_provider.dart';

class TimelineScreen extends ConsumerWidget {
  final String projectId;
  const TimelineScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(timelineProvider(projectId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('타임라인'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDialog(context, ref),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (data) {
          if (data.events.isEmpty) {
            return const Center(
                child: Text('이벤트가 없습니다.\n오른쪽 위 버튼으로 추가하세요.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: data.events.length,
            separatorBuilder: (_, __) => const SizedBox(
              height: 0,
              child: Row(
                children: [
                  SizedBox(width: 32),
                  VerticalDivider(width: 2, color: Colors.grey),
                ],
              ),
            ),
            itemBuilder: (context, i) {
              final event = data.events[i];
              return _EventTile(
                event: event,
                projectId: projectId,
                onEdit: () => _showEditDialog(context, ref, event),
                onDelete: () => ref
                    .read(timelineProvider(projectId).notifier)
                    .removeEvent(event.id),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    _showEventDialog(context, ref, null);
  }

  void _showEditDialog(
      BuildContext context, WidgetRef ref, TimelineEvent event) {
    _showEventDialog(context, ref, event);
  }

  void _showEventDialog(
      BuildContext context, WidgetRef ref, TimelineEvent? existing) {
    final titleCtrl =
        TextEditingController(text: existing?.title ?? '');
    final dateCtrl =
        TextEditingController(text: existing?.date ?? '');
    final descCtrl =
        TextEditingController(text: existing?.description ?? '');
    final orderCtrl = TextEditingController(
        text: existing?.sortOrder.toString() ?? '0');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? '이벤트 추가' : '이벤트 편집'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                autofocus: true,
                decoration: const InputDecoration(labelText: '제목'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dateCtrl,
                decoration: const InputDecoration(
                  labelText: '날짜',
                  hintText: '예: 3년 2월 / Day 42 / 2025-03-01',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: '설명'),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: orderCtrl,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: '정렬 순서 (숫자)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              if (title.isEmpty) return;
              final date = dateCtrl.text.trim();
              final sortOrder = int.tryParse(orderCtrl.text) ?? 0;

              if (existing == null) {
                final event = TimelineEvent.create(
                  projectId: projectId,
                  title: title,
                  date: date,
                  sortOrder: sortOrder,
                ).copyWith(description: descCtrl.text.trim());
                ref
                    .read(timelineProvider(projectId).notifier)
                    .addEvent(event);
              } else {
                final updated = existing.copyWith(
                  title: title,
                  date: date,
                  description: descCtrl.text.trim(),
                  sortOrder: sortOrder,
                );
                ref
                    .read(timelineProvider(projectId).notifier)
                    .updateEvent(updated);
              }
              Navigator.pop(context);
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}

class _EventTile extends ConsumerWidget {
  final TimelineEvent event;
  final String projectId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EventTile({
    required this.event,
    required this.projectId,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 타임라인 도트
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(top: 4, right: 16, left: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        // 내용
        Expanded(
          child: Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (event.date.isNotEmpty) ...[
                        Text(
                          event.date,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(event.title,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == 'edit') onEdit();
                          if (v == 'delete') onDelete();
                          if (v == 'note' && event.connectedPageId != null) {
                            context.go(
                                '/projects/$projectId/notes/${event.connectedPageId}');
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                              value: 'edit', child: Text('편집')),
                          if (event.connectedPageId != null)
                            const PopupMenuItem(
                                value: 'note', child: Text('연결 노트 열기')),
                          const PopupMenuItem(
                              value: 'delete',
                              child: Text('삭제',
                                  style: TextStyle(color: Colors.red))),
                        ],
                      ),
                    ],
                  ),
                  if (event.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(event.description,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
