import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'package:ongi_front/models/entities/user_model.dart';
import 'package:ongi_front/services/kakao_auth_service.dart';
import 'package:ongi_front/models/api/auth_api.dart';
import 'package:ongi_front/models/services/storage_service.dart';
import 'package:ongi_front/utils/app_logger.dart';

class AuthViewModel extends ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 카카오 로그인 시작 (웹)
  ///
  /// 카카오 인증 페이지로 리다이렉트합니다.
  Future<void> startKakaoLogin() async {
    _setLoading(true);
    _setError(null);

    try {
      // Redirect URI 설정
      final origin = html.window.location.origin;
      final redirectUri = '$origin/auth/kakao/callback';

      AppLogger.launch('[카카오 로그인 시작] Redirect URI: $redirectUri');

      // 카카오 로그인 페이지로 리다이렉트
      await kakaoAuthService.loginForWeb(redirectUri: redirectUri);

      // 리다이렉트되므로 이 아래 코드는 실행되지 않음
    } catch (e) {
      AppLogger.error('카카오 로그인 시작 실패: $e');
      _setError('카카오 로그인을 시작할 수 없습니다');
      _setLoading(false);
    }
  }

  /// 카카오 인가 코드로 로그인
  ///
  /// 콜백 페이지에서 받은 인가 코드를 카카오 Access Token으로 변환한 후
  /// 백엔드로 전달하여 JWT 토큰을 받습니다.
  Future<void> loginWithKakaoAuthCode(String authCode) async {
    _setLoading(true);
    _setError(null);

    try {
      // Redirect URI 재구성 (콜백 URL에서)
      final origin = html.window.location.origin;
      final redirectUri = '$origin/auth/kakao/callback';

      AppLogger.auth('[Step 1] 인가 코드로 카카오 Access Token 받기');

      // 인가 코드로 카카오 Access Token 받기
      final kakaoAccessToken = await kakaoAuthService.getAccessTokenFromCode(
        authCode,
        redirectUri,
      );

      if (kakaoAccessToken == null) {
        throw Exception('카카오 Access Token을 받을 수 없습니다');
      }

      AppLogger.success('[Step 2] 카카오 Access Token 받음');

      // 백엔드로 카카오 Access Token 전달
      AppLogger.auth('[Step 3] 백엔드로 Access Token 전달');
      final authResponse =
          await authApi.loginWithKakaoAccessToken(kakaoAccessToken);

      AppLogger.success('[Step 4] 백엔드 인증 성공');

      // JWT 토큰 로컬 스토리지에 저장
      await StorageService.saveTokens(
        authResponse.accessToken,
        authResponse.refreshToken,
      );

      AppLogger.success('[Step 5] JWT 토큰 저장 완료');

      // 사용자 정보 설정
      _currentUser = authResponse.user;
      _isLoggedIn = true;

      AppLogger.success('카카오 로그인 완료!');
      AppLogger.debug('  - 사용자 ID: ${_currentUser!.id}');
      AppLogger.debug('  - 이름: ${_currentUser!.name}');
      AppLogger.debug('  - 이메일: ${_currentUser!.email}');
      AppLogger.debug('  - 신규 사용자: ${authResponse.isNewUser}');

      _setLoading(false);
    } catch (e) {
      AppLogger.error('카카오 로그인 실패: $e');
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    try {
      // 1. 카카오 로그아웃
      await kakaoAuthService.logout();

      // 2. 로컬 스토리지 삭제
      await StorageService.clearAll();

      // 3. 상태 초기화
      _currentUser = null;
      _isLoggedIn = false;

      notifyListeners();
    } catch (e) {
      AppLogger.error('로그아웃 실패: $e');
    }
  }

  /// 비회원 세션 연동
  Future<void> linkGuestSession(String sessionId) async {
    try {
      await authApi.linkGuestSession(sessionId);
      AppLogger.success('비회원 세션 연동 완료');
    } catch (e) {
      AppLogger.error('세션 연동 실패: $e');
      rethrow;
    }
  }

  // Private methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }
}
