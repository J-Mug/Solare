import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/episode_provider.dart';

class EpisodesListScreen extends ConsumerWidget {
  final String projectId;
  const EpisodesListScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(episodesProvider(projectId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('에피소드'),
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
        data: (episodes) => episodes.isEmpty
            ? const Center(
                child: Text('에피소드가 없습니다.\n오른쪽 위 버튼으로 추가하세요.'))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: episodes.length,
                itemBuilder: (context, i) {
                  final ep = episodes[i];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(ep.chapterNumber > 0
                          ? '${ep.chapterNumber}'
                          : '?'),
                    ),
                    title: Text(ep.title),
                    subtitle: ep.wordCount > 0
                        ? Text('${ep.wordCount}자')
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () =>
                          _confirmDelete(context, ref, ep.id, ep.title),
                    ),
                    onTap: () => context.go(
                        '/projects/$projectId/episodes/${ep.id}'),
                  );
                },
              ),
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final chapterCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('새 에피소드'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              autofocus: true,
              decoration: const InputDecoration(hintText: '제목'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: chapterCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: '회차 번호 (선택)'),
            ),
          ],
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
              final ch = int.tryParse(chapterCtrl.text.trim()) ?? 0;
              ref
                  .read(episodesProvider(projectId).notifier)
                  .createEpisode(title, chapterNumber: ch);
              Navigator.pop(context);
            },
            child: const Text('만들기'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, String id, String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('에피소드 삭제'),
        content: Text('"$title"를 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref
                  .read(episodesProvider(projectId).notifier)
                  .deleteEpisode(id);
              Navigator.pop(context);
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
