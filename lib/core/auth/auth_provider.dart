import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';

export 'auth_service.dart' show AuthUser;

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;

  AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  factory AuthState.initial() => AuthState(status: AuthStatus.initial);
  factory AuthState.loading() => AuthState(status: AuthStatus.loading);
  factory AuthState.authenticated(AuthUser user) =>
      AuthState(status: AuthStatus.authenticated, user: user);
  factory AuthState.unauthenticated({String? error}) =>
      AuthState(status: AuthStatus.unauthenticated, errorMessage: error);
}

final authServiceProvider = Provider((ref) => AuthService());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState.initial());

  Future<void> init() async {
    state = AuthState.loading();
    final user = await _authService.signInSilently();
    if (user != null) {
      state = AuthState.authenticated(user);
    } else {
      state = AuthState.unauthenticated();
    }
  }

  Future<void> login() async {
    state = AuthState.loading();
    try {
      final user = await _authService.signIn();
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    state = AuthState.unauthenticated();
  }
}
