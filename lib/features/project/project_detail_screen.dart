import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/firebase/project_sync_provider.dart';
import '../../core/platform/feature_flags.dart';
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
    final pid = widget.id;

    final features = [
      _Feature('Notes', Icons.description_outlined, '/projects/$pid/notes'),
      _Feature('Branch Tree', Icons.account_tree, '/projects/$pid/tree'),
      _Feature('캐릭터', Icons.people_outline, '/projects/$pid/characters'),
      _Feature('위키', Icons.menu_book_outlined, '/projects/$pid/wiki'),
      _Feature('에피소드', Icons.edit_note, '/projects/$pid/episodes'),
      _Feature('타임라인', Icons.timeline, '/projects/$pid/timeline'),
      if (FeatureFlags.hasMoodboard)
        _Feature('무드보드', Icons.palette_outlined, '/projects/$pid/moodboard'),
    ];

    return AppLayout(
      title: 'Project: $pid',
      showProjectSidebar: true,
      projectId: pid,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
        ),
        itemCount: features.length,
        itemBuilder: (context, i) {
          final f = features[i];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.go(f.route),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(f.icon, size: 32,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 8),
                  Text(f.label,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Feature {
  final String label;
  final IconData icon;
  final String route;
  const _Feature(this.label, this.icon, this.route);
}
