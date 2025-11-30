# 온기 Flutter Web 개발 계획서

## 📋 프로젝트 개요

### 서비스명
**온기 (Ongi)** - 성향 기반 취미 매칭 플랫폼

### 개발 목표
**Flutter Web**으로 모바일 스타일의 웹 애플리케이션을 개발합니다. Flutter로 모바일 화면을 만들되, 웹 브라우저에서 실행되도록 배포합니다.

### 타겟 플랫폼
- **Web (Flutter Web)**
  - 데스크톱 & 모바일 브라우저
  - 모바일 앱과 유사한 UI/UX
  - 앱 스토어 출시 없음

---

## 🛠 기술 스택

### Flutter Web
| 항목 | 기술 스택 | 용도 |
|------|-----------|------|
| 프레임워크 | Flutter 3.x (Web) | UI 프레임워크 |
| 언어 | Dart | 프로그래밍 언어 |
| 상태 관리 | Provider / Riverpod | 상태 관리 |
| HTTP 클라이언트 | dio | API 통신 |
| 로컬 저장소 | shared_preferences (Web) | 브라우저 로컬 스토리지 |
| 실시간 통신 | socket_io_client | WebSocket 채팅 |
| 지도 | Kakao Map JavaScript SDK (js interop) | 위치 공유 |
| 웹 푸시 | Web Push API + Service Worker | 푸시 알림 |

### 백엔드 (기존)
| 항목 | 기술 스택 |
|------|-----------|
| 언어 | Go |
| 프레임워크 | Fiber v2 |
| 데이터베이스 | PostgreSQL |
| 실시간 통신 | Socket.io |

---

## 🏗 MVVM 패턴 프로젝트 구조

```
ongi_front/
├── lib/
│   ├── main.dart                    # 앱 엔트리 포인트
│   ├── core/
│   │   ├── constants.dart           # 상수
│   │   └── config.dart              # 설정
│   ├── models/                      # Model 레이어
│   │   ├── api/                     # API 서비스
│   │   │   ├── auth_api.dart
│   │   │   ├── club_api.dart
│   │   │   ├── chat_api.dart
│   │   │   └── question_api.dart
│   │   ├── services/                # 비즈니스 로직
│   │   │   ├── chat_service.dart   # Socket.io
│   │   │   ├── auth_service.dart   # 인증
│   │   │   ├── storage_service.dart # 로컬 스토리지
│   │   │   └── push_service.dart   # 푸시 알림
│   │   └── entities/                # 데이터 모델
│   │       ├── user.dart
│   │       ├── club.dart
│   │       ├── message.dart
│   │       └── question.dart
│   ├── viewmodels/                  # ViewModel 레이어
│   │   ├── auth_viewmodel.dart
│   │   ├── chat_viewmodel.dart
│   │   ├── club_viewmodel.dart
│   │   └── question_viewmodel.dart
│   ├── views/                       # View 레이어
│   │   ├── pages/
│   │   │   ├── onboarding/
│   │   │   │   ├── welcome_page.dart
│   │   │   │   ├── question_page.dart
│   │   │   │   └── result_page.dart
│   │   │   ├── home/
│   │   │   │   ├── home_page.dart
│   │   │   │   ├── explore_page.dart
│   │   │   │   ├── my_clubs_page.dart
│   │   │   │   ├── chat_list_page.dart
│   │   │   │   └── profile_page.dart
│   │   │   ├── chat/
│   │   │   │   └── chat_room_page.dart
│   │   │   └── club/
│   │   │       └── club_detail_page.dart
│   │   └── widgets/                 # 재사용 컴포넌트
│   │       ├── common/
│   │       │   ├── custom_button.dart
│   │       │   ├── custom_input.dart
│   │       │   └── loading_indicator.dart
│   │       ├── chat/
│   │       │   ├── message_bubble.dart
│   │       │   ├── schedule_card.dart
│   │       │   └── chat_input.dart
│   │       └── club/
│   │           └── club_card.dart
│   └── utils/
│       ├── validators.dart
│       └── formatters.dart
├── web/
│   ├── index.html                   # HTML 엔트리
│   ├── manifest.json                # PWA 매니페스트
│   └── service-worker.js            # Service Worker
├── assets/                          # 이미지, 폰트
└── pubspec.yaml                     # 패키지 설정
```

### MVVM 패턴 설명

#### **Model** (데이터 및 비즈니스 로직)
- `models/api/`: 백엔드 API 호출 (Dio)
- `models/services/`: 데이터 처리 및 비즈니스 로직
- `models/entities/`: 데이터 클래스

#### **ViewModel** (상태 관리)
- `viewmodels/`: ChangeNotifier를 상속받아 상태 관리
- Provider 패턴 사용

#### **View** (UI)
- `views/pages/`: 페이지 위젯
- `views/widgets/`: 재사용 가능한 위젯

---

## 🔌 API 통신

### Dio 설정

```dart
// lib/models/api/api_client.dart
import 'package:dio/dio.dart';

class ApiClient {
  late Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.ongi.com/v1',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
    ));
    
    // 인터셉터 (토큰 자동 추가)
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageService.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }
  
  Dio get dio => _dio;
}
```

### API 서비스 예시

```dart
// lib/models/api/auth_api.dart
import 'package:dio/dio.dart';
import 'api_client.dart';

class AuthApi {
  final Dio _dio = ApiClient().dio;
  
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data;
  }
  
  Future<Map<String, dynamic>> signup(String email, String password, String nickname) async {
    final response = await _dio.post('/auth/signup', data: {
      'email': email,
      'password': password,
      'nickname': nickname,
    });
    return response.data;
  }
}
```

---

## 💬 채팅 기능 (Socket.io)

### Socket.io Client 설정

```dart
// lib/models/services/chat_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  IO.Socket? socket;
  
  void connect() {
    socket = IO.io('https://api.ongi.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    
    socket!.onConnect((_) {
      print('WebSocket 연결 성공');
    });
    
    socket!.on('new_message', (data) {
      // 새 메시지 처리
      handleNewMessage(data);
    });
  }
  
  void joinRoom(int groupId) {
    socket!.emit('join_room', groupId.toString());
  }
  
  void sendMessage(int groupId, String content) {
    socket!.emit('send_message', {
      'type': 'text',
      'group_id': groupId,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  void disconnect() {
    socket?.disconnect();
  }
  
  void handleNewMessage(dynamic data) {
    // ViewModel로 전달
  }
}
```

### Chat ViewModel

```dart
// lib/viewmodels/chat_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/services/chat_service.dart';
import '../models/entities/message.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final List<Message> _messages = [];
  
  List<Message> get messages => _messages;
  
  void connect(int groupId) {
    _chatService.connect();
    _chatService.joinRoom(groupId);
  }
  
  void sendMessage(int groupId, String content) {
    _chatService.sendMessage(groupId, content);
  }
  
  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }
  
  @override
  void dispose() {
    _chatService.disconnect();
    super.dispose();
  }
}
```

### Chat View

```dart
// lib/views/pages/chat/chat_room_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/chat_viewmodel.dart';
import '../../widgets/chat/message_bubble.dart';
import '../../widgets/chat/chat_input.dart';

class ChatRoomPage extends StatelessWidget {
  final int groupId;
  
  const ChatRoomPage({required this.groupId});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatViewModel()..connect(groupId),
      child: Scaffold(
        appBar: AppBar(title: Text('채팅방')),
        body: Column(
          children: [
            Expanded(
              child: Consumer<ChatViewModel>(
                builder: (context, viewModel, child) {
                  return ListView.builder(
                    itemCount: viewModel.messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(
                        message: viewModel.messages[index],
                      );
                    },
                  );
                },
              ),
            ),
            ChatInput(
              onSend: (content) {
                context.read<ChatViewModel>().sendMessage(groupId, content);
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🔔 웹 푸시 알림

### Service Worker 등록

```javascript
// web/service-worker.js
self.addEventListener('push', function(event) {
  const data = event.data.json();
  
  const options = {
    body: data.body,
    icon: '/icons/icon.png',
    badge: '/icons/badge.png',
  };
  
  event.waitUntil(
    self.registration.showNotification(data.title, options)
  );
});
```

### Push Service (Dart)

```dart
// lib/models/services/push_service.dart
import 'dart:html' as html;

class PushService {
  Future<void> requestPermission() async {
    final permission = await html.Notification.requestPermission();
    
    if (permission == 'granted') {
      print('푸시 알림 권한 허용');
      // Service Worker 등록
      await html.window.navigator.serviceWorker?.register('/service-worker.js');
    }
  }
  
  void showNotification(String title, String body) {
    html.Notification(title, body: body, icon: '/icons/icon.png');
  }
}
```

---

## 🗺 카카오맵 통합 (JavaScript Interop)

### JavaScript 인터페이스

```dart
// lib/utils/kakao_map_interop.dart
@JS()
library kakao_map;

import 'package:js/js.dart';

@JS('kakao.maps.Map')
class KakaoMap {
  external KakaoMap(dynamic container, dynamic options);
}

@JS('kakao.maps.LatLng')
class LatLng {
  external LatLng(num lat, num lng);
}

@JS('kakao.maps.Marker')
class Marker {
  external Marker(dynamic options);
  external void setMap(KakaoMap map);
}
```

### 지도 위젯

```dart
// lib/views/widgets/map/kakao_map_widget.dart
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

class KakaoMapWidget extends StatefulWidget {
  final double lat;
  final double lng;
  
  const KakaoMapWidget({required this.lat, required this.lng});
  
  @override
  _KakaoMapWidgetState createState() => _KakaoMapWidgetState();
}

class _KakaoMapWidgetState extends State<KakaoMapWidget> {
  @override
  void initState() {
    super.initState();
    _registerViewFactory();
  }
  
  void _registerViewFactory() {
    ui.platformViewRegistry.registerViewFactory(
      'kakao-map',
      (int viewId) {
        final element = html.DivElement()
          ..id = 'map-$viewId'
          ..style.width = '100%'
          ..style.height = '100%';
        
        _initializeMap(element);
        return element;
      },
    );
  }
  
  void _initializeMap(html.Element element) {
    // JavaScript로 카카오맵 초기화
    html.window.eval('''
      kakao.maps.load(function() {
        var container = document.getElementById('${element.id}');
        var options = {
          center: new kakao.maps.LatLng(${widget.lat}, ${widget.lng}),
          level: 3
        };
        var map = new kakao.maps.Map(container, options);
        
        var markerPosition = new kakao.maps.LatLng(${widget.lat}, ${widget.lng});
        var marker = new kakao.maps.Marker({
          position: markerPosition
        });
        marker.setMap(map);
      });
    ''');
  }
  
  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: 'kakao-map');
  }
}
```

---

## 🔐 인증 관리

### Auth ViewModel

```dart
// lib/viewmodels/auth_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/api/auth_api.dart';
import '../models/services/storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();
  bool _isLoading = false;
  String? _error;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _authApi.login(email, password);
      await StorageService.saveTokens(
        response['access_token'],
        response['refresh_token'],
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> logout() async {
    await StorageService.clearTokens();
    notifyListeners();
  }
}
```

### Login Page

```dart
// lib/views/pages/auth/login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth_viewmodel.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: Scaffold(
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.all(24),
            child: Consumer<AuthViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('로그인', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    SizedBox(height: 32),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: '이메일'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: '비밀번호'),
                      obscureText: true,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () {
                              viewModel.login(
                                _emailController.text,
                                _passwordController.text,
                              );
                            },
                      child: Text('로그인'),
                    ),
                    if (viewModel.error != null)
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          viewModel.error!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 📦 필수 Flutter 패키지

```yaml
# pubspec.yaml
name: ongi_front
description: 온기 - 성향 기반 취미 매칭 플랫폼 (Flutter Web)

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # 상태 관리
  provider: ^6.1.1
  
  # HTTP & API
  dio: ^5.4.0
  
  # WebSocket
  socket_io_client: ^2.0.3
  
  # 로컬 저장소 (Web)
  shared_preferences: ^2.2.2
  
  # JavaScript Interop
  js: ^0.6.7
  
  # 유틸리티
  intl: ^0.19.0
  
flutter:
  uses-material-design: true
```

---

## 🚀 애자일 개발 계획 (기능별 스프린트)

> **애자일 방법론**: 2주 스프린트로 기능별 개발, 각 스프린트 종료 시 동작하는 기능 배포

### Sprint 0: 프로젝트 초기화 (2주)
**목표**: 개발 환경 구축 및 기본 인프라 설정

- [ ] **개발 환경 설정**
  - [ ] Flutter 프로젝트 생성: `flutter create ongi_front`
  - [ ] Web 지원 활성화: `flutter create . --platforms=web`
  - [ ] 필수 패키지 설치 (provider, dio, socket_io_client)
  - [ ] 환경 변수 설정 (.env)

- [ ] **MVVM 아키텍처 구축**
  - [ ] 폴더 구조 생성 (models, viewmodels, views)
  - [ ] 기본 라우팅 설정
  - [ ] API Client 기본 구조

- [ ] **배포 파이프라인**
  - [ ] Firebase Hosting 또는 Vercel 초기 설정
  - [ ] CI/CD 기본 구성

**산출물**: 빈 Flutter Web 앱이 배포된 상태

---

### Sprint 1: 인증 기능 (2주)
**목표**: 회원가입/로그인 기능 완성

- [ ] **Model 레이어**
  - [ ] AuthApi 구현 (login, signup)
  - [ ] User 엔티티 정의
  - [ ] StorageService (토큰 저장)

- [ ] **ViewModel 레이어**
  - [ ] AuthViewModel 구현
  - [ ] 로그인 상태 관리

- [ ] **View 레이어**
  - [ ] 로그인 페이지
  - [ ] 회원가입 페이지
  - [ ] 폼 유효성 검사

**완료 조건**: 사용자가 회원가입하고 로그인할 수 있음

---

### Sprint 2: 성격 테스트 (온보딩) (2주)
**목표**: 성격 테스트 10문항 완성 및 결과 표시

- [ ] **Model 레이어**
  - [ ] QuestionApi 구현
  - [ ] Question, Answer 엔티티
  - [ ] 결과 분석 API

- [ ] **ViewModel 레이어**
  - [ ] QuestionViewModel
  - [ ] 진행 상황 관리 (현재 질문 번호)

- [ ] **View 레이어**
  - [ ] 환영 화면
  - [ ] 질문 카드 (10개)
  - [ ] 결과 화면 (성격 유형, 추천 활동)

**완료 조건**: 사용자가 10개 질문에 답하고 결과를 받을 수 있음

---

### Sprint 3: 모임 탐색 및 목록 (2주)
**목표**: 모임 목록 보기, 검색, 필터링

- [ ] **Model 레이어**
  - [ ] ClubApi 구현 (목록, 상세, 추천)
  - [ ] Club 엔티티

- [ ] **ViewModel 레이어**
  - [ ] ClubViewModel
  - [ ] 검색/필터 상태 관리

- [ ] **View 레이어**
  - [ ] 홈 화면 (추천 모임)
  - [ ] 둘러보기 화면 (전체 목록)
  - [ ] 모임 카드 위젯
  - [ ] 검색 기능

**완료 조건**: 사용자가 모임을 탐색하고 검색할 수 있음

---

### Sprint 4: 모임 상세 및 가입 (2주)
**목표**: 모임 상세 정보 보기 및 가입 기능

- [ ] **Model 레이어**
  - [ ] 모임 가입 API
  - [ ] 멤버 목록 API

- [ ] **ViewModel 레이어**
  - [ ] ClubDetailViewModel
  - [ ] 가입 상태 관리

- [ ] **View 레이어**
  - [ ] 모임 상세 페이지
  - [ ] 멤버 그리드
  - [ ] 가입하기 버튼
  - [ ] 내 모임 페이지

**완료 조건**: 사용자가 모임에 가입하고 내 모임을 볼 수 있음

---

### Sprint 5: 실시간 채팅 (3주)
**목표**: Socket.io 기반 실시간 채팅 구현

- [ ] **Model 레이어**
  - [ ] ChatService (Socket.io 연결)
  - [ ] Message 엔티티
  - [ ] 기존 메시지 로드 API

- [ ] **ViewModel 레이어**
  - [ ] ChatViewModel
  - [ ] 메시지 송수신 관리
  - [ ] 실시간 업데이트 처리

- [ ] **View 레이어**
  - [ ] 채팅방 목록
  - [ ] 채팅방 화면
  - [ ] 메시지 버블 (텍스트)
  - [ ] 채팅 입력창

**완료 조건**: 사용자가 실시간으로 메시지를 주고받을 수 있음

---

### Sprint 6: 채팅 고급 기능 (2주)
**목표**: 일정 제안, 위치 공유 등 특수 메시지

- [ ] **Model 레이어**
  - [ ] 일정 제안 API
  - [ ] 응답 처리 API

- [ ] **ViewModel 레이어**
  - [ ] ScheduleViewModel
  - [ ] 일정 응답 관리

- [ ] **View 레이어**
  - [ ] 일정 제안 카드
  - [ ] 위치 공유 카드
  - [ ] 이벤트 카드
  - [ ] [+] 버튼 메뉴

**완료 조건**: 사용자가 일정을 제안하고 응답할 수 있음

---

### Sprint 7: 카카오맵 통합 (1주)
**목표**: 위치 공유 시 카카오맵 표시

- [ ] **JavaScript Interop**
  - [ ] Kakao Map SDK 로드
  - [ ] dart:html 인터페이스 구현

- [ ] **View 레이어**
  - [ ] KakaoMapWidget
  - [ ] 위치 선택 화면
  - [ ] 지도에서 마커 표시

**완료 조건**: 채팅에서 위치를 공유하면 지도가 표시됨

---

### Sprint 8: 웹 푸시 알림 (1주)
**목표**: 새 메시지 알림 받기

- [ ] **Service Worker**
  - [ ] service-worker.js 작성
  - [ ] 푸시 이벤트 처리

- [ ] **Model 레이어**
  - [ ] PushService (권한 요청)
  - [ ] 구독 정보 백엔드 전송

- [ ] **통합**
  - [ ] 새 메시지 수신 시 푸시
  - [ ] 알림 클릭 시 채팅방 이동

**완료 조건**: 브라우저 밖에서도 새 메시지 알림 받음

---

### Sprint 9: 반응형 디자인 & UX 개선 (1주)
**목표**: 모바일/데스크톱 반응형 및 전체 UX 개선

- [ ] **반응형**
  - [ ] 모바일 레이아웃 (최대 600px)
  - [ ] 태블릿 레이아웃 (600px-1024px)
  - [ ] 데스크톱 레이아웃 (1024px+)

- [ ] **UX 개선**
  - [ ] 로딩 상태 표시
  - [ ] 에러 핸들링
  - [ ] 애니메이션 추가

**완료 조건**: 모든 디바이스에서 자연스럽게 동작

---

### Sprint 10: 테스트 & 최종 배포 (1주)
**목표**: 통합 테스트 및 프로덕션 배포

- [ ] **테스트**
  - [ ] 주요 기능 수동 테스트
  - [ ] 크로스 브라우저 테스트
  - [ ] 성능 최적화

- [ ] **배포**
  - [ ] Production 빌드
  - [ ] 환경 변수 설정
  - [ ] Firebase Hosting/Vercel 배포
  - [ ] 도메인 연결

**완료 조건**: 프로덕션 환경에서 모든 기능 정상 동작

---

### 📊 스프린트 타임라인

| 스프린트 | 기간 | 기능 | 누적 진행률 |
|---------|------|------|-------------|
| Sprint 0 | 1-2주 | 프로젝트 초기화 | 5% |
| Sprint 1 | 3-4주 | 인증 | 15% |
| Sprint 2 | 5-6주 | 성격 테스트 | 30% |
| Sprint 3 | 7-8주 | 모임 탐색 | 45% |
| Sprint 4 | 9-10주 | 모임 가입 | 55% |
| Sprint 5 | 11-13주 | 실시간 채팅 | 70% |
| Sprint 6 | 14-15주 | 채팅 고급 기능 | 80% |
| Sprint 7 | 16주 | 카카오맵 | 85% |
| Sprint 8 | 17주 | 웹 푸시 알림 | 92% |
| Sprint 9 | 18주 | 반응형 & UX | 97% |
| Sprint 10 | 19주 | 테스트 & 배포 | 100% |

**총 예상 기간**: 약 19주 (4.5개월)

---

## 🌐 배포

### Firebase Hosting 배포

```bash
# Firebase CLI 설치
npm install -g firebase-tools

# Firebase 로그인
firebase login

# 프로젝트 초기화
firebase init hosting

# Flutter Web 빌드
flutter build web

# 배포
firebase deploy
```

### 또는 Vercel 배포

```bash
# Vercel CLI 설치
npm install -g vercel

# Flutter Web 빌드
flutter build web

# 배포
vercel --prod
```

---

## 📊 예상 일정

| 주차 | 작업 내용 | 산출물 |
|------|-----------|--------|
| 1주 | 프로젝트 초기화 | Flutter 프로젝트, MVVM 구조 |
| 2주 | Model 레이어 | API, Socket.io 서비스 |
| 3주 | ViewModel 레이어 | Provider ViewModels |
| 4-5주 | View 레이어 | UI 위젯, 페이지 |
| 6주 | 고급 기능 | 푸시 알림, 지도 |
| 7주 | 배포 | Firebase/Vercel 배포 |

---

## ⚠️ 주의사항

### 1. Flutter Web DOM 접근 제약사항 (구체적 설명)

#### **문제점**
Flutter Web은 기본적으로 **Canvas 렌더링**을 사용하므로, 브라우저 DOM에 직접 접근하기 어렵습니다.

#### **제약 사항 상세**

1. **HTML 요소 직접 조작 불가**
   - Flutter 위젯은 Canvas에 그려지므로, `document.getElementById()` 같은 DOM 조작이 불가능
   - 예: 버튼을 클릭해도 실제 HTML `<button>` 요소가 아닌 Canvas에 그려진 이미지

2. **dart:html 사용 시 제한**
   ```dart
   // ❌ 일반 Flutter 코드에서는 이렇게 사용 불가
   import 'dart:html' as html;
   html.querySelector('#myButton').onClick.listen((event) {
     // Flutter Canvas와 HTML DOM은 분리되어 있음
   });
   ```

3. **JavaScript 라이브러리 통합**
   - 카카오맵 같은 JavaScript 라이브러리를 사용하려면 **js interop** 필요
   ```dart
   // Dart에서 JavaScript 함수 호출
   @JS('kakao.maps.Map')
   external void initMap();
   ```

4. **HtmlElementView 또는 PlatformViewLink 필요**
   - HTML 요소를 Flutter에 삽입하려면 특별한 위젯 사용
   ```dart
   HtmlElementView(
     viewType: 'kakao-map',  // 수동으로 등록한 HTML 요소
   )
   ```

5. **SEO 및 접근성 제한**
   - Canvas 렌더링이므로 스크린 리더가 텍스트를 읽기 어려움
   - 검색 엔진이 콘텐츠를 크롤링하기 어려움

#### **해결 방법**

1. **HTML 렌더러 사용** (권장)
   ```bash
   # Canvas 대신 HTML 렌더러로 빌드
   flutter build web --web-renderer html
   ```
   - DOM 접근이 더 자연스러움
   - 텍스트 선택 가능
   - SEO 개선

2. **JavaScript Interop 활용**
   - `package:js`를 사용해 JavaScript 코드와 통신
   
3. **Platform View 사용**
   - HTML 요소가 필요한 경우 `HtmlElementView` 사용

4. **패키지 Web 호환성 확인**
   - pub.dev에서 "Web" 플랫폼 지원 여부 확인
   - 예: `flutter_secure_storage`는 Web 미지원 → `shared_preferences` 사용

#### **온기 프로젝트 적용 방안**

- ✅ **HTML 렌더러 사용**: `flutter build web --web-renderer html`
- ✅ **카카오맵**: JavaScript Interop + HtmlElementView
- ✅ **웹 푸시**: dart:html로 Service Worker API 접근
- ✅ **로컬 스토리지**: `shared_preferences` (Web 지원)

---

### 2. 일부 Flutter 패키지 Web 미지원
- `path_provider`: Web에서 파일 시스템 접근 제한
- `flutter_secure_storage`: Web 미지원 → `shared_preferences` 대체
- 네이티브 플러그인: iOS/Android 전용 패키지는 Web 불가

### 2. 백엔드 확인 필요
- Socket.io WebSocket 구현 필요
- CORS 설정 (Flutter Web은 다른 도메인에서 실행)

### 3. 카카오맵
- JavaScript SDK를 dart:html로 래핑
- Platform View 사용

---

## 📝 다음 단계

1. **계획 승인**
   - Flutter Web 개발 계획 검토
   
2. **Flutter 프로젝트 생성**
   - `flutter create ongi_flutter_web`
   - Web 플랫폼 활성화
   
3. **MVVM 구조 설정**
   - 폴더 구조 생성
   - 기본 파일 작성
