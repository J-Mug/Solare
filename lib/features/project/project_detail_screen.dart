import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/firebase/project_sync_provider.dart';
import '../../core/project/project_provider.dart';
import '../../shared/widgets/app_layout.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const ProjectDetailScreen({super.key, required this.id});

  @override
  ConsumerState<ProjectDetailScreen> createState() =>
      _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _activateSync());
  }

  @override
  void dispose() {
    // Deactivate sync when leaving the project
    final sync = ref.read(activeProjectSyncProvider);
    sync?.dispose();
    ref.read(activeProjectSyncProvider.notifier).state = null;
    super.dispose();
  }

  void _activateSync() {
    final projects = ref.read(projectsProvider).valueOrNull ?? [];
    final project = projects.where((p) => p.id == widget.id).firstOrNull;
    if (project == null || !project.isCollaborative) return;

    final userId = ref.read(authProvider).user?.email ?? '';
    if (userId.isEmpty) return;

    final controller = ProjectSyncController(
      projectId: widget.id,
      userId: userId,
    );
    ref.read(activeProjectSyncProvider.notifier).state = controller;
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Project: ${widget.id}',
      showProjectSidebar: true,
      projectId: widget.id,
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Notes'),
                Tab(text: 'Branch Tree'),
                Tab(text: 'Characters'),
                Tab(text: 'Wiki'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.description_outlined),
                      onPressed: () =>
                          context.go('/projects/${widget.id}/notes'),
                      label: const Text('노트 보기'),
                    ),
                  ),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.account_tree),
                      onPressed: () =>
                          context.go('/projects/${widget.id}/tree'),
                      label: const Text('분기 수형도 열기'),
                    ),
                  ),
                  const Center(
                    child: Text('Characters Tab',
                        style: TextStyle(color: Colors.grey)),
                  ),
                  const Center(
                    child: Text('Wiki Tab',
                        style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
