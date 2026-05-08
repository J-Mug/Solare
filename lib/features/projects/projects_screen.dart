import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/collaboration/collab_provider.dart';
import '../../core/collaboration/invite_model.dart';
import '../../shared/widgets/app_layout.dart';
import 'domain/project_model.dart';
import 'domain/project_provider.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  bool _inviteDialogShown = false;

  @override
  void initState() {
    super.initState();
    // Check for pending invites after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkInvites());
  }

  void _checkInvites() {
    final email = ref.read(authProvider).user?.email ?? '';
    if (email.isEmpty) return;
    ref.listenManual(pendingInvitesProvider(email), (_, next) {
      final invites = next.valueOrNull;
      if (invites != null &&
          invites.isNotEmpty &&
          !_inviteDialogShown &&
          mounted) {
        _inviteDialogShown = true;
        showDialog(
          context: context,
          builder: (_) => _PendingInvitesDialog(
            myEmail: email,
            onAccept: (invite) =>
                ref.read(projectsControllerProvider.notifier).createProject(
                      name: invite.projectName,
                      ownerEmail: invite.ownerEmail,
                      isCollaborative: true,
                    ),
          ),
        ).then((_) => _inviteDialogShown = false);
      }
    }, fireImmediately: true);
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsProvider);
    final myEmail = ref.watch(authProvider).user?.email ?? '';

    return AppLayout(
      title: 'My Projects',
      child: projectsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (projects) => _ProjectsList(
          projects: projects,
          myEmail: myEmail,
        ),
      ),
    );
  }
}

class _ProjectsList extends ConsumerWidget {
  final List<ProjectModel> projects;
  final String myEmail;

  const _ProjectsList({required this.projects, required this.myEmail});

  void _showInvitesDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => _PendingInvitesDialog(
        myEmail: myEmail,
        onAccept: (invite) =>
            ref.read(projectsControllerProvider.notifier).createProject(
                  name: invite.projectName,
                  ownerEmail: invite.ownerEmail,
                  isCollaborative: true,
                ),
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => _CreateProjectDialog(ownerEmail: myEmail),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Badge count for pending invites
    final invitesAsync = ref.watch(pendingInvitesProvider(myEmail));
    final inviteCount = invitesAsync.valueOrNull?.length ?? 0;

    return Stack(
      children: [
        projects.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.folder_open,
                        size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('아직 프로젝트가 없습니다',
                        style:
                            TextStyle(fontSize: 18, color: Colors.grey)),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => _showCreateDialog(context, ref),
                      icon: const Icon(Icons.add),
                      label: const Text('프로젝트 만들기'),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: projects.length,
                itemBuilder: (context, i) {
                  final p = projects[i];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        p.isCollaborative
                            ? Icons.group
                            : Icons.person,
                        color: p.isCollaborative
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      title: Text(p.name),
                      subtitle: p.isCollaborative
                          ? Text('협업 · ${p.ownerEmail}')
                          : const Text('개인 프로젝트'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.go('/projects/${p.id}'),
                    ),
                  );
                },
              ),
        // FAB + invite badge
        Positioned(
          bottom: 24,
          right: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (inviteCount > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Badge(
                    label: Text('$inviteCount'),
                    child: FloatingActionButton.small(
                      heroTag: 'invites',
                      onPressed: () =>
                          _showInvitesDialog(context, ref),
                      tooltip: '협업 초대',
                      child: const Icon(Icons.mail_outline),
                    ),
                  ),
                ),
              FloatingActionButton(
                heroTag: 'create',
                onPressed: () => _showCreateDialog(context, ref),
                tooltip: '프로젝트 만들기',
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CreateProjectDialog extends ConsumerStatefulWidget {
  final String ownerEmail;
  const _CreateProjectDialog({required this.ownerEmail});

  @override
  ConsumerState<_CreateProjectDialog> createState() =>
      _CreateProjectDialogState();
}

class _CreateProjectDialogState
    extends ConsumerState<_CreateProjectDialog> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isCollaborative = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    final project = await ref
        .read(projectsControllerProvider.notifier)
        .createProject(
          name: _nameController.text.trim(),
          ownerEmail: widget.ownerEmail,
          isCollaborative: _isCollaborative,
        );
    if (mounted) {
      Navigator.pop(context);
      if (project != null) {
        context.go('/projects/${project.id}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectsControllerProvider);

    return AlertDialog(
      title: const Text('새 프로젝트'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '프로젝트 이름',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '이름을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('협업 프로젝트'),
                const Spacer(),
                Switch(
                  value: _isCollaborative,
                  onChanged: (v) =>
                      setState(() => _isCollaborative = v),
                ),
              ],
            ),
            if (_isCollaborative)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '팀원은 프로젝트 생성 후 초대할 수 있습니다.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: state.isLoading ? null : _create,
          child: state.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('만들기'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Pending invites dialog (inline, no cross-feature import needed)
// ---------------------------------------------------------------------------

class _PendingInvitesDialog extends ConsumerWidget {
  final String myEmail;
  final Future<void> Function(InviteModel invite)? onAccept;

  const _PendingInvitesDialog({required this.myEmail, this.onAccept});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitesAsync = ref.watch(pendingInvitesProvider(myEmail));

    return AlertDialog(
      title: const Text('협업 초대'),
      content: SizedBox(
        width: 360,
        child: invitesAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('오류: $e'),
          data: (invites) {
            if (invites.isEmpty) {
              return const Text('대기 중인 초대가 없습니다.');
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: invites
                  .map((invite) => Card(
                        child: ListTile(
                          title: Text(invite.projectName),
                          subtitle:
                              Text('${invite.ownerEmail}님의 초대'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () => ref
                                    .read(collabControllerProvider
                                        .notifier)
                                    .removeInvite(
                                      inviteId: invite.inviteId,
                                      inviteeEmail: myEmail,
                                    ),
                                child: const Text('거절'),
                              ),
                              const SizedBox(width: 4),
                              FilledButton(
                                onPressed: () async {
                                  await onAccept?.call(invite);
                                  await ref
                                      .read(collabControllerProvider
                                          .notifier)
                                      .removeInvite(
                                        inviteId: invite.inviteId,
                                        inviteeEmail: myEmail,
                                      );
                                },
                                child: const Text('수락'),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('닫기'),
        ),
      ],
    );
  }
}
