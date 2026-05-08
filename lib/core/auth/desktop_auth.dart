import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

const _clientId = '1086436477247-58a9rc6mvjje5pqjfaak37v9uni15ndr.apps.googleusercontent.com';
// Injected at build time via --dart-define=DESKTOP_CLIENT_SECRET=...
// Never hardcode this value in source.
const _clientSecret = String.fromEnvironment('DESKTOP_CLIENT_SECRET');

Future<String?> signInWithDesktopOAuth(List<String> scopes) async {
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
    return client.credentials.accessToken.data;
  } catch (_) {
    return null;
  } finally {
    baseClient.close();
  }
}
