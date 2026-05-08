import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'desktop_auth.dart' if (dart.library.html) 'desktop_auth_stub.dart';

class AuthUser {
  final String email;
  const AuthUser({required this.email});
}

class AuthService {
  final GoogleSignIn? _googleSignIn = kIsWeb
      ? GoogleSignIn(
          clientId: '1086436477247-fhm90l8ssa3nr3p0uj3ql0pm1q1pbohn.apps.googleusercontent.com',
          scopes: [
            drive.DriveApi.driveAppdataScope,
            'email',
          ],
        )
      : null;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _desktopScopes = [
    'https://www.googleapis.com/auth/drive.appdata',
    'email',
  ];

  AuthUser? _currentUser;
  AuthUser? get currentUser => _currentUser;

  Future<AuthUser?> signInSilently() async {
    if (kIsWeb) {
      final account = await _googleSignIn!.signInSilently();
      if (account == null) return null;
      final auth = await account.authentication;
      if (auth.accessToken != null) {
        await _storage.write(key: 'access_token', value: auth.accessToken);
      }
      _currentUser = AuthUser(email: account.email);
      return _currentUser;
    }
    // Desktop: restore from secure storage, auto-refresh if expired
    final token = await _storage.read(key: 'access_token');
    if (token == null) return null;
    // Old tokens (saved before refresh-token fix) have no expiry info.
    // Discard them to force a fresh login that saves the refresh token.
    final expiryStr = await _storage.read(key: 'token_expiry');
    if (expiryStr == null) {
      await _storage.delete(key: 'access_token');
      return null;
    }
    final email = await _storage.read(key: 'user_email') ?? '';
    await _refreshDesktopTokenIfNeeded();
    final valid = await _storage.read(key: 'access_token');
    if (valid == null) return null;
    _currentUser = AuthUser(email: email);
    return _currentUser;
  }

  Future<AuthUser?> signIn() async {
    if (kIsWeb) {
      final account = await _googleSignIn!.signIn();
      if (account == null) return null;
      final auth = await account.authentication;
      if (auth.accessToken != null) {
        await _storage.write(key: 'access_token', value: auth.accessToken);
      }
      _currentUser = AuthUser(email: account.email);
      return _currentUser;
    }
    // Desktop: open browser OAuth flow
    final result = await signInWithDesktopOAuth(_desktopScopes);
    if (result == null) return null;
    await _storage.write(key: 'access_token', value: result.accessToken);
    await _storage.write(key: 'token_expiry', value: result.expiry.toIso8601String());
    if (result.refreshToken != null) {
      await _storage.write(key: 'refresh_token', value: result.refreshToken!);
    }
    _currentUser = const AuthUser(email: '');
    return _currentUser;
  }

  Future<void> signOut() async {
    if (kIsWeb) await _googleSignIn!.signOut();
    _currentUser = null;
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'user_email');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'token_expiry');
  }

  Future<String?> getAccessToken() async {
    if (kIsWeb) {
      final account = _googleSignIn!.currentUser;
      if (account != null) {
        final auth = await account.authentication;
        if (auth.accessToken != null) return auth.accessToken;
      }
    }
    // Desktop: refresh if needed before returning
    await _refreshDesktopTokenIfNeeded();
    return _storage.read(key: 'access_token');
  }

  /// Refreshes the desktop access token if it has expired or is about to expire.
  /// Deletes stored tokens and returns without error if refresh fails (forces re-login).
  Future<void> _refreshDesktopTokenIfNeeded() async {
    if (kIsWeb) return;
    final expiryStr = await _storage.read(key: 'token_expiry');
    if (expiryStr == null) return; // no expiry info — assume still valid
    final expiry = DateTime.tryParse(expiryStr);
    if (expiry == null) return;
    // Refresh 5 minutes before actual expiry
    if (DateTime.now().isBefore(expiry.subtract(const Duration(minutes: 5)))) return;
    final refreshToken = await _storage.read(key: 'refresh_token');
    if (refreshToken == null) {
      await _storage.delete(key: 'access_token');
      return;
    }
    final result = await refreshDesktopToken(refreshToken);
    if (result != null) {
      await _storage.write(key: 'access_token', value: result.accessToken);
      await _storage.write(key: 'token_expiry', value: result.expiry.toIso8601String());
    } else {
      // Refresh failed — clear tokens to force re-login
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
      await _storage.delete(key: 'token_expiry');
    }
  }
}
