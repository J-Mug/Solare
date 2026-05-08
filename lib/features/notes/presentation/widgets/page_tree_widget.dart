import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/notes_provider.dart';
import '../../domain/page_model.dart';

/// Recursively renders a tree of pages.
/// [projectId] — which project to show pages for.
/// [parentId]  — null = root pages, else sub-pages of that page.
/// [depth]     — current nesting depth (controls left indent).
class PageTreeWidget extends ConsumerWidget {
  final String projectId;
  final String? parentId;
  final int depth;

  const PageTreeWidget({
    super.key,
    required this.projectId,
    this.parentId,
    this.depth = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagesAsync =
        ref.watch(pagesProvider((projectId, parentId)));

    return pagesAsync.when(
      loading: () => depth == 0
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            )
          : const SizedBox.shrink(),
      error: (e, _) => depth == 0
          ? Center(child: Text('오류: $e'))
          : const SizedBox.shrink(),
      data: (pages) {
        if (pages.isEmpty && depth == 0) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.description_outlined,
                      size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    '페이지가 없습니다.\n아래 + 버튼으로 첫 페이지를 만드세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: pages
              .map((page) => _PageItem(
                    page: page,
                    depth: depth,
                    projectId: projectId,
                  ))
              .toList(),
        );
      },
    );
  }
}

class _PageItem extends ConsumerStatefulWidget {
  final PageModel page;
  final int depth;
  final String projectId;

  const _PageItem({
    required this.page,
    required this.depth,
    required this.projectId,
  });

  @override
  ConsumerState<_PageItem> createState() => _PageItemState();
}

class _PageItemState extends ConsumerState<_PageItem> {
  bool _expanded = false;

  Future<bool> _hasChildren() async {
    final repo = ref.read(notesRepositoryProvider);
    if (repo == null) return false;
    final children =
        await repo.getPages(widget.projectId, parentId: widget.page.id);
    return children.isNotEmpty;
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('하위 페이지 추가'),
              onTap: () {
                Navigator.pop(context);
                _createSubPage(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline),
              title: const Text('이름 바꾸기'),
              onTap: () {
                Navigator.pop(context);
                _showRenameDialog(context);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('삭제',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deletePage(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createSubPage(BuildContext context) async {
    final controller = ref.read(notesControllerProvider.notifier);
    final newPage = await controller.createPage(
      widget.projectId,
      parentId: widget.page.id,
    );
    if (newPage != null && context.mounted) {
      setState(() => _expanded = true);
      context.go(
          '/projects/${widget.projectId}/notes/${newPage.id}');
    }
  }

  Future<void> _showRenameDialog(BuildContext context) async {
    final controller = TextEditingController(text: widget.page.title);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('이름 바꾸기'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: '페이지 제목'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('확인'),
          ),
        ],
      ),
    );
    if (newTitle != null && newTitle.isNotEmpty) {
      ref
          .read(notesControllerProvider.notifier)
          .renamePage(widget.page, newTitle);
    }
  }

  Future<void> _deletePage(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('페이지 삭제'),
        content: Text('"${widget.page.title}" 페이지를 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(notesControllerProvider.notifier).deletePage(
            widget.projectId,
            widget.page.id,
            parentId: widget.page.parentId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final indent = widget.depth * 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => context.go(
              '/projects/${widget.projectId}/notes/${widget.page.id}'),
          onLongPress: () => _showContextMenu(context),
          child: Padding(
            padding: EdgeInsets.only(
                left: 8.0 + indent, right: 8.0, top: 4, bottom: 4),
            child: Row(
              children: [
                // Expand/collapse button
                GestureDetector(
                  onTap: () async {
                    if (!_expanded) {
                      // Only expand if there are children
                      final has = await _hasChildren();
                      if (has) setState(() => _expanded = true);
                    } else {
                      setState(() => _expanded = false);
                    }
                  },
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: Icon(
                      _expanded
                          ? Icons.arrow_drop_down
                          : Icons.arrow_right,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Icon(Icons.description_outlined,
                    size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.page.title.isEmpty
                        ? '제목 없음'
                        : widget.page.title,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Quick add sub-page button
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  splashRadius: 14,
                  tooltip: '하위 페이지',
                  onPressed: () => _createSubPage(context),
                ),
              ],
            ),
          ),
        ),
        // Sub-pages (recursive)
        if (_expanded)
          PageTreeWidget(
            projectId: widget.projectId,
            parentId: widget.page.id,
            depth: widget.depth + 1,
          ),
      ],
    );
  }
}
