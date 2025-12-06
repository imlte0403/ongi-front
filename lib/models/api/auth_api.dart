import 'package:dio/dio.dart';
import '../entities/auth_response_model.dart';
import 'api_client.dart';

class AuthApi {
  final Dio _dio = apiClient.dio;

  /// 카카오 Access Token으로 로그인
  ///
  /// 카카오에서 받은 Access Token을 백엔드로 전달하여
  /// JWT 토큰을 받아옵니다.
  Future<AuthResponse> loginWithKakaoAccessToken(String accessToken) async {
    try {
      print('🔑 [백엔드] 카카오 Access Token 전달');

      final response = await _dio.post('/auth/kakao/login', data: {
        'access_token': accessToken,
      });

      print('✅ 백엔드 응답: ${response.statusCode}');

      // API 문서에 따르면 응답 형식: { "success": true, "token": "...", "user": {...}, "is_new_user": true }
      return AuthResponse.fromJson({
        'access_token': response.data['token'],
        'refresh_token': response.data['token'], // 백엔드에서 refresh_token을 제공하지 않으면 token 재사용
        'user': response.data['user'],
        'is_new_user': response.data['is_new_user'] ?? false,
      });
    } on DioException catch (e) {
      print('❌ 백엔드 로그인 실패: ${e.message}');
      if (e.response != null) {
        print('   응답: ${e.response!.data}');
        final errorMsg = e.response!.data['error'] ?? '로그인 실패';
        throw Exception(errorMsg);
      }
      throw Exception('네트워크 연결을 확인해주세요');
    }
  }

  /// 비회원 세션 연동
  Future<void> linkGuestSession(String sessionId) async {
    try {
      print('🔗 [백엔드] 비회원 세션 연동: $sessionId');

      await _dio.post('/guest/link', data: {
        'session_id': sessionId,
      });

      print('✅ 비회원 세션 연동 완료');
    } catch (e) {
      print('❌ 세션 연동 실패: $e');
      throw Exception('세션 연동 실패: $e');
    }
  }

  /// JWT 토큰 갱신
  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post('/auth/refresh', data: {
        'refresh_token': refreshToken,
      });

      return AuthResponse.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('토큰 갱신 실패: $e');
    }
  }
}

final authApi = AuthApi();
