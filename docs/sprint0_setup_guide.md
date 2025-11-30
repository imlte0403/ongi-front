# Sprint 0: 프로젝트 초기화 작업 가이드

## 📌 협업 규칙 (반드시 준수)

### 1. 코딩 전 명확화
- 모든 것을 명확히 하고 코딩 시작
- 모호한 부분은 반드시 질문
- 추측하지 말고 확인

### 2. 단계별 계획 수립
- 작업 지시 시 단계별 계획을 먼저 보고
- 각 단계의 목적과 결과물 명시
- 데이터 리스트 사용 시 사용된 요소 보고

### 3. 한국어 소통
- 모든 답변과 문서는 한국어로 작성
- 코드 주석도 한국어 사용 권장

---

## ✅ 완료된 작업

- ✅ Flutter 프로젝트 생성 완료: `/Users/taeeunlee/Developing/ongi_front`
- ✅ 워크스페이스 추가 완료

---

## 📋 Sprint 0 작업 목록

### Step 1: MVVM 폴더 구조 생성

터미널 실행 (ongi_front 프로젝트 루트에서):

```bash
# 폴더 구조 한 번에 생성
mkdir -p lib/models/api lib/models/services lib/models/entities \
  lib/viewmodels \
  lib/views/pages/onboarding lib/views/pages/home lib/views/pages/chat \
  lib/views/pages/club lib/views/pages/auth \
  lib/views/widgets/common lib/views/widgets/chat \
  lib/views/widgets/club lib/views/widgets/question \
  lib/core lib/utils
```

**확인**: `lib` 폴더 안에 위 폴더들이 생성되었는지 확인

---

### Step 2: pubspec.yaml 수정

`pubspec.yaml` 파일을 열어서 전체 내용을 다음으로 교체:

```yaml
name: ongi_front
description: 온기 - 성향 기반 취미 매칭 플랫폼 (Flutter Web)

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # 상태 관리
  provider: ^6.1.1
  
  # HTTP & API
  dio: ^5.4.0
  
  # WebSocket (Sprint 5-6에서 사용)
  socket_io_client: ^2.0.3
  
  # 로컬 저장소 (Web)
  shared_preferences: ^2.2.2
  
  # JavaScript Interop (카카오맵용)
  js: ^0.6.7
  
  # 유틸리티
  intl: ^0.19.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
```

**패키지 설치**:
```bash
flutter pub get
```

**확인**: 에러 없이 패키지가 설치되는지 확인

---

### Step 3: 환경 변수 파일 생성

**파일 경로**: `lib/core/constants.dart`

```dart
class AppConstants {
  // API URLs
  static const String apiBaseUrl = 
      String.fromEnvironment('API_URL', defaultValue: 'http://localhost:3000/api/v1');
  
  // App Info
  static const String appName = '온기';
  static const String appVersion = '1.0.0';
  
  // Local Storage Keys
  static const String sessionIdKey = 'guest_session_id';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  
  // API Endpoints
  static const String guestSessionEndpoint = '/guest/session';
  static const String questionsEndpoint = '/questions';
  static const String guestAnswersEndpoint = '/guest/answers';
  static const String guestResultEndpoint = '/guest/result';
  static const String clubsEndpoint = '/clubs';
}
```

---

### Step 4: API Client 구현

**파일 경로**: `lib/models/api/api_client.dart`

```dart
import 'package:dio/dio.dart';
import '../../core/constants.dart';

class ApiClient {
  late Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseURL: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      contentType: 'application/json',
    ));
    
    // 요청 인터셉터 (로깅)
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🚀 [요청] ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ [응답] ${response.statusCode} ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('❌ [에러] ${e.message}');
        return handler.next(e);
      },
    ));
  }
  
  Dio get dio => _dio;
}

// 싱글톤 인스턴스
final apiClient = ApiClient();
```

---

### Step 5: 로컬 스토리지 서비스

**파일 경로**: `lib/models/services/storage_service.dart`

```dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';

class StorageService {
  // 게스트 세션 ID 저장/조회
  static Future<void> saveSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.sessionIdKey, sessionId);
    print('💾 세션 ID 저장: $sessionId');
  }
  
  static Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.sessionIdKey);
  }
  
  // JWT 토큰 저장/조회 (Sprint 3에서 사용)
  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.accessTokenKey, accessToken);
    await prefs.setString(AppConstants.refreshTokenKey, refreshToken);
    print('🔐 토큰 저장 완료');
  }
  
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.accessTokenKey);
  }
  
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.refreshTokenKey);
  }
  
  // 전체 삭제 (로그아웃 시)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('🗑️ 로컬 스토리지 전체 삭제');
  }
}
```

---

### Step 6: 메인 앱 수정

**파일 경로**: `lib/main.dart`

전체 내용을 다음으로 교체:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const OngiApp());
}

class OngiApp extends StatelessWidget {
  const OngiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '온기',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF28B16E)),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 로고
              const Text(
                '온기',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF28B16E),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              
              // 설명
              const Text(
                '성향 기반 취미 매칭 플랫폼',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  letterSpacing: 1,
                ),
              ),
              
              const SizedBox(height: 80),
              
              // 시작 버튼
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✨ Sprint 1에서 성격 테스트 구현 예정'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28B16E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '테스트 시작하기',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 버전 정보
              const Text(
                'v1.0.0 | Sprint 0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black26,
                ),
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

### Step 7: 앱 실행 및 확인

**Chrome에서 실행**:
```bash
flutter run -d chrome
```

**또는 Edge에서 실행**:
```bash
flutter run -d edge
```

**확인 사항**:
- ✅ 브라우저가 자동으로 열림
- ✅ "온기" 로고가 초록색으로 표시됨
- ✅ "성향 기반 취미 매칭 플랫폼" 문구 보임
- ✅ "테스트 시작하기" 버튼 클릭 가능
- ✅ 버튼 클릭 시 "Sprint 1에서 성격 테스트 구현 예정" 메시지 표시

---

## 🐛 문제 해결

### 1. `flutter pub get` 에러
```bash
# Flutter 버전 확인
flutter --version

# 캐시 정리
flutter clean
flutter pub get
```

### 2. Chrome 실행 안 됨
```bash
# 사용 가능한 디바이스 확인
flutter devices

# Web 서버 활성화
flutter config --enable-web
```

### 3. Hot Reload 안 됨
- 웹 개발 시 Hot Reload가 느릴 수 있음
- `r` (Hot Reload) 또는 `R` (Hot Restart) 수동 실행

---

## ✅ Sprint 0 완료 체크리스트

완료한 항목에 체크:

- [ ] MVVM 폴더 구조 생성 완료
- [ ] pubspec.yaml 패키지 추가 및 `flutter pub get` 성공
- [ ] `lib/core/constants.dart` 생성
- [ ] `lib/models/api/api_client.dart` 생성
- [ ] `lib/models/services/storage_service.dart` 생성
- [ ] `lib/main.dart` 수정
- [ ] 앱 실행 성공 (브라우저에서 확인)
- [ ] 모든 기능 정상 작동 확인

**모두 완료했으면**: "Sprint 0 완료" 메시지 전송

---

## 🎯 다음 단계: Sprint 1

Sprint 0가 완료되면 **Sprint 1: 성격 테스트 (비회원)**을 시작합니다.

Sprint 1 주요 작업:
1. Guest Session API 연동
2. 성격 테스트 10문항 UI
3. 답변 제출 및 결과 표시
4. 로컬 스토리지에 세션 ID 저장

---

## 📞 도움이 필요할 때

문제가 발생하면:
1. 에러 메시지 전체 복사
2. 어떤 작업 중 발생했는지 명시
3. 스크린샷 첨부 (선택)

예시: "Step 2에서 flutter pub get 실행 시 다음 에러 발생: [에러 메시지]"

---

**화이팅! 🚀**
