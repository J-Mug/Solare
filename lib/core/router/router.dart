import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_provider.dart';
import '../../features/auth/login_screen.dart';
import '../../features/projects/projects_screen.dart';
import '../../features/project/project_detail_screen.dart';
import '../../features/notes/presentation/pages_list_screen.dart';
import '../../features/notes/presentation/page_editor_screen.dart';
import '../../features/branch_tree/presentation/branch_canvas_screen.dart';

// ---------------------------------------------------------------------------
// Auth-aware redirect notifier
// ---------------------------------------------------------------------------

class _RouterNotifier extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;

  void update(AuthStatus status) {
    if (_status == status) return;
    _status = status;
    notifyListeners();
  }

  String? redirect(BuildContext context, GoRouterState state) {
    // Don't redirect while auth state is still resolving
    if (_status == AuthStatus.initial || _status == AuthStatus.loading) {
      return null;
    }
    final isAuthenticated = _status == AuthStatus.authenticated;
    final isOnLogin = state.matchedLocation == '/';

    if (isAuthenticated && isOnLogin) return '/projects';
    if (!isAuthenticated && !isOnLogin) return '/';
    return null;
  }
}

// ---------------------------------------------------------------------------
// Router provider
// ---------------------------------------------------------------------------

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier();

  // Keep notifier in sync with auth state changes
  ref.listen<AuthState>(authProvider, (_, next) {
    notifier.update(next.status);
  });

  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/projects',
        builder: (context, state) => const ProjectsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) => ProjectDetailScreen(
              id: state.pathParameters['id']!,
            ),
            routes: [
              GoRoute(
                path: 'notes',
                builder: (context, state) => PagesListScreen(
                  projectId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: ':pageId',
                    builder: (context, state) => PageEditorScreen(
                      projectId: state.pathParameters['id']!,
                      pageId: state.pathParameters['pageId']!,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'tree',
                builder: (context, state) => BranchCanvasScreen(
                  projectId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
