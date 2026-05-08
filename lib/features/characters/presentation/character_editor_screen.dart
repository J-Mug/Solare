import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/character_model.dart';
import '../domain/characters_provider.dart';

class CharacterEditorScreen extends ConsumerStatefulWidget {
  final String projectId;
  final String charId;

  const CharacterEditorScreen({
    super.key,
    required this.projectId,
    required this.charId,
  });

  @override
  ConsumerState<CharacterEditorScreen> createState() =>
      _CharacterEditorScreenState();
}

class _CharacterEditorScreenState
    extends ConsumerState<CharacterEditorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;
  CharacterModel? _char;

  // Form controllers
  final _nameCtrl = TextEditingController();
  final _mbtiCtrl = TextEditingController();
  final _backstoryCtrl = TextEditingController();
  final _habitCtrl = TextEditingController();
  final _traumaCtrl = TextEditingController();
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _nameCtrl.dispose();
    _mbtiCtrl.dispose();
    _backstoryCtrl.dispose();
    _habitCtrl.dispose();
    _traumaCtrl.dispose();
    super.dispose();
  }

  void _loadChar(CharacterModel c) {
    if (_char?.id == c.id) return; // only reload when character changes
    _char = c;
    _nameCtrl.text = c.name;
    _mbtiCtrl.text = c.mbti ?? '';
    _backstoryCtrl.text = c.backstory;
    _dirty = false;
  }

  void _save() {
    if (_char == null) return;
    final updated = _char!.copyWith(
      name: _nameCtrl.text.trim().isEmpty ? _char!.name : _nameCtrl.text.trim(),
      mbti: _mbtiCtrl.text.trim().isEmpty ? null : _mbtiCtrl.text.trim(),
      clearMbti: _mbtiCtrl.text.trim().isEmpty,
      backstory: _backstoryCtrl.text,
    );
    ref.read(charactersProvider(widget.projectId).notifier).saveCharacter(updated);
    setState(() {
      _char = updated;
      _dirty = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('저장됨')));
  }

  void _addHabit() {
    final text = _habitCtrl.text.trim();
    if (text.isEmpty || _char == null) return;
    final updated = _char!.copyWith(habits: [..._char!.habits, text]);
    ref.read(charactersProvider(widget.projectId).notifier).saveCharacter(updated);
    setState(() {
      _char = updated;
      _habitCtrl.clear();
    });
  }

  void _removeHabit(int i) {
    if (_char == null) return;
    final habits = [..._char!.habits]..removeAt(i);
    final updated = _char!.copyWith(habits: habits);
    ref.read(charactersProvider(widget.projectId).notifier).saveCharacter(updated);
    setState(() => _char = updated);
  }

  void _addTrauma() {
    final text = _traumaCtrl.text.trim();
    if (text.isEmpty || _char == null) return;
    final updated = _char!.copyWith(traumas: [..._char!.traumas, text]);
    ref.read(charactersProvider(widget.projectId).notifier).saveCharacter(updated);
    setState(() {
      _char = updated;
      _traumaCtrl.clear();
    });
  }

  void _removeTrauma(int i) {
    if (_char == null) return;
    final traumas = [..._char!.traumas]..removeAt(i);
    final updated = _char!.copyWith(traumas: traumas);
    ref.read(charactersProvider(widget.projectId).notifier).saveCharacter(updated);
    setState(() => _char = updated);
  }

  void _addRelationship(List<CharacterModel> allChars) async {
    if (_char == null) return;
    final others = allChars.where((c) => c.id != _char!.id).toList();
    if (others.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('다른 캐릭터가 없습니다.')));
      return;
    }
    CharacterModel? selected;
    String type = 'friend';
    final descCtrl = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: const Text('관계 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<CharacterModel>(
                hint: const Text('캐릭터 선택'),
                value: selected,
                items: others
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                    .toList(),
                onChanged: (v) => setS(() => selected = v),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: type,
                items: const [
                  DropdownMenuItem(value: 'friend', child: Text('친구')),
                  DropdownMenuItem(value: 'enemy', child: Text('적')),
                  DropdownMenuItem(value: 'family', child: Text('가족')),
                  DropdownMenuItem(value: 'lover', child: Text('연인')),
                  DropdownMenuItem(value: 'rival', child: Text('라이벌')),
                  DropdownMenuItem(value: 'other', child: Text('기타')),
                ],
                onChanged: (v) => setS(() => type = v!),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(hintText: '설명 (선택)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: selected == null
                  ? null
                  : () => Navigator.pop(ctx, true),
              child: const Text('추가'),
            ),
          ],
        ),
      ),
    );

    if (result != true || selected == null) return;
    final rel = CharacterRelationship(
        targetId: selected!.id, type: type, description: descCtrl.text.trim());
    final updated =
        _char!.copyWith(relationships: [..._char!.relationships, rel]);
    ref.read(charactersProvider(widget.projectId).notifier).saveCharacter(updated);
    setState(() => _char = updated);
  }

  @override
  Widget build(BuildContext context) {
    final charsAsync = ref.watch(charactersProvider(widget.projectId));
    final allChars = charsAsync.valueOrNull ?? [];
    final char = allChars.where((c) => c.id == widget.charId).firstOrNull;

    if (char == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    _loadChar(char);

    return Scaffold(
      appBar: AppBar(
        title: Text(char.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
            tooltip: '저장',
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: '기본 정보'),
            Tab(text: '습관/트라우마'),
            Tab(text: '관계'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildBasicInfo(),
          _buildHabitsTraumas(),
          _buildRelationships(allChars),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: '이름'),
            onChanged: (_) => setState(() => _dirty = true),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _mbtiCtrl,
            decoration: const InputDecoration(
              labelText: 'MBTI',
              hintText: 'INFJ',
            ),
            onChanged: (_) => setState(() => _dirty = true),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _backstoryCtrl,
            decoration: const InputDecoration(labelText: '배경 이야기'),
            maxLines: 8,
            onChanged: (_) => setState(() => _dirty = true),
          ),
          const SizedBox(height: 16),
          if (_dirty)
            ElevatedButton(onPressed: _save, child: const Text('저장')),
        ],
      );

  Widget _buildHabitsTraumas() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('습관', style: Theme.of(context).textTheme.titleMedium),
          ..._char!.habits.asMap().entries.map(
                (e) => ListTile(
                  leading: const Icon(Icons.loop),
                  title: Text(e.value),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => _removeHabit(e.key),
                  ),
                ),
              ),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _habitCtrl,
                decoration: const InputDecoration(hintText: '습관 추가'),
              ),
            ),
            IconButton(onPressed: _addHabit, icon: const Icon(Icons.add)),
          ]),
          const Divider(height: 32),
          Text('트라우마', style: Theme.of(context).textTheme.titleMedium),
          ..._char!.traumas.asMap().entries.map(
                (e) => ListTile(
                  leading: const Icon(Icons.warning_amber_outlined),
                  title: Text(e.value),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => _removeTrauma(e.key),
                  ),
                ),
              ),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _traumaCtrl,
                decoration: const InputDecoration(hintText: '트라우마 추가'),
              ),
            ),
            IconButton(onPressed: _addTrauma, icon: const Icon(Icons.add)),
          ]),
        ],
      );

  Widget _buildRelationships(List<CharacterModel> allChars) {
    final nameMap = {for (final c in allChars) c.id: c.name};
    const typeLabel = {
      'friend': '친구',
      'enemy': '적',
      'family': '가족',
      'lover': '연인',
      'rival': '라이벌',
      'other': '기타',
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('관계 추가'),
          onPressed: () => _addRelationship(allChars),
        ),
        const SizedBox(height: 12),
        ...(_char?.relationships ?? []).asMap().entries.map((e) {
          final rel = e.value;
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                  child: Text(nameMap[rel.targetId]?.substring(0, 1) ?? '?')),
              title: Text(nameMap[rel.targetId] ?? rel.targetId),
              subtitle: Text(
                  '${typeLabel[rel.type] ?? rel.type}${rel.description.isNotEmpty ? ' · ${rel.description}' : ''}'),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  final rels = [..._char!.relationships]..removeAt(e.key);
                  final updated = _char!.copyWith(relationships: rels);
                  ref
                      .read(charactersProvider(widget.projectId).notifier)
                      .saveCharacter(updated);
                  setState(() => _char = updated);
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}
