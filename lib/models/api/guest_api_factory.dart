import '../entities/question_model.dart';
import '../entities/guest_answer_model.dart';
import '../entities/guest_result_model.dart';
import 'guest_api.dart';
import 'mock_guest_api.dart';
import '../../core/constants.dart';

/// Guest API 인터페이스
/// Real API와 Mock API 모두 이 인터페이스를 구현
abstract class IGuestApi {
  Future<String> createSession();
  Future<List<Question>> getQuestions();
  Future<void> submitAnswers(String sessionId, List<GuestAnswer> answers);
  Future<GuestResult> getResult(String sessionId);
}

/// Guest API Factory
/// 환경 변수에 따라 Real API 또는 Mock API 반환
class GuestApiFactory {
  static IGuestApi create() {
    // 환경 변수 USE_MOCK_API가 true인 경우에만 Mock 사용
    // localhost여도 실제 백엔드 API를 사용 (백엔드 서버가 실행 중이어야 함)
    final useMock =
        const bool.fromEnvironment('USE_MOCK_API', defaultValue: false);

    if (useMock) {
      print('🔶 [API] Mock API 사용 (USE_MOCK_API=true)');
      return MockGuestApiAdapter();
    } else {
      print('🌐 [API] Real API 사용: ${AppConstants.apiBaseUrl}');
      print('   백엔드 서버가 실행 중인지 확인하세요.');
      return RealGuestApiAdapter();
    }
  }
}

/// Real Guest API Adapter
/// 기존 GuestApi를 IGuestApi 인터페이스에 맞춤
class RealGuestApiAdapter implements IGuestApi {
  final _api = guestApi;

  @override
  Future<String> createSession() => _api.createSession();

  @override
  Future<List<Question>> getQuestions() => _api.getQuestions();

  @override
  Future<void> submitAnswers(String sessionId, List<GuestAnswer> answers) =>
      _api.submitAnswers(sessionId, answers);

  @override
  Future<GuestResult> getResult(String sessionId) => _api.getResult(sessionId);
}

/// Mock Guest API Adapter
/// MockGuestApi를 IGuestApi 인터페이스에 맞춤
class MockGuestApiAdapter implements IGuestApi {
  final _api = mockGuestApi;

  @override
  Future<String> createSession() => _api.createSession();

  @override
  Future<List<Question>> getQuestions() => _api.getQuestions();

  @override
  Future<void> submitAnswers(String sessionId, List<GuestAnswer> answers) =>
      _api.submitAnswers(sessionId, answers);

  @override
  Future<GuestResult> getResult(String sessionId) => _api.getResult(sessionId);
}

/// 전역 Guest API 인스턴스
/// 앱 전체에서 사용
final guestApiService = GuestApiFactory.create();
