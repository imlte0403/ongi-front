import 'package:dio/dio.dart';
import '../entities/auth_response_model.dart';
import 'api_client.dart';

class AuthApi {
  final Dio _dio = apiClient.dio;

  /// 카카오 인가 코드로 로그인
  ///
  /// 카카오에서 받은 인가 코드를 백엔드로 전달하여
  /// JWT 토큰을 받아옵니다.
  Future<AuthResponse> loginWithKakaoAuthCode(String authCode) async {
    try {
      print('🔑 [백엔드] 인가 코드 전달: ${authCode.substring(0, 10)}...');

      final response = await _dio.post('/auth/kakao', data: {
        'code': authCode, // 인가 코드 전달
      });

      print('✅ 백엔드 응답: ${response.statusCode}');

      return AuthResponse.fromJson(response.data['data']);
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
