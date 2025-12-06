import 'package:flutter/foundation.dart';

/// 앱 전역 로거 유틸리티
///
/// `print()` 대신 사용하여 프로덕션 코드에서 로그가 출력되지 않도록 합니다.
/// Flutter 공식 가이드라인에 따라 `kDebugMode`와 `debugPrint`를 사용합니다.
class AppLogger {
  // Private 생성자 - 인스턴스 생성 방지
  AppLogger._();

  /// 정보 로그 출력 (디버그 모드에서만)
  static void info(String message) {
    if (kDebugMode) {
      debugPrint('ℹ️ $message');
    }
  }

  /// 성공 로그 출력 (디버그 모드에서만)
  static void success(String message) {
    if (kDebugMode) {
      debugPrint('✅ $message');
    }
  }

  /// 경고 로그 출력 (디버그 모드에서만)
  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('⚠️ $message');
    }
  }

  /// 에러 로그 출력 (디버그 모드에서만)
  static void error(String message) {
    if (kDebugMode) {
      debugPrint('❌ $message');
    }
  }

  /// 일반 디버그 로그 출력 (디버그 모드에서만)
  static void debug(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  /// 키 아이콘 로그 (인증 관련)
  static void auth(String message) {
    if (kDebugMode) {
      debugPrint('🔑 $message');
    }
  }

  /// 링크 아이콘 로그
  static void link(String message) {
    if (kDebugMode) {
      debugPrint('🔗 $message');
    }
  }

  /// 로켓 아이콘 로그 (시작 관련)
  static void launch(String message) {
    if (kDebugMode) {
      debugPrint('🚀 $message');
    }
  }

  /// 검색 아이콘 로그
  static void search(String message) {
    if (kDebugMode) {
      debugPrint('🔍 $message');
    }
  }
}
