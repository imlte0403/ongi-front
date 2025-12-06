import 'package:dio/dio.dart';
import 'package:ongi_front/models/entities/question_model.dart';
import 'package:ongi_front/models/entities/guest_answer_model.dart';
import 'package:ongi_front/models/entities/guest_result_model.dart';
import 'package:ongi_front/models/api/api_client.dart';
import 'package:ongi_front/utils/app_logger.dart';

/// 비회원(Guest) API 클라이언트
/// 백엔드 Guest API 엔드포인트와 통신
class GuestApi {
  final Dio _dio = apiClient.dio;

  /// 1. Guest Session 생성
  /// POST /api/v1/guest/session
  ///
  /// 비회원 사용자의 세션 ID를 생성합니다.
  /// 세션 ID는 7일간 유효하며, 이후 모든 비회원 API 요청에 사용됩니다.
  Future<String> createSession() async {
    try {
      final response = await _dio.post('/guest/session');
      final sessionId = response.data['data']['session_id'] as String;
      AppLogger.success('Guest Session 생성 성공: $sessionId');
      return sessionId;
    } on DioException catch (e) {
      AppLogger.error('Guest Session 생성 실패: ${e.message}');
      if (e.response != null) {
        final errorMsg = e.response!.data['error'] ?? '알 수 없는 에러';
        throw Exception('세션 생성 실패: $errorMsg');
      }
      throw Exception('네트워크 연결을 확인해주세요');
    }
  }

  /// 2. 질문 목록 조회
  /// GET /api/v1/questions
  ///
  /// 성격 테스트 질문 10개를 조회합니다.
  /// 각 질문은 4개의 선택지를 가지며, 각 선택지는 5개의 점수를 포함합니다.
  Future<List<Question>> getQuestions() async {
    try {
      final response = await _dio.get('/questions');
      final List<dynamic> data = response.data['data'] as List;
      final questions = data
          .map((json) => Question.fromJson(json as Map<String, dynamic>))
          .toList();
      AppLogger.success('질문 ${questions.length}개 조회 성공');
      return questions;
    } on DioException catch (e) {
      AppLogger.error('질문 조회 실패: ${e.message}');
      if (e.response != null) {
        final errorMsg = e.response!.data['error'] ?? '알 수 없는 에러';
        throw Exception('질문 조회 실패: $errorMsg');
      }
      throw Exception('네트워크 연결을 확인해주세요');
    }
  }

  /// 3. 답변 제출
  /// POST /api/v1/guest/answers
  ///
  /// 비회원 사용자의 답변을 제출합니다.
  /// 총 10개의 답변을 모두 제출해야 합니다.
  Future<void> submitAnswers(
    String sessionId,
    List<GuestAnswer> answers,
  ) async {
    try {
      await _dio.post('/guest/answers', data: {
        'session_id': sessionId,
        'answers': answers.map((a) => a.toJson()).toList(),
      });
      AppLogger.success('답변 ${answers.length}개 제출 성공');
    } on DioException catch (e) {
      AppLogger.error('답변 제출 실패: ${e.message}');
      if (e.response != null) {
        final errorMsg = e.response!.data['error'] ?? '알 수 없는 에러';
        throw Exception('답변 제출 실패: $errorMsg');
      }
      throw Exception('네트워크 연결을 확인해주세요');
    }
  }

  /// 4. 결과 조회
  /// GET /api/v1/guest/result/:sessionId
  ///
  /// 제출한 답변에 대한 분석 결과를 조회합니다.
  /// 성격 유형, 점수, 추천 모임 등이 포함됩니다.
  Future<GuestResult> getResult(String sessionId) async {
    try {
      final response = await _dio.get('/guest/result/$sessionId');
      // 디버그 로그
      AppLogger.debug('GUEST API status: ${response.statusCode}');
      AppLogger.debug('GUEST API data type: ${response.data.runtimeType}');
      AppLogger.debug('GUEST API raw data: ${response.data}');

      final result = GuestResult.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
      AppLogger.success('결과 조회 성공: ${result.profileType}');
      return result;
    } on DioException catch (e) {
      AppLogger.error('결과 조회 실패: ${e.message}');
      if (e.response != null) {
        final errorMsg = e.response!.data['error'] ?? '알 수 없는 에러';
        throw Exception('결과 조회 실패: $errorMsg');
      }
      throw Exception('네트워크 연결을 확인해주세요');
    }
  }
}

/// GuestApi 싱글톤 인스턴스
final guestApi = GuestApi();
