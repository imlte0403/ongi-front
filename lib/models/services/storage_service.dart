import 'package:shared_preferences/shared_preferences.dart';
import 'package:ongi_front/core/constants.dart';
import 'package:ongi_front/utils/app_logger.dart';

class StorageService {
  // 게스트 세션 ID 저장/조회
  static Future<void> saveSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.sessionIdKey, sessionId);
    AppLogger.debug('💾 세션 ID 저장: $sessionId');
  }

  static Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.sessionIdKey);
  }

  // JWT 토큰 저장/조회 (Sprint 3에서 사용)
  static Future<void> saveTokens(
      String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.accessTokenKey, accessToken);
    await prefs.setString(AppConstants.refreshTokenKey, refreshToken);
    AppLogger.auth('토큰 저장 완료');
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.refreshTokenKey);
  }

  // 전체 삭제 (로그아웃 시)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    AppLogger.debug('🗑️ 로컬 스토리지 전체 삭제');
  }

  // Private 생성자 - 인스턴스 생성 방지
  StorageService._();
}
