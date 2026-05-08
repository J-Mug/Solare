import 'dart:async';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/wiki_model.dart';
import '../domain/wiki_provider.dart';

class WikiEditorScreen extends ConsumerStatefulWidget {
  final String projectId;
  final String entryId;

  const WikiEditorScreen({
    super.key,
    required this.projectId,
    required this.entryId,
  });

  @override
  ConsumerState<WikiEditorScreen> createState() => _WikiEditorScreenState();
}

class _WikiEditorScreenState extends ConsumerState<WikiEditorScreen> {
  EditorState? _editorState;
  WikiEntry? _entry;
  bool _loading = true;
  Timer? _debounce;
  StreamSubscription? _txSub;
  final _titleCtrl = TextEditingController();

  static String _extractPlainText(Node node) {
    final buf = StringBuffer();
    final delta = node.delta;
    if (delta != null) buf.write(delta.toPlainText());
    for (final child in node.children) {
      buf.write(_extractPlainText(child));
    }
    return buf.toString();
  }

  @override
  void initState() {
    super.initState();
    _loadEntry();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _txSub?.cancel();
    _editorState?.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadEntry() async {
    final entries = ref.read(wikiProvider(widget.projectId)).valueOrNull;
    WikiEntry? entry = entries?.where((e) => e.id == widget.entryId).firstOrNull;

    // 캐시에 없으면 repo에서 직접 로드
    if (entry == null) {
      final repo = ref.read(wikiRepositoryProvider(widget.projectId));
      entry = await repo?.getEntry(widget.projectId, widget.entryId);
    }

    if (entry == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    final editorState = entry.contentJson.isEmpty
        ? EditorState.blank(withInitialText: true)
        : EditorState(document: Document.fromJson(entry.contentJson));

    _txSub = editorState.transactionStream.listen((event) {
      final (time, _, _) = event;
      if (time == TransactionTime.after && mounted) {
        _scheduleAutoSave(editorState);
      }
    });

    if (mounted) {
      setState(() {
        _entry = entry;
        _editorState = editorState;
        _titleCtrl.text = entry!.title;
        _loading = false;
      });
    }
  }

  void _scheduleAutoSave(EditorState editorState) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 3), () => _save(editorState));
  }

  Future<void> _save([EditorState? es]) async {
    final editorState = es ?? _editorState;
    if (_entry == null || editorState == null) return;

    final contentJson = editorState.document.toJson();
    final plainText = _extractPlainText(editorState.document.root);
    final links = WikiEntry.parseLinks(plainText);
    final title = _titleCtrl.text.trim().isEmpty ? '제목 없음' : _titleCtrl.text.trim();

    final updated = _entry!.copyWith(
      title: title,
      contentJson: contentJson,
      internalLinks: links,
    );

    await ref.read(wikiProvider(widget.projectId).notifier).saveEntry(updated);

    if (mounted) setState(() => _entry = updated);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
          appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    }
    if (_editorState == null) {
      return Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('항목을 찾을 수 없습니다.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleCtrl,
          style: Theme.of(context).textTheme.titleLarge,
          decoration: const InputDecoration(border: InputBorder.none),
        ),
        actions: [
          if (_entry != null && _entry!.internalLinks.isNotEmpty)
            IconButton(
              icon: Badge(
                label: Text('${_entry!.internalLinks.length}'),
                child: const Icon(Icons.link),
              ),
              tooltip: '내부 링크',
              onPressed: () => _showLinks(context),
            ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
            tooltip: '저장',
          ),
        ],
      ),
      body: AppFlowyEditor(editorState: _editorState!),
    );
  }

  void _showLinks(BuildContext context) {
    final allEntries = ref.read(wikiProvider(widget.projectId)).valueOrNull ?? [];
    final titleMap = {for (final e in allEntries) e.title: e.id};
    final links = _entry?.internalLinks ?? [];

    showModalBottomSheet(
      context: context,
      builder: (_) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          Text('내부 링크', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...links.map((title) {
            final targetId = titleMap[title];
            return ListTile(
              leading: const Icon(Icons.article_outlined),
              title: Text(title),
              trailing: targetId != null
                  ? const Icon(Icons.arrow_forward_ios, size: 14)
                  : const Tooltip(
                      message: '존재하지 않는 항목',
                      child: Icon(Icons.help_outline, color: Colors.orange)),
              onTap: targetId == null
                  ? null
                  : () {
                      Navigator.pop(context);
                      context.go('/projects/${widget.projectId}/wiki/$targetId');
                    },
            );
          }),
        ],
      ),
    );
  }
}
