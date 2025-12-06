import 'package:dio/dio.dart';
import 'api_client.dart';

/// 프로필 API
class ProfileApi {
  final Dio _dio = apiClient.dio;

  /// 프로필 생성/수정
  ///
  /// 사용자의 성향 프로필을 생성하거나 수정합니다.
  Future<Map<String, dynamic>> createOrUpdateProfile({
    required int userId,
    double? socialityScore,
    double? activityScore,
    double? intimacyScore,
    double? immersionScore,
    double? flexibilityScore,
    String? resultSummary,
    String? profileType,
  }) async {
    try {
      print('📝 [프로필] 프로필 생성/수정 요청');

      final response = await _dio.post('/users/profile', data: {
        'user_id': userId,
        if (socialityScore != null) 'sociality_score': socialityScore,
        if (activityScore != null) 'activity_score': activityScore,
        if (intimacyScore != null) 'intimacy_score': intimacyScore,
        if (immersionScore != null) 'immersion_score': immersionScore,
        if (flexibilityScore != null) 'flexibility_score': flexibilityScore,
        if (resultSummary != null) 'result_summary': resultSummary,
        if (profileType != null) 'profile_type': profileType,
      });

      print('✅ [프로필] 프로필 저장 완료: ${response.statusCode}');

      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      print('❌ [프로필] 저장 실패: ${e.message}');
      if (e.response != null) {
        print('   응답: ${e.response!.data}');
        final errorMsg = e.response!.data['error'] ?? '프로필 저장 실패';
        throw Exception(errorMsg);
      }
      throw Exception('네트워크 연결을 확인해주세요');
    }
  }

  /// 프로필 조회
  ///
  /// 사용자의 프로필, 성향 분석, 유사 사용자, 추천 클럽 정보를 조회합니다.
  Future<Map<String, dynamic>> getProfile(int userId) async {
    try {
      print('📖 [프로필] 프로필 조회: userId=$userId');

      final response = await _dio.get('/users/$userId/profile');

      print('✅ [프로필] 프로필 조회 완료');

      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      print('❌ [프로필] 조회 실패: ${e.message}');
      if (e.response != null) {
        print('   응답: ${e.response!.data}');
        final errorMsg = e.response!.data['error'] ?? '프로필 조회 실패';
        throw Exception(errorMsg);
      }
      throw Exception('네트워크 연결을 확인해주세요');
    }
  }
}

final profileApi = ProfileApi();

