import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

const _clientId = '1086436477247-58a9rc6mvjje5pqjfaak37v9uni15ndr.apps.googleusercontent.com';
// Injected at build time via --dart-define=DESKTOP_CLIENT_SECRET=...
// Never hardcode this value in source.
const _clientSecret = String.fromEnvironment('DESKTOP_CLIENT_SECRET');

Future<({String accessToken, String? refreshToken, DateTime expiry})?> signInWithDesktopOAuth(
    List<String> scopes) async {
  final id = ClientId(_clientId, _clientSecret);
  final baseClient = http.Client();
  try {
    final client = await clientViaUserConsent(
      id,
      scopes,
      (url) {
        Process.run('rundll32', ['url.dll,FileProtocolHandler', url]);
      },
      baseClient: baseClient,
    );
    final creds = client.credentials;
    return (
      accessToken: creds.accessToken.data,
      refreshToken: creds.refreshToken,
      expiry: creds.accessToken.expiry,
    );
  } catch (_) {
    return null;
  } finally {
    baseClient.close();
  }
}

/// Refresh an expired access token using the stored refresh token.
Future<({String accessToken, DateTime expiry})?> refreshDesktopToken(
    String storedRefreshToken) async {
  final id = ClientId(_clientId, _clientSecret);
  final baseClient = http.Client();
  try {
    final oldCredentials = AccessCredentials(
      AccessToken('Bearer', 'expired', DateTime(2000).toUtc()),
      storedRefreshToken,
      ['https://www.googleapis.com/auth/drive.appdata', 'email'],
    );
    final newCreds = await refreshCredentials(id, oldCredentials, baseClient);
    return (
      accessToken: newCreds.accessToken.data,
      expiry: newCreds.accessToken.expiry,
    );
  } catch (_) {
    return null;
  } finally {
    baseClient.close();
  }
}
