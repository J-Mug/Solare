import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/app_layout.dart';
import '../domain/notes_provider.dart';
import 'widgets/page_tree_widget.dart';

/// Shows the root-level pages for a project in a tree structure.
class PagesListScreen extends ConsumerWidget {
  final String projectId;

  const PagesListScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppLayout(
      title: 'Notes',
      showProjectSidebar: true,
      projectId: projectId,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Text(
                  '페이지',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('새 페이지'),
                  onPressed: () => _createPage(context, ref),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Page tree
          Expanded(
            child: SingleChildScrollView(
              child: PageTreeWidget(projectId: projectId),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createPage(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(notesControllerProvider.notifier);
    final newPage = await controller.createPage(projectId);
    if (newPage != null && context.mounted) {
      context.go('/projects/$projectId/notes/${newPage.id}');
    }
  }
}
