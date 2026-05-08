import 'dart:async';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/app_layout.dart';
import '../domain/notes_provider.dart';
import '../domain/page_model.dart';

/// Full-featured note editor screen using AppFlowy Editor.
/// Loads page from Drive (via NotesRepository), auto-saves on change.
class PageEditorScreen extends ConsumerStatefulWidget {
  final String projectId;
  final String pageId;

  const PageEditorScreen({
    super.key,
    required this.projectId,
    required this.pageId,
  });

  @override
  ConsumerState<PageEditorScreen> createState() =>
      _PageEditorScreenState();
}

class _PageEditorScreenState extends ConsumerState<PageEditorScreen> {
  EditorState? _editorState;
  PageModel? _page;
  bool _loading = true;
  bool _dirty = false;
  Timer? _debounce;
  StreamSubscription? _txSub;
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _txSub?.cancel();
    _editorState?.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadPage() async {
    final repo = ref.read(notesRepositoryProvider);
    if (repo == null) {
      setState(() => _loading = false);
      return;
    }

    final PageModel? page =
        await repo.getPage(widget.projectId, widget.pageId);

    if (page == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    final editorState = page.contentJson.isEmpty
        ? EditorState.blank(withInitialText: true)
        : EditorState(document: Document.fromJson(page.contentJson));

    _txSub = editorState.transactionStream.listen((event) {
      final (time, _, _) = event;
      if (time == TransactionTime.after && mounted) {
        setState(() => _dirty = true);
        _scheduleAutoSave(editorState);
      }
    });

    if (mounted) {
      setState(() {
        _page = page;
        _editorState = editorState;
        _titleController.text = page!.title;
        _loading = false;
      });
    }
  }

  void _scheduleAutoSave(EditorState editorState) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 3), () {
      _save(editorState);
    });
  }

  Future<void> _save(EditorState editorState) async {
    if (_page == null) return;
    final contentJson = editorState.document.toJson();
    final title = _titleController.text.trim().isEmpty
        ? '제목 없음'
        : _titleController.text.trim();

    final updated = _page!.copyWith(
      title: title,
      contentJson: contentJson,
    );

    await ref
        .read(notesControllerProvider.notifier)
        .savePage(updated);

    if (mounted) {
      setState(() {
        _page = updated;
        _dirty = false;
      });
    }
  }

  Future<void> _saveNow() async {
    if (_editorState != null) {
      _debounce?.cancel();
      await _save(_editorState!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return AppLayout(
        title: '...',
        showProjectSidebar: true,
        projectId: widget.projectId,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_editorState == null) {
      return AppLayout(
        title: '오류',
        showProjectSidebar: true,
        projectId: widget.projectId,
        child: const Center(child: Text('로그인 후 이용할 수 있습니다.')),
      );
    }

    return PopScope(
      canPop: true,
      onPopInvoked: (_) => _saveNow(),
      child: AppLayout(
        title: _titleController.text.isEmpty
            ? '제목 없음'
            : _titleController.text,
        showProjectSidebar: true,
        projectId: widget.projectId,
        actions: [
          if (_dirty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                icon: const Icon(Icons.save_outlined, size: 18),
                label: const Text('저장'),
                onPressed: _saveNow,
              ),
            ),
          IconButton(
            icon: const Icon(Icons.list_outlined),
            tooltip: '페이지 목록',
            onPressed: () =>
                context.go('/projects/${widget.projectId}/notes'),
          ),
        ],
        child: Column(
          children: [
            // Title field
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: '제목 없음',
                  border: InputBorder.none,
                ),
                onChanged: (_) {
                  setState(() => _dirty = true);
                  _scheduleAutoSave(_editorState!);
                },
              ),
            ),
            const Divider(height: 1),
            // AppFlowy Editor
            Expanded(
              child: AppFlowyEditor(
                editorState: _editorState!,
                editorStyle: _buildEditorStyle(context),
                blockComponentBuilders:
                    standardBlockComponentBuilderMap,
                commandShortcutEvents: standardCommandShortcutEvents,
                characterShortcutEvents: standardCharacterShortcutEvents,
              ),
            ),
          ],
        ),
      ),
    );
  }

  EditorStyle _buildEditorStyle(BuildContext context) {
    return EditorStyle.desktop(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      cursorColor: Theme.of(context).colorScheme.primary,
      selectionColor:
          Theme.of(context).colorScheme.primary.withOpacity(0.3),
    );
  }
}
