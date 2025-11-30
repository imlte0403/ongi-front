class AppConstants {
  // API URLs
  static const String apiBaseUrl = 
      String.fromEnvironment('API_URL', defaultValue: 'http://localhost:3000/api/v1');
  
  // App Info
  static const String appName = '온기';
  static const String appVersion = '1.0.0';
  
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
