class AppConstants {
  // API URLs
  static const String apiBaseUrl = String.fromEnvironment('API_URL',
      defaultValue: 'http://localhost:3000/api/v1');

  // App Info
  static const String appName = '온기';
  static const String appVersion = '1.0.0';

  // Development Mode
  // 개발 모드: true로 설정하면 온보딩을 건너뛰고 바로 테스트 페이지로 이동
  static const bool skipOnboarding =
      bool.fromEnvironment('SKIP_ONBOARDING', defaultValue: true);

  // 결과 페이지로 바로 이동: true로 설정하면 모든 온보딩 과정을 건너뛰고 결과 페이지로 이동
  static const bool skipToResult =
      bool.fromEnvironment('SKIP_TO_RESULT', defaultValue: false);

  // 프로필 설정 페이지로 바로 이동: true로 설정하면 프로필 설정 페이지로 이동
  static const bool skipToProfile =
      bool.fromEnvironment('SKIP_TO_PROFILE', defaultValue: false);

  // Local Storage Keys
  static const String sessionIdKey = 'guest_session_id';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  // API Endpoints
  static const String guestSessionEndpoint = '/guest/session';
  static const String questionsEndpoint = '/questions';
  static const String guestAnswersEndpoint = '/guest/answers';
  static const String guestResultEndpoint = '/guest/result';
  static const String clubsEndpoint = '/clubs';

  // Private 생성자 - 인스턴스 생성 방지
  AppConstants._();
}
