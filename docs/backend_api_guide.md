# 백엔드 API 통신 가이드

## 📋 백엔드 기술 스택

### 핵심 기술
| 기술 | 버전 | 용도 |
|------|------|------|
| **Go** | 1.21+ | 프로그래밍 언어 |
| **Fiber** | v2 | 웹 프레임워크 (Express.js와 유사) |
| **GORM** | - | ORM (데이터베이스 매핑) |
| **PostgreSQL** | 16 | 관계형 데이터베이스 |
| **Docker** | - | 컨테이너화 |
| **Kubernetes (Helm)** | - | 배포 및 오케스트레이션 |

### 특징
- **고성능**: Go의 동시성 처리 (고루틴)
- **빠른 응답**: Fiber는 Express.js보다 빠름
- **타입 안정성**: Go의 정적 타입 시스템
- **확장성**: Kubernetes 기반 배포

---

## 🌐 API 구조

### Base URL

| 환경 | URL |
|------|-----|
| **로컬 개발** | `http://localhost:3000/api/v1` |
| **도커** | `http://localhost:5000/api/v1` |
| **프로덕션** | `https://api.ongi.com/v1` (예정) |

### API 버전
- 현재: **v1**
- 모든 엔드포인트 앞에 `/api/v1` 붙음

---

## 🔐 인증 방식

### 현재 상태
⚠️ **JWT 인증 미구현** (Sprint 3에서 추가 예정)

### 계획된 구조
```
1. 카카오 로그인
2. 백엔드에서 JWT 토큰 발급
3. 이후 모든 요청에 Authorization 헤더 포함
```

**인증 헤더 형식** (Sprint 3 이후):
```
Authorization: Bearer {access_token}
```

### 현재 사용 (Sprint 1-2)
- **비회원 세션 ID** 사용
- 로컬 스토리지에 `session_id` 저장
- API 요청 시 body에 `session_id` 포함

---

## 📡 HTTP 통신 방식

### REST API
모든 API는 RESTful 형식을 따름

| Method | 용도 | 예시 |
|--------|------|------|
| **GET** | 데이터 조회 | `GET /clubs` |
| **POST** | 데이터 생성 | `POST /users` |
| **PUT/PATCH** | 데이터 수정 | `PUT /users/:id` |
| **DELETE** | 데이터 삭제 | `DELETE /clubs/:id` |

### Content-Type
```
Content-Type: application/json
```

모든 요청과 응답은 **JSON 형식**

---

## 📨 요청/응답 형식

### 표준 응답 구조

#### 성공 응답
```json
{
  "success": true,
  "data": {
    // 실제 데이터
  },
  "message": "작업 완료" // 선택사항
}
```

#### 에러 응답
```json
{
  "error": "에러 메시지"
}
```

### HTTP 상태 코드

| 코드 | 의미 | 사용 예시 |
|------|------|-----------|
| **200** | OK | 조회 성공 |
| **201** | Created | 생성 성공 |
| **400** | Bad Request | 잘못된 요청 |
| **404** | Not Found | 리소스 없음 |
| **500** | Internal Server Error | 서버 에러 |

---

## 🔌 API 엔드포인트

### 1. 비회원 설문 (Guest API)

#### 1.1 세션 생성
**비회원이 설문을 시작할 때 호출**

```http
POST /api/v1/guest/session
Content-Type: application/json
```

**요청 Body**: 없음

**응답**:
```json
{
  "success": true,
  "data": {
    "session_id": "a1b2c3d4e5f6...",
    "expires_at": "2024-12-28T10:00:00Z"
  },
  "message": "Guest session created. Save this session_id to retrieve your results later."
}
```

**Flutter 예제**:
```dart
Future<String> createGuestSession() async {
  final response = await dio.post('/guest/session');
  final sessionId = response.data['data']['session_id'];
  
  // 로컬 스토리지에 저장
  await StorageService.saveSessionId(sessionId);
  
  return sessionId;
}
```

---

#### 1.2 비회원 답변 제출

```http
POST /api/v1/guest/answers
Content-Type: application/json
```

**요청 Body**:
```json
{
  "session_id": "a1b2c3d4e5f6...",
  "answers": [
    {"question_id": 1, "option_id": 3},
    {"question_id": 2, "option_id": 4},
    // ... 총 10개
  ]
}
```

**응답**:
```json
{
  "success": true,
  "message": "Answers submitted successfully"
}
```

**Flutter 예제**:
```dart
Future<void> submitGuestAnswers(String sessionId, List<Answer> answers) async {
  await dio.post('/guest/answers', data: {
    'session_id': sessionId,
    'answers': answers.map((a) => {
      'question_id': a.questionId,
      'option_id': a.optionId,
    }).toList(),
  });
}
```

---

#### 1.3 비회원 결과 조회

```http
GET /api/v1/guest/result/:sessionId
```

**응답**:
```json
{
  "success": true,
  "data": {
    "session_id": "a1b2c3d4e5f6...",
    "is_linked": false,
    "scores": {
      "sociality_score": 65.0,
      "activity_score": 75.0,
      "intimacy_score": 55.0,
      "immersion_score": 80.0,
      "flexibility_score": 60.0
    },
    "profile_type": "도전적인 탐험가",
    "descriptions": [
      "당신은 상황에 따라 유연하게 대처하며...",
      // ...
    ],
    "recommendations": {
      "clubs": [...],
      "similar_clubs": [...],
      "meetings": [...]
    },
    "expires_at": "2024-12-28T10:00:00Z"
  }
}
```

---

### 2. 성격 테스트

#### 2.1 질문 목록 조회

```http
GET /api/v1/questions
```

**응답**:
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "text": "금요일 저녁, 친구가 갑자기 밖으로 불러냈다. 이때 당신의 반응은?",
      "options": [
        {
          "id": 1,
          "text": "좋아! 바로 나갈게!",
          "sociality_score": 5,
          "activity_score": 5,
          // ...
        },
        // ... 5개 옵션
      ]
    },
    // ... 총 10개 질문
  ]
}
```

**Flutter 예제**:
```dart
Future<List<Question>> getQuestions() async {
  final response = await dio.get('/questions');
  final List<dynamic> data = response.data['data'];
  return data.map((json) => Question.fromJson(json)).toList();
}
```

---

### 3. 클럽/모임

#### 3.1 클럽 목록 조회

```http
GET /api/v1/clubs
```

**응답**:
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "러닝 크루",
      "description": "함께 달리며 건강을 챙기는 모임",
      "category": "운동",
      "image_url": "https://...",
      "member_count": 15,
      "max_members": 30,
      "location": "한강공원",
      "vibe": "energetic",
      "meeting_frequency": "주 2회"
    },
    // ...
  ]
}
```

---

#### 3.2 클럽 상세 조회

```http
GET /api/v1/clubs/:id
```

**응답**:
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "러닝 크루",
    "description": "...",
    "members": [
      {
        "id": 1,
        "user_id": 5,
        "joined_at": "2024-01-01T00:00:00Z",
        "user": {
          "id": 5,
          "name": "홍길동",
          "email": "hong@example.com"
        }
      },
      // ...
    ]
  }
}
```

---

#### 3.3 클럽 가입

```http
POST /api/v1/clubs/join
Content-Type: application/json
```

**요청 Body**:
```json
{
  "user_id": 1,
  "club_id": 5
}
```

**응답**:
```json
{
  "success": true,
  "message": "Successfully joined club",
  "data": {
    "id": 10,
    "user_id": 1,
    "club_id": 5,
    "joined_at": "2024-11-30T12:00:00Z"
  }
}
```

**Flutter 예제**:
```dart
Future<void> joinClub(int userId, int clubId) async {
  await dio.post('/clubs/join', data: {
    'user_id': userId,
    'club_id': clubId,
  });
}
```

---

### 4. 모임 (Meeting)

#### 4.1 모임 목록

```http
GET /api/v1/meetings
```

#### 4.2 모임 생성

```http
POST /api/v1/meetings
Content-Type: application/json
```

**요청 Body**:
```json
{
  "title": "주말 러닝",
  "description": "한강에서 10km 달리기",
  "club_id": 1,
  "location": "한강공원 반포지구",
  "scheduled_at": "2024-12-21T09:00:00Z",
  "max_members": 20,
  "category": "운동"
}
```

---

## 🔧 CORS 설정

### 문제
Flutter Web은 다른 도메인에서 실행되므로 CORS 설정 필요

### 백엔드 설정 (확인 필요)
```go
// main.go에 있어야 함
app.Use(cors.New(cors.Config{
    AllowOrigins: "*",
    AllowMethods: "GET,POST,PUT,DELETE,OPTIONS",
    AllowHeaders: "Content-Type,Authorization",
}))
```

### 프론트엔드 대응
개발 시 프록시 사용 가능:
```bash
flutter run -d chrome --web-port=8080 --web-hostname=localhost
```

---

## ⚠️ 에러 처리

### 에러 응답 형식
```json
{
  "error": "Failed to fetch clubs"
}
```

### Flutter에서 에러 처리
```dart
try {
  final response = await dio.get('/clubs');
  return response.data['data'];
} on DioException catch (e) {
  if (e.response != null) {
    // 서버 에러
    final errorMsg = e.response!.data['error'] ?? '알 수 없는 에러';
    throw Exception(errorMsg);
  } else {
    // 네트워크 에러
    throw Exception('네트워크 연결을 확인해주세요');
  }
}
```

---

## 📚 Flutter Dio 완전한 예제

### API 클래스 예제

```dart
// lib/models/api/guest_api.dart
import 'package:dio/dio.dart';
import 'api_client.dart';

class GuestApi {
  final Dio _dio = apiClient.dio;
  
  // 세션 생성
  Future<String> createSession() async {
    try {
      final response = await _dio.post('/guest/session');
      return response.data['data']['session_id'];
    } catch (e) {
      throw Exception('세션 생성 실패: $e');
    }
  }
  
  // 답변 제출
  Future<void> submitAnswers(String sessionId, List<Map<String, int>> answers) async {
    try {
      await _dio.post('/guest/answers', data: {
        'session_id': sessionId,
        'answers': answers,
      });
    } catch (e) {
      throw Exception('답변 제출 실패: $e');
    }
  }
  
  // 결과 조회
  Future<Map<String, dynamic>> getResult(String sessionId) async {
    try {
      final response = await _dio.get('/guest/result/$sessionId');
      return response.data['data'];
    } catch (e) {
      throw Exception('결과 조회 실패: $e');
    }
  }
}
```

---

## 🧪 API 테스트 방법

### 1. curl로 테스트
```bash
# 세션 생성
curl -X POST http://localhost:3000/api/v1/guest/session

# 질문 조회
curl http://localhost:3000/api/v1/questions

# 클럽 목록
curl http://localhost:3000/api/v1/clubs
```

### 2. Postman 사용
1. Collection 생성
2. Base URL 변수: `{{base_url}}` = `http://localhost:3000/api/v1`
3. 각 엔드포인트 테스트

### 3. Flutter에서 디버깅
```dart
// API Client의 인터셉터 로그 확인
print('🚀 요청: ${options.method} ${options.path}');
print('✅ 응답: ${response.statusCode}');
```

---

## 📝 주의사항

1. **세션 ID 관리**
   - 비회원 세션 ID는 반드시 로컬 스토리지에 저장
   - 7일 후 자동 만료

2. **에러 처리**
   - 모든 API 호출에 try-catch 적용
   - 사용자에게 친절한 에러 메시지 표시

3. **타임아웃**
   - 연결 타임아웃: 5초
   - 응답 타임아웃: 3초
   - 느린 응답 시 로딩 UI 표시

4. **CORS**
   - 개발 시 로컬 서버와 통신 문제 발생 가능
   - 백엔드 CORS 설정 확인 필요

---

## 🚀 다음 단계

- **Sprint 1**: Guest API 연동 (세션 생성, 답변 제출, 결과 조회)
- **Sprint 3**: 카카오 로그인 및 JWT 인증 추가
- **Sprint 5**: WebSocket 채팅 연동

---

**문서 버전**: 1.0.0  
**최종 수정**: 2024-11-30
