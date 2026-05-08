import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/platform/feature_flags.dart';

class AppLayout extends ConsumerWidget {
  final Widget child;
  final String title;
  final bool showProjectSidebar;
  final String? projectId;
  final List<Widget>? actions;

  const AppLayout({
    super.key,
    required this.child,
    required this.title,
    this.showProjectSidebar = false,
    this.projectId,
    this.actions,
  });

  void _showFeatureRestriction(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(FeatureFlags.webRestrictionMessage)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Playfair Display')),
        actions: [
          if (actions != null) ...actions!,
          IconButton(
            icon: const Badge(
              label: Text('2'),
              child: Icon(Icons.notifications_none),
            ),
            onPressed: () {
              // TODO: Show Invites Popup
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: isMobile ? _buildSidebar(context) : null,
      body: Row(
        children: [
          if (!isMobile) _buildSidebar(context),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('Projects'),
            onTap: () => context.go('/projects'),
          ),
          if (showProjectSidebar && projectId != null) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.auto_awesome_mosaic_outlined),
              title: const Text('Moodboard'),
              onTap: () {
                if (!FeatureFlags.hasMoodboard) {
                  _showFeatureRestriction(context);
                } else {
                  // Navigate to moodboard (implemented later)
                }
              },
              trailing: !FeatureFlags.hasMoodboard ? const Icon(Icons.desktop_windows, size: 16, color: Colors.grey) : null,
            ),
            ListTile(
              leading: const Icon(Icons.workspaces_outline),
              title: const Text('Workspace'),
              onTap: () {
                if (!FeatureFlags.hasWorkspace) {
                  _showFeatureRestriction(context);
                } else {
                  // Navigate to workspace
                }
              },
              trailing: !FeatureFlags.hasWorkspace ? const Icon(Icons.desktop_windows, size: 16, color: Colors.grey) : null,
            ),
            ListTile(
              leading: const Icon(Icons.widgets_outlined),
              title: const Text('Widgets'),
              onTap: () {
                if (!FeatureFlags.hasWidgets) {
                  _showFeatureRestriction(context);
                } else {
                  // Navigate to widgets
                }
              },
              trailing: !FeatureFlags.hasWidgets ? const Icon(Icons.desktop_windows, size: 16, color: Colors.grey) : null,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text('Back to Projects'),
              onTap: () => context.go('/projects'),
            ),
          ],
        ],
      ),
    );
  }
}
