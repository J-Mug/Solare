import 'dart:async';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/episode_model.dart';
import '../domain/episode_provider.dart';

String _extractPlainText(Node node) {
  final buf = StringBuffer();
  final delta = node.delta;
  if (delta != null) buf.write(delta.toPlainText());
  for (final child in node.children) {
    buf.write(_extractPlainText(child));
  }
  return buf.toString();
}

class EpisodeEditorScreen extends ConsumerStatefulWidget {
  final String projectId;
  final String episodeId;

  const EpisodeEditorScreen({
    super.key,
    required this.projectId,
    required this.episodeId,
  });

  @override
  ConsumerState<EpisodeEditorScreen> createState() =>
      _EpisodeEditorScreenState();
}

class _EpisodeEditorScreenState extends ConsumerState<EpisodeEditorScreen> {
  EditorState? _editorState;
  EpisodeModel? _episode;
  bool _loading = true;
  int _wordCount = 0;
  Timer? _debounce;
  StreamSubscription? _txSub;
  final _titleCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEpisode();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _txSub?.cancel();
    _editorState?.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadEpisode() async {
    final episodes =
        ref.read(episodesProvider(widget.projectId)).valueOrNull;
    EpisodeModel? ep =
        episodes?.where((e) => e.id == widget.episodeId).firstOrNull;

    if (ep == null) {
      final repo = ref.read(episodeRepositoryProvider(widget.projectId));
      ep = await repo?.getEpisode(widget.projectId, widget.episodeId);
    }

    if (ep == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    final editorState = ep.contentJson.isEmpty
        ? EditorState.blank(withInitialText: true)
        : EditorState(document: Document.fromJson(ep.contentJson));

    _txSub = editorState.transactionStream.listen((event) {
      final (time, _, _) = event;
      if (time == TransactionTime.after && mounted) {
        final text = _extractPlainText(editorState.document.root);
        setState(() => _wordCount = EpisodeModel.countWords(text));
        _scheduleAutoSave(editorState);
      }
    });

    if (mounted) {
      setState(() {
        _episode = ep;
        _editorState = editorState;
        _titleCtrl.text = ep!.title;
        _wordCount = ep.wordCount;
        _loading = false;
      });
    }
  }

  void _scheduleAutoSave(EditorState editorState) {
    _debounce?.cancel();
    _debounce =
        Timer(const Duration(seconds: 3), () => _save(editorState));
  }

  Future<void> _save([EditorState? es]) async {
    final editorState = es ?? _editorState;
    if (_episode == null || editorState == null) return;

    final contentJson = editorState.document.toJson();
    final text = _extractPlainText(editorState.document.root);
    final wordCount = EpisodeModel.countWords(text);
    final title =
        _titleCtrl.text.trim().isEmpty ? '제목 없음' : _titleCtrl.text.trim();

    final updated = _episode!.copyWith(
      title: title,
      contentJson: contentJson,
      wordCount: wordCount,
    );

    await ref
        .read(episodesProvider(widget.projectId).notifier)
        .saveEpisode(updated);

    if (mounted) setState(() => _episode = updated);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()));
    }
    if (_editorState == null) {
      return Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('에피소드를 찾을 수 없습니다.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleCtrl,
          style: Theme.of(context).textTheme.titleLarge,
          decoration: const InputDecoration(border: InputBorder.none),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
            tooltip: '저장',
          ),
        ],
      ),
      // 글자 수 카운터 하단 바
      bottomNavigationBar: Container(
        height: 36,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          '$_wordCount자',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
      body: AppFlowyEditor(editorState: _editorState!),
    );
  }
}
