/// API base URL including `/api` (no trailing slash).
///
/// Default targets the LAN host so Chrome/web clients on this machine
/// (and other devices) can reach the Spring API.
///
/// Override at build/run time:
/// `flutter run -d chrome --dart-define=API_BASE_URL=http://172.16.16.111:8080/api`
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://172.16.16.111:8080/api',
  );

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration queryReadTimeout = Duration(seconds: 180);
  static const Duration defaultReadTimeout = Duration(seconds: 30);

  static const int maxFileBytes = 52428800; // 50 MB
  static const int maxQuestionLength = 1000;
  static const int pageSize = 20;
  static const Duration healthPollInterval = Duration(seconds: 30);
}
