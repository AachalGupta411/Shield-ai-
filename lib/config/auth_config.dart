/// Google OAuth client ID for web sign-in.
///
/// Create credentials at https://console.cloud.google.com/apis/credentials
/// then run with:
/// `flutter run -d chrome --dart-define=GOOGLE_WEB_CLIENT_ID=YOUR_ID.apps.googleusercontent.com`
class AuthConfig {
  static const googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: '',
  );

  static bool get hasGoogleWebClientId => googleWebClientId.isNotEmpty;
}
