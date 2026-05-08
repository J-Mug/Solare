Future<({String accessToken, String? refreshToken, DateTime expiry})?> signInWithDesktopOAuth(
        List<String> scopes) async =>
    throw UnsupportedError('Desktop OAuth not available on web');

Future<({String accessToken, DateTime expiry})?> refreshDesktopToken(
        String storedRefreshToken) async =>
    throw UnsupportedError('Desktop OAuth not available on web');
