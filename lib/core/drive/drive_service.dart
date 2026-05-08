import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';
import 'drive_repository.dart';
import 'drive_repository_impl.dart';

/// Provides a DriveRepository backed by the authenticated user's access token.
/// Re-evaluates when auth state changes. Returns null if not authenticated.
final driveRepositoryProvider =
    FutureProvider<DriveRepository?>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState.status != AuthStatus.authenticated) return null;

  final authService = ref.read(authServiceProvider);
  final token = await authService.getAccessToken();
  if (token == null) return null;
  return DriveRepositoryImpl(token);
});
