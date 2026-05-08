import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/characters_provider.dart';

class CharactersListScreen extends ConsumerWidget {
  final String projectId;
  const CharactersListScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(charactersProvider(projectId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('캐릭터'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showCreateDialog(context, ref),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (chars) => chars.isEmpty
            ? const Center(child: Text('캐릭터가 없습니다.\n오른쪽 위 버튼으로 추가하세요.'))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: chars.length,
                itemBuilder: (context, i) {
                  final c = chars[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text(c.name[0])),
                    title: Text(c.name),
                    subtitle: c.mbti != null ? Text(c.mbti!) : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _confirmDelete(context, ref, c.id, c.name),
                    ),
                    onTap: () => context.go(
                        '/projects/$projectId/characters/${c.id}'),
                  );
                },
              ),
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('새 캐릭터'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: '이름'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = ctrl.text.trim();
              if (name.isEmpty) return;
              ref
                  .read(charactersProvider(projectId).notifier)
                  .createCharacter(name);
              Navigator.pop(context);
            },
            child: const Text('만들기'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, String id, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('캐릭터 삭제'),
        content: Text('"$name"를 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref
                  .read(charactersProvider(projectId).notifier)
                  .deleteCharacter(id);
              Navigator.pop(context);
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
