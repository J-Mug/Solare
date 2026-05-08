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
    // Desktop: restore from secure storage
    final token = await _storage.read(key: 'access_token');
    if (token != null) {
      final email = await _storage.read(key: 'user_email') ?? '';
      _currentUser = AuthUser(email: email);
      return _currentUser;
    }
    return null;
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
    final token = await signInWithDesktopOAuth(_desktopScopes);
    if (token == null) return null;
    await _storage.write(key: 'access_token', value: token);
    _currentUser = const AuthUser(email: '');
    return _currentUser;
  }

  Future<void> signOut() async {
    if (kIsWeb) await _googleSignIn!.signOut();
    _currentUser = null;
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'user_email');
  }

  Future<String?> getAccessToken() async {
    if (kIsWeb) {
      final account = _googleSignIn!.currentUser;
      if (account != null) {
        final auth = await account.authentication;
        if (auth.accessToken != null) return auth.accessToken;
      }
    }
    return _storage.read(key: 'access_token');
  }
}
