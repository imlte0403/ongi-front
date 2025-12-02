# 백엔드(ongi-back)와 Flutter(ongi_front) 연결 가이드

## 📋 현재 상태

- **백엔드 위치**: `/Users/taeeunlee/Developing/ongi-back`
- **프론트엔드 위치**: `/Users/taeeunlee/Developing/ongi_front`
- **백엔드 포트**: `3000` (현재 미실행 상태)
- **데이터베이스**: PostgreSQL (localhost:5432)

---

## 🚀 Step 1: 백엔드 서버 실행

### 1.1 PostgreSQL 확인

먼저 PostgreSQL이 실행 중인지 확인:

```bash
# PostgreSQL 상태 확인
brew services list | grep postgresql

# 실행되지 않았다면
brew services start postgresql@16
```

또는 Docker로 실행:

```bash
cd /Users/taeeunlee/Developing/ongi-back
docker-compose up -d postgres
```

### 1.2 데이터베이스 초기화

**처음 실행 시 한 번만**:

```bash
cd /Users/taeeunlee/Developing/ongi-back

# 데이터베이스 시드 (초기 데이터 생성)
go run cmd/seed/main.go
```

이 명령어는:
- 테이블 자동 생성 (마이그레이션)
- 성격 테스트 10개 질문 + 옵션 생성
- 샘플 클럽 데이터 생성

### 1.3 백엔드 서버 실행

```bash
cd /Users/taeeunlee/Developing/ongi-back

# 서버 실행
go run cmd/api/main.go
```

**성공 시 출력 예시**:
```
Server is running on port 3000
Database connected successfully
```

### 1.4 서버 실행 확인

새 터미널에서:

```bash
# Health Check
curl http://localhost:3000/api/v1/health

# 응답 예시:
# {"status":"ok","message":"Server is running"}
```

---

## 🔌 Step 2: Flutter에서 백엔드 연결

### 2.1 API Base URL 설정

**파일**: `ongi_front/lib/core/constants.dart` (이미 생성했을 것)

```dart
class AppConstants {
  // ✅ 로컬 개발용 Base URL
  static const String apiBaseUrl = 'http://localhost:3000/api/v1';
  
  // 나중에 프로덕션용
  // static const String apiBaseUrl = 'https://api.ongi.com/v1';
  
  // ... 나머지 코드
}
```

### 2.2 API Client 설정 (이미 있을 것)

**파일**: `ongi_front/lib/models/api/api_client.dart`

```dart
import 'package:dio/dio.dart';
import '../../core/constants.dart';

class ApiClient {
  late Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseURL: AppConstants.apiBaseUrl, // 👈 localhost:3000/api/v1
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      contentType: 'application/json',
    ));
    
    // 디버깅용 로그
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🚀 [요청] ${options.method} ${options.uri}');
        print('📤 [Body] ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ [응답] ${response.statusCode}');
        print('📥 [Data] ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print('❌ [에러] ${error.message}');
        return handler.next(error);
      },
    ));
  }
  
  Dio get dio => _dio;
}

// 싱글톤
final apiClient = ApiClient();
```

---

## 💡 Step 3: 실제 API 호출 예제

### 3.1 Guest Session 생성 (비회원 시작)

**파일**: `ongi_front/lib/models/api/guest_api.dart` (새로 생성)

```dart
import 'package:dio/dio.dart';
import 'api_client.dart';

class GuestApi {
  final Dio _dio = apiClient.dio;
  
  // 세션 생성
  Future<String> createSession() async {
    try {
      final response = await _dio.post('/guest/session');
      
      // 백엔드 응답 형식: {"success": true, "data": {"session_id": "..."}}
      final sessionId = response.data['data']['session_id'] as String;
      print('✨ 세션 생성 성공: $sessionId');
      
      return sessionId;
    } on DioException catch (e) {
      print('❌ 세션 생성 실패: ${e.message}');
      rethrow;
    }
  }
  
  // 질문 조회
  Future<List<dynamic>> getQuestions() async {
    try {
      final response = await _dio.get('/questions');
      return response.data['data'] as List<dynamic>;
    } on DioException catch (e) {
      print('❌ 질문 조회 실패: ${e.message}');
      rethrow;
    }
  }
  
  // 답변 제출
  Future<void> submitAnswers(String sessionId, List<Map<String, int>> answers) async {
    try {
      await _dio.post('/guest/answers', data: {
        'session_id': sessionId,
        'answers': answers,
      });
      print('✅ 답변 제출 완료');
    } on DioException catch (e) {
      print('❌ 답변 제출 실패: ${e.message}');
      rethrow;
    }
  }
  
  // 결과 조회
  Future<Map<String, dynamic>> getResult(String sessionId) async {
    try {
      final response = await _dio.get('/guest/result/$sessionId');
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      print('❌ 결과 조회 실패: ${e.message}');
      rethrow;
    }
  }
}

// 싱글톤
final guestApi = GuestApi();
```

### 3.2 Flutter에서 사용하기

**파일**: `ongi_front/lib/main.dart` (테스트용)

```dart
import 'package:flutter/material.dart';
import 'models/api/guest_api.dart';

void main() {
  runApp(const OngiApp());
}

class OngiApp extends StatelessWidget {
  const OngiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '온기',
      home: const TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String _status = '대기 중...';
  bool _isLoading = false;

  // 백엔드 연결 테스트
  Future<void> _testBackendConnection() async {
    setState(() {
      _isLoading = true;
      _status = '백엔드 연결 중...';
    });

    try {
      // 1. 세션 생성
      final sessionId = await guestApi.createSession();
      setState(() => _status = '✅ 세션 생성 성공!\nSession ID: $sessionId');
      
      await Future.delayed(const Duration(seconds: 1));
      
      // 2. 질문 조회
      final questions = await guestApi.getQuestions();
      setState(() => _status = '✅ 질문 조회 성공!\n${questions.length}개의 질문을 가져왔습니다.');
      
    } catch (e) {
      setState(() => _status = '❌ 에러 발생:\n$e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('백엔드 연결 테스트')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _status,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _testBackendConnection,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('백엔드 연결 테스트'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🧪 Step 4: 연결 테스트

### 4.1 백엔드 실행 (터미널 1)

```bash
cd /Users/taeeunlee/Developing/ongi-back
go run cmd/api/main.go
```

### 4.2 Flutter 실행 (터미널 2)

```bash
cd /Users/taeeunlee/Developing/ongi_front
flutter run -d chrome
```

### 4.3 테스트

1. 브라우저에서 "백엔드 연결 테스트" 버튼 클릭
2. 콘솔에서 로그 확인:
   ```
   🚀 [요청] POST http://localhost:3000/api/v1/guest/session
   ✅ [응답] 200
   ✨ 세션 생성 성공: abc123...
   ```

---

## 🐛 문제 해결

### 문제 1: "Connection refused" 에러

**원인**: 백엔드 서버가 실행되지 않음

**해결**:
```bash
cd /Users/taeeunlee/Developing/ongi-back
go run cmd/api/main.go
```

---

### 문제 2: CORS 에러

**에러 메시지**:
```
Access to XMLHttpRequest has been blocked by CORS policy
```

**원인**: 백엔드가 Flutter Web의 localhost:포트를 허용하지 않음

**해결**: 백엔드에 CORS 미들웨어 추가 필요

백엔드 개발자에게 다음 코드 추가 요청:

```go
// cmd/api/main.go
import "github.com/gofiber/fiber/v2/middleware/cors"

func main() {
    app := fiber.New()
    
    // CORS 설정 추가
    app.Use(cors.New(cors.Config{
        AllowOrigins: "*",
        AllowMethods: "GET,POST,PUT,DELETE,OPTIONS",
        AllowHeaders: "Content-Type,Authorization",
    }))
    
    // ... 나머지 코드
}
```

**임시 해결책** (개발 중):
Chrome에서 CORS 비활성화:
```bash
# Mac
open -na "Google Chrome" --args --disable-web-security --user-data-dir="/tmp/chrome_dev"
```

---

### 문제 3: PostgreSQL 연결 실패

**에러**: `database connection failed`

**해결**:
```bash
# PostgreSQL 실행
brew services start postgresql@16

# 또는 Docker
cd /Users/taeeunlee/Developing/ongi-back
docker-compose up -d postgres
```

---

### 문제 4: "404 Not Found"

**원인**: API 엔드포인트 경로 오류

**확인 사항**:
- Base URL: `http://localhost:3000/api/v1` ✅
- 엔드포인트: `/guest/session` (앞에 `/api/v1` 자동 추가됨)
- 전체 URL: `http://localhost:3000/api/v1/guest/session` ✅

---

## 📝 체크리스트

연결하기 전 확인:

- [ ] PostgreSQL 실행 중
- [ ] 백엔드 서버 실행 중 (`go run cmd/api/main.go`)
- [ ] Health Check 성공 (`curl http://localhost:3000/api/v1/health`)
- [ ] Flutter 프로젝트에 `api_client.dart` 생성
- [ ] Flutter 프로젝트에 `guest_api.dart` 생성
- [ ] `pubspec.yaml`에 `dio` 패키지 추가
- [ ] `flutter pub get` 실행
- [ ] Chrome에서 Flutter 앱 실행

---

## 🎯 다음 단계

연결이 성공하면:

1. **Sprint 1 시작**: 성격 테스트 UI 개발
2. **실제 API 연동**: 위 예제 코드를 ViewModel에 통합
3. **로컬 스토리지**: 세션 ID를 `shared_preferences`에 저장

---

## 📞 빠른 명령어 참고

```bash
# 백엔드 실행
cd /Users/taeeunlee/Developing/ongi-back && go run cmd/api/main.go

# Flutter 실행
cd /Users/taeeunlee/Developing/ongi_front && flutter run -d chrome

# API 테스트
curl http://localhost:3000/api/v1/health
curl -X POST http://localhost:3000/api/v1/guest/session
curl http://localhost:3000/api/v1/questions
```

---

**작성일**: 2024-12-02
**버전**: 1.0.0
