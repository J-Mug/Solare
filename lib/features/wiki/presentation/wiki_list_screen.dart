import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/wiki_model.dart';
import '../domain/wiki_provider.dart';

class WikiListScreen extends ConsumerWidget {
  final String projectId;
  const WikiListScreen({super.key, required this.projectId});

  static const _categories = {
    'world': '세계관',
    'faction': '세력',
    'place': '장소',
    'item': '아이템',
    'event': '사건',
    'other': '기타',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(wikiProvider(projectId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('위키'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateDialog(context, ref),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(
                child: Text('위키 항목이 없습니다.\n오른쪽 위 버튼으로 추가하세요.'));
          }
          // 카테고리별 그룹
          final grouped = <String, List<WikiEntry>>{};
          for (final e in entries) {
            (grouped[e.category] ??= []).add(e);
          }
          return ListView(
            padding: const EdgeInsets.all(8),
            children: grouped.entries.map((g) {
              return ExpansionTile(
                title:
                    Text(_categories[g.key] ?? g.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                initiallyExpanded: true,
                children: g.value
                    .map((e) => ListTile(
                          title: Text(e.title),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () =>
                                _confirmDelete(context, ref, e.id, e.title),
                          ),
                          onTap: () => context.go(
                              '/projects/$projectId/wiki/${e.id}'),
                        ))
                    .toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    String category = 'other';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: const Text('새 위키 항목'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                autofocus: true,
                decoration: const InputDecoration(hintText: '제목'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: category,
                items: _categories.entries
                    .map((e) =>
                        DropdownMenuItem(value: e.key, child: Text(e.value)))
                    .toList(),
                onChanged: (v) => setS(() => category = v!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleCtrl.text.trim();
                if (title.isEmpty) return;
                ref
                    .read(wikiProvider(projectId).notifier)
                    .createEntry(title, category: category);
                Navigator.pop(ctx);
              },
              child: const Text('만들기'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, String id, String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('항목 삭제'),
        content: Text('"$title"를 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(wikiProvider(projectId).notifier).deleteEntry(id);
              Navigator.pop(context);
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
