import 'package:flutter/foundation.dart';
import '../models/entities/question_model.dart';
import '../models/entities/guest_answer_model.dart';
import '../models/entities/guest_result_model.dart';
import '../models/api/guest_api_factory.dart';
import '../models/services/storage_service.dart';

/// 성격 테스트 ViewModel
/// Provider로 상태 관리
class PersonalityTestViewModel extends ChangeNotifier {
  // 상태
  List<Question> _questions = [];
  final List<GuestAnswer> _answers = [];
  int _currentQuestionIndex = 0;
  bool _isLoading = false;
  String? _error;
  String? _sessionId;
  GuestResult? _result;

  // Getters
  List<Question> get questions => _questions;
  List<GuestAnswer> get answers => _answers;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get sessionId => _sessionId;
  GuestResult? get result => _result;

  Question? get currentQuestion {
    if (_questions.isEmpty || _currentQuestionIndex >= _questions.length) {
      return null;
    }
    return _questions[_currentQuestionIndex];
  }

  bool get isFirstQuestion => _currentQuestionIndex == 0;
  bool get isLastQuestion =>
      _questions.isNotEmpty && _currentQuestionIndex == _questions.length - 1;

  int? get currentSelectedOption {
    if (_answers.length <= _currentQuestionIndex) return null;
    return _answers[_currentQuestionIndex].optionId;
  }

  double get progress {
    if (_questions.isEmpty) return 0.0;
    return (_currentQuestionIndex + 1) / _questions.length;
  }

  /// 초기화: 세션 생성 및 질문 로드
  Future<void> initialize() async {
    _setLoading(true);
    _setError(null);

    try {
      // 1. 기존 세션 ID 확인
      _sessionId = await StorageService.getSessionId();

      // 2. 세션 ID가 없으면 새로 생성
      if (_sessionId == null || _sessionId!.isEmpty) {
        _sessionId = await guestApiService.createSession();
        await StorageService.saveSessionId(_sessionId!);
      }

      // 3. 질문 로드
      _questions = await guestApiService.getQuestions();

      // 4. 답변 배열 초기화 (10개 질문에 대해 빈 답변)
      _answers.clear();
      for (int i = 0; i < _questions.length; i++) {
        _answers.add(GuestAnswer(
          questionId: _questions[i].id,
          optionId: 0, // 0은 선택 안 함을 의미
        ));
      }

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// 답변 선택
  void selectAnswer(int optionId) {
    if (_currentQuestionIndex >= _answers.length) return;

    _answers[_currentQuestionIndex] = GuestAnswer(
      questionId: _questions[_currentQuestionIndex].id,
      optionId: optionId,
    );
    notifyListeners();
  }

  /// 다음 질문으로 이동
  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  /// 이전 질문으로 이동
  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  /// 특정 질문으로 이동
  void goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  /// 답변 제출 및 결과 조회
  Future<void> submitAnswers() async {
    if (_sessionId == null) {
      _setError('세션 ID가 없습니다');
      return;
    }

    // 모든 질문에 답변했는지 확인
    if (_answers.any((a) => a.optionId == 0)) {
      _setError('모든 질문에 답변해주세요');
      return;
    }

    _setLoading(true);
    _setError(null);

    try {
      // 1. 답변 제출
      await guestApiService.submitAnswers(_sessionId!, _answers);

      // 2. 결과 조회
      _result = await guestApiService.getResult(_sessionId!);

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// 테스트 재시작
  void reset() {
    _currentQuestionIndex = 0;
    _answers.clear();
    for (int i = 0; i < _questions.length; i++) {
      _answers.add(GuestAnswer(
        questionId: _questions[i].id,
        optionId: 0,
      ));
    }
    _result = null;
    _error = null;
    notifyListeners();
  }

  // Private 메서드
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }
}
