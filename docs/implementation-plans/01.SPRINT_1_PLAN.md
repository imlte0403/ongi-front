# Sprint 1 구현 계획서: 온보딩 플로우 (성격 테스트)

## 📋 목표

비회원 사용자가 앱에 처음 접속하여 성격 테스트를 완료하고 자신에게 맞는 모임 추천을 받을 수 있도록 온보딩 플로우를 구현합니다.

---

## 🎯 범위

### 포함 사항
- ✅ Guest Session 관리 (비회원 세션)
- ✅ 성격 테스트 10문항 UI
- ✅ 진행 상황 표시 및 네비게이션
- ✅ 테스트 결과 화면
- ✅ 매칭 결과 및 모임 추천 TOP 3

### 제외 사항
- ❌ 회원가입/로그인 (Sprint 2)
- ❌ 프로필 생성 (Sprint 2)
- ❌ 실제 모임 참여 (Sprint 2)

---

## 📱 화면 플로우

```
#0 Welcome 페이지
    ↓ [테스트 시작하기]
#1 성격 테스트 Q1
    ↓ [다음]
#2 성격 테스트 Q2-Q9
    ↓ [다음]
#3 성격 테스트 Q10
    ↓ [결과보기]
#4 테스트 결과
    ↓ [모임 찾아보기]
매칭 결과 (비슷한 사람들)
    ↓
#5 모임 추천 TOP 3
    ↓ [프로필 만들고 모임 참여하기]
(Sprint 2로 연결)
```

---

## 🔧 구현 상세

### 1. Guest Session 관리

#### 파일: `lib/models/services/guest_service.dart` [NEW]

**기능**:
- Guest Session ID 생성 및 저장
- 세션 유효성 확인
- 로컬 스토리지에 저장

**API**:
```http
POST /api/v1/guest/session

Response:
{
  "success": true,
  "data": {
    "session_id": "a1b2c3d4e5f6...",
    "expires_at": "2024-12-28T10:00:00Z"
  },
  "message": "Guest session created. Save this session_id to retrieve your results later."
}
```

**백엔드 실제 구현 확인됨** ✅

**로직**:
1. 앱 시작 시 로컬 스토리지 확인
2. 기존 세션 ID 없으면 API 호출하여 생성
3. StorageService에 저장
4. 이후 모든 비회원 API 요청에 세션 ID 포함

---

### 2. 성격 테스트 데이터 모델

#### 파일: `lib/models/entities/question_model.dart` [NEW]

```dart
// 백엔드 응답에 맞춘 모델
class Question {
  final int id;
  final String text;
  final List<QuestionOption> options;  // 4개 옵션
  
  Question({
    required this.id,
    required this.text,
    required this.options,
  });
  
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      options: (json['options'] as List)
          .map((o) => QuestionOption.fromJson(o))
          .toList(),
    );
  }
}

class QuestionOption {
  final int id;                      // 백엔드는 int 사용
  final String text;
  final double socialityScore;       // 사교성
  final double activityScore;        // 활동성
  final double intimacyScore;        // 친밀도
  final double immersionScore;       // 몰입도
  final double flexibilityScore;     // 유연성
  
  QuestionOption({
    required this.id,
    required this.text,
    required this.socialityScore,
    required this.activityScore,
    required this.intimacyScore,
    required this.immersionScore,
    required this.flexibilityScore,
  });
  
  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'],
      text: json['text'],
      socialityScore: (json['sociality_score'] ?? 0).toDouble(),
      activityScore: (json['activity_score'] ?? 0).toDouble(),
      intimacyScore: (json['intimacy_score'] ?? 0).toDouble(),
      immersionScore: (json['immersion_score'] ?? 0).toDouble(),
      flexibilityScore: (json['flexibility_score'] ?? 0).toDouble(),
    );
  }
}

class GuestAnswer {
  final int questionId;
  final int optionId;     // 백엔드는 int 사용
  
  GuestAnswer({
    required this.questionId,
    required this.optionId,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'option_id': optionId,
    };
  }
}
```

#### 파일: `lib/models/entities/test_result_model.dart` [NEW]

```dart
// 백엔드 /guest/result API 응답에 맞춘 모델
class GuestResult {
  final String sessionId;
  final bool isLinked;
  final GuestScores scores;
  final String profileType;
  final List<String> descriptions;
  final GuestRecommendations recommendations;
  final String expiresAt;
  
  GuestResult({
    required this.sessionId,
    required this.isLinked,
    required this.scores,
    required this.profileType,
    required this.descriptions,
    required this.recommendations,
    required this.expiresAt,
  });
  
  factory GuestResult.fromJson(Map<String, dynamic> json) {
    return GuestResult(
      sessionId: json['session_id'],
      isLinked: json['is_linked'],
      scores: GuestScores.fromJson(json['scores']),
      profileType: json['profile_type'],
      descriptions: List<String>.from(json['descriptions']),
      recommendations: GuestRecommendations.fromJson(json['recommendations']),
      expiresAt: json['expires_at'],
    );
  }
}

class GuestScores {
  final double socialityScore;      // 사교성
  final double activityScore;       // 활동성
  final double intimacyScore;       // 친밀도
  final double immersionScore;      // 몰입도
  final double flexibilityScore;    // 유연성
  
  GuestScores({
    required this.socialityScore,
    required this.activityScore,
    required this.intimacyScore,
    required this.immersionScore,
    required this.flexibilityScore,
  });
  
  factory GuestScores.fromJson(Map<String, dynamic> json) {
    return GuestScores(
      socialityScore: (json['sociality_score'] ?? 0).toDouble(),
      activityScore: (json['activity_score'] ?? 0).toDouble(),
      intimacyScore: (json['intimacy_score'] ?? 0).toDouble(),
      immersionScore: (json['immersion_score'] ?? 0).toDouble(),
      flexibilityScore: (json['flexibility_score'] ?? 0).toDouble(),
    );
  }
}

class GuestRecommendations {
  final List<Club> clubs;
  final List<Club> similarClubs;
  final List<Meeting> meetings;
  
  GuestRecommendations({
    required this.clubs,
    required this.similarClubs,
    required this.meetings,
  });
  
  factory GuestRecommendations.fromJson(Map<String, dynamic> json) {
    return GuestRecommendations(
      clubs: (json['clubs'] as List?)?.map((c) => Club.fromJson(c)).toList() ?? [],
      similarClubs: (json['similar_clubs'] as List?)?.map((c) => Club.fromJson(c)).toList() ?? [],
      meetings: (json['meetings'] as List?)?.map((m) => Meeting.fromJson(m)).toList() ?? [],
    );
  }
}

// Club 모델 (간단 버전)
class Club {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  
  Club({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
  });
  
  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }
}

// Meeting 모델 (간단 버전)
class Meeting {
  final int id;
  final String title;
  final String? location;
  
  Meeting({
    required this.id,
    required this.title,
    this.location,
  });
  
  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'],
      title: json['title'],
      location: json['location'],
    );
  }
}
```

---

### 3. 성격 테스트 ViewModel

#### 파일: `lib/viewmodels/personality_test_viewmodel.dart` [NEW]

**책임**:
- 질문 데이터 로드
- 답변 상태 관리
- 현재 질문 인덱스 관리
- API 연동 (질문 가져오기, 답변 제출)

**상태**:
```dart
class PersonalityTestViewModel extends ChangeNotifier {
  List<Question> questions = [];
  List<TestAnswer> answers = [];
  int currentQuestionIndex = 0;
  bool isLoading = false;
  
  // 메서드
  Future<void> loadQuestions();
  void selectAnswer(String optionId);
  void nextQuestion();
  void previousQuestion();
  Future<TestResult?> submitAnswers();
}
```

---

### 4. UI 구현

#### 파일: `lib/views/pages/onboarding/personality_test_page.dart` [NEW]

**화면 #1-3: 성격 테스트 질문**

레이아웃:
```
┌─────────────────────────────┐
│ [←]  성격 테스트             │  <- AppBar
├─────────────────────────────┤
│                             │
│  [질문 1] ← 녹색 뱃지         │
│                             │
│  금요일 저녁, 친구가          │  <- Body Large
│  갑자기 밖으로 불러냈다.       │
│  이때 당신의 반응은?          │
│                             │
│  ┌────────────────────┐     │
│  │ 선택지 1            │     │  <- 4개 선택지 버튼
│  └────────────────────┘     │
│  ┌────────────────────┐     │
│  │ 선택지 2            │  ✓  │  <- 선택됨 (Primary color)
│  └────────────────────┘     │
│  ┌────────────────────┐     │
│  │ 선택지 3            │     │
│  └────────────────────┘     │
│  ┌────────────────────┐     │
│  │ 선택지 4            │     │
│  └────────────────────┘     │
│                             │
│  ━━━━━━━━━━ 1/10           │  <- 진행 바
│                             │
│  [이전]          [다음] →   │  <- 하단 버튼
└─────────────────────────────┘
```

**컴포넌트**:
- `QuestionCard` (질문 표시)
- `OptionButton` (선택지 버튼)
- `ProgressBar` (진행 상황)

---

#### 파일: `lib/views/pages/onboarding/test_result_page.dart` [NEW]

**화면 #4: 테스트 결과**

레이아웃:
```
┌─────────────────────────────┐
│        결과                 │  <- AppBar
├─────────────────────────────┤
│                             │
│     균형형 조화자            │  <- Display (28pt Bold)
│                             │
│    🧑‍🤝‍🧑 일러스트           │
│                             │
│  ✓ 당신은 상황에 따라...     │  <- 특성 3가지
│  ✓ 다양한 활동을 즐기고...   │
│  ✓ 그룹의 분위기를...        │
│                             │
│  결과 요약                   │  <- Section Title
│  사교성  ████████░░ 85      │  <- 진행 바 4개
│  활동성  ████░░░░░░ 45      │
│  친밀도  █████░░░░░ 58      │
│  몰입도  ████████░░ 80      │
│                             │
│  추천 활동                   │
│  🧘‍♀️ 요가/명상               │  <- 4개 활동
│  몸과 마음의 균형 찾기        │
│  ...                        │
│                             │
│  비슷한 사람들의 인기 모임    │
│  (카드 3개)                 │
│                             │
│  [모임 찾아보기]             │  <- Primary 버튼
└─────────────────────────────┘
```

---

#### 파일: `lib/views/pages/onboarding/matching_result_page.dart` [NEW]

**화면: 매칭 결과**

레이아웃:
```
┌─────────────────────────────┐
│ [←] 당신과 비슷한 사람들      │  <- AppBar
├─────────────────────────────┤
│                             │
│  ┌──┐ ┌──┐ ┌──┐           │  <- 비슷한 성격 유형 카드
│  │🧑 │ │🧑 │ │🧑 │           │     (횡 스크롤)
│  └──┘ └──┘ └──┘           │
│                             │
│  모임 카테고리 통계           │
│  ┌─────┬─────┐             │  <- 2x2 그리드
│  │ 🏃 │ 🎨 │             │
│  │ 32% │ 28% │             │
│  ├─────┼─────┤             │
│  │ 🎵 │ 📚 │             │
│  │ 25% │ 15% │             │
│  └─────┴─────┘             │
│                             │
│     일러스트                │
│                             │
│  [나에게 맞는 모임 찾기]      │
│                             │
│  ● ○                       │  <- 페이지 인디케이터
└─────────────────────────────┘
```

---

#### 파일: `lib/views/pages/onboarding/club_recommendation_page.dart` [NEW]

**화면 #5: 모임 추천 TOP 3**

레이아웃:
```
┌─────────────────────────────┐
│ [←] 당신을 위한 모임 TOP 3    │  <- AppBar
├─────────────────────────────┤
│                             │
│  ┌─────────────────────┐   │  <- 모임 카드 #1
│  │ 🏃‍♂️ 주말 러닝 크루    │   │
│  │ [92% 매칭]           │   │  <- 매칭률 뱃지
│  │ 32명 · ⭐ 4.8       │   │
│  │                     │   │
│  │ 매주 토요일 아침,     │   │
│  │ 한강에서...          │   │
│  │                     │   │
│  │ 📍한강 뚝섬·주 1회    │   │
│  └─────────────────────┘   │
│                             │
│  ┌─────────────────────┐   │  <- 모임 카드 #2
│  │ 🎨 평일 드로잉 클럽   │   │
│  │ [88% 매칭]           │   │
│  │ ...                 │   │
│  └─────────────────────┘   │
│                             │
│  ┌─────────────────────┐   │  <- 모임 카드 #3
│  │ 📚 북클럽           │   │
│  │ [81% 매칭]           │   │
│  │ ...                 │   │
│  └─────────────────────┘   │
│                             │
│  [프로필 만들고 모임 참여하기] │  <- Primary 버튼
│                             │
│  ○ ●                       │  <- 페이지 인디케이터
└─────────────────────────────┘
```

---

### 5. API 연동 (백엔드 실제 엔드포인트)

#### 파일: `lib/models/api/guest_api.dart` [NEW]

```dart
import 'package:dio/dio.dart';
import '../entities/question_model.dart';
import '../entities/guest_result_model.dart';
import 'api_client.dart';

class GuestApi {
  final Dio _dio = apiClient.dio;
  
  // 1. Guest Session 생성
  Future<String> createSession() async {
    try {
      final response = await _dio.post('/guest/session');
      return response.data['data']['session_id'];
    } catch (e) {
      throw Exception('세션 생성 실패: $e');
    }
  }
  
  // 2. 질문 목록 조회
  Future<List<Question>> getQuestions() async {
    try {
      final response = await _dio.get('/questions');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Question.fromJson(json)).toList();
    } catch (e) {
      throw Exception('질문 조회 실패: $e');
    }
  }
  
  // 3. 답변 제출
  Future<void> submitAnswers(String sessionId, List<GuestAnswer> answers) async {
    try {
      await _dio.post('/guest/answers', data: {
        'session_id': sessionId,
        'answers': answers.map((a) => a.toJson()).toList(),
      });
    } catch (e) {
      throw Exception('답변 제출 실패: $e');
    }
  }
  
  // 4. 결과 조회
  Future<GuestResult> getResult(String sessionId) async {
    try {
      final response = await _dio.get('/guest/result/$sessionId');
      return GuestResult.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('결과 조회 실패: $e');
    }
  }
}

final guestApi = GuestApi();
```

#### 사용 예시

```dart
// 앱 시작 시 세션 생성
final sessionId = await guestApi.createSession();
await StorageService.saveSessionId(sessionId);

// 질문 로드
final questions = await guestApi.getQuestions();

// 답변 제출
final answers = [
  GuestAnswer(questionId: 1, optionId: 3),
  GuestAnswer(questionId: 2, optionId: 2),
  // ... 총 10개
];
await guestApi.submitAnswers(sessionId, answers);

// 결과 조회
final result = await guestApi.getResult(sessionId);
print(result.profileType);  // "도전적인 탐험가"
print(result.scores.socialityScore);  // 65.0
```

---

### 6. 공통 위젯

#### 파일: `lib/views/widgets/common/progress_bar.dart` [NEW]
- 진행 상황 표시 (N/10)
- Primary 색상 사용

#### 파일: `lib/views/widgets/common/custom_button.dart` [NEW]
- Primary, Secondary, Outlined 버튼 타입
- 디자인 시스템 적용

#### 파일: `lib/views/widgets/question/question_option_button.dart` [NEW]
- 4개 선택지를 표시하는 버튼
- 선택 시 Primary 색상 배경
- 미선택 시 Border만 표시

---

## 🔄 상태 관리

**Provider를 사용한 상태 관리**:

```dart
// main.dart 수정
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => PersonalityTestViewModel()),
  ],
  child: OngiApp(),
)
```

---

## 🎨 디자인 적용

### 색상
- Primary (#28B16E): 선택된 답변, 버튼, 진행 바
- Secondary (#D9F7E8): 배경 강조
- Success (#208E58): 매칭률 뱃지

### 타이포그래피
- Display (28pt Bold): 성격 유형명
- Page Title (24pt Bold): "성격 테스트"
- Section Title (20pt Semibold): "결과 요약", "추천 활동"
- Card Title (18pt Semibold): 모임 카드 제목
- Body Large (17pt Regular): 질문 텍스트
- Body (16pt Regular): 선택지, 설명
- Caption (12pt Regular): 메타 정보

### 간격
- lg (24px): 화면 좌우 패딩
- md (16px): 카드 내부, 요소 간 간격
- sm (8px): 버튼 내 작은 간격

---

## ✅ 검증 계획

### 수동 테스트
1. Welcome 페이지에서 "테스트 시작하기" 버튼 클릭
2. 10개 질문 모두 답변 가능한지 확인
3. 이전/다음 버튼 동작 확인
4. 진행 표시 업데이트 확인
5. 결과 화면에 성격 유형, 점수, 추천 활동 표시 확인
6. 추천 모임 TOP 3 표시 확인

### API 연동 테스트
- Guest Session 생성 및 저장
- 질문 데이터 로드
- 답변 제출 및 결과 수신
- 추천 모임 데이터 수신

---

## 📝 체크리스트

### 데이터 모델
- [ ] Question, QuestionOption 모델 (4개 옵션)
- [ ] GuestAnswer 모델
- [ ] GuestResult, GuestScores, GuestRecommendations 모델
- [ ] Club, Meeting 모델

### API (`lib/models/api/guest_api.dart`)
- [ ] POST /guest/session - 세션 생성
- [ ] GET /questions - 질문 목록 (10개)
- [ ] POST /guest/answers - 답변 제출
- [ ] GET /guest/result/:sessionId - 결과 조회

### ViewModel
- [ ] PersonalityTestViewModel
- [ ] Guest Session 관리 로직

### UI - 페이지
- [ ] PersonalityTestPage (질문 화면)
- [ ] TestResultPage (결과 화면)
- [ ] MatchingResultPage (매칭 결과)
- [ ] ClubRecommendationPage (모임 추천)

### UI - 위젯
- [ ] ProgressBar
- [ ] CustomButton
- [ ] QuestionOptionButton (4개 옵션 지원)
- [ ] ScoreBar (점수 표시 진행 바)
- [ ] ClubCard (모임 카드)

### 네비게이션
- [ ] Welcome → Test 화면 연결
- [ ] 질문 간 이동
- [ ] Test → Result → Matching → Recommendation 플로우

### 상태 관리
- [ ] Provider 설정
- [ ] ViewModel 연결

---

## 📅 예상 작업 시간

- 데이터 모델: 1-2시간
- API 레이어: 2-3시간
- ViewModel: 2-3시간
- UI 구현: 4-6시간
- 테스트 및 버그 수정: 2-3시간

**총 예상 시간**: 11-17시간

---

**작성일**: 2025-11-30
**Sprint**: 1
**버전**: 1.0
