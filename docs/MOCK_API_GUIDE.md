# Mock API 로컬 개발 가이드

## 📋 개요

백엔드 서버 없이도 로컬에서 개발할 수 있도록 **Mock API**를 구현했습니다.
환경에 따라 자동으로 Real API 또는 Mock API를 사용합니다.

---

## 🎯 자동 전환 로직

`guest_api_factory.dart`가 자동으로 환경을 감지하여 API를 선택합니다:

```dart
// localhost인 경우 자동으로 Mock API 사용
final isLocalhost = AppConstants.apiBaseUrl.contains('localhost');

if (useMock || isLocalhost) {
  print('🔶 [API] Mock API 사용 (백엔드 없이 로컬 개발)');
  return MockGuestApiAdapter();
} else {
  print('🌐 [API] Real API 사용');
  return RealGuestApiAdapter();
}
```

### API 전환 조건

| 조건 | 사용 API | 상황 |
|------|---------|------|
| `apiBaseUrl`에 `localhost` 포함 | **Mock API** | 로컬 개발 |
| 환경 변수 `USE_MOCK_API=true` | **Mock API** | 강제 Mock 모드 |
| 그 외 | **Real API** | 프로덕션/배포 |

---

## 🚀 사용 방법

### 1. 로컬 개발 (자동으로 Mock API 사용)

```bash
# Flutter 로컬 실행
flutter run -d chrome
```

**결과:**
- ✅ `apiBaseUrl`이 `http://localhost:3000`이므로 자동으로 **Mock API 사용**
- ✅ 백엔드 서버 없이도 모든 기능 동작
- ✅ 콘솔에 `🔶 [API] Mock API 사용` 메시지 출력

### 2. Mock API 강제 사용 (배포 환경에서도)

```bash
flutter run --dart-define=USE_MOCK_API=true -d chrome
```

### 3. Real API 사용 (백엔드 배포 후)

**`lib/core/constants.dart` 수정:**

```dart
static const String apiBaseUrl = 
    String.fromEnvironment('API_URL', 
      defaultValue: 'https://your-backend.railway.app/api/v1'); // ← 배포된 주소
```

또는 **환경 변수로 실행:**

```bash
flutter run --dart-define=API_URL=https://your-backend.railway.app/api/v1 -d chrome
```

---

## 📦 구현된 Mock 기능

### 1. 세션 생성 (`POST /guest/session`)
```dart
Future<String> createSession()
```
- 랜덤 32자 세션 ID 생성
- 네트워크 지연 500ms 시뮬레이션

### 2. 질문 조회 (`GET /questions`)
```dart
Future<List<Question>> getQuestions()
```
- 10개의 실제 성격 테스트 질문 반환
- 각 질문당 4개의 선택지
- 5가지 점수 포함 (사교성, 활동성, 친밀도, 몰입도, 유연성)

**샘플 질문:**
1. "금요일 저녁, 친구가 갑자기 밖으로 불러냈다. 이때 당신의 반응은?"
2. "새로운 취미 활동을 시작한다면?"
3. "모임에서 새로운 사람을 만났을 때?"
4. ... (총 10개)

### 3. 답변 제출 (`POST /guest/answers`)
```dart
Future<void> submitAnswers(String sessionId, List<GuestAnswer> answers)
```
- 답변을 받지만 실제 저장은 하지 않음
- 700ms 지연 시뮬레이션

### 4. 결과 조회 (`GET /guest/result/:sessionId`)
```dart
Future<GuestResult> getResult(String sessionId)
```
- **랜덤 성격 점수** 생성 (50~90점 범위)
- **8가지 성격 유형** 중 하나 반환:
  - 열정적인 사교가
  - 따뜻한 조력자
  - 도전적인 탐험가
  - 깊이있는 전문가
  - 유연한 적응형
  - 친근한 외향형
  - 집중하는 몰입형
  - 균형잡힌 조화형

- **추천 결과** 포함:
  - 추천 클럽 3개 (러닝 크루, 독서 모임, 보드게임 동호회)
  - 유사 클럽 2개 (요가, 사진 동호회)
  - 추천 모임 3개

---

## 📝 Mock 데이터 샘플

### 추천 클럽 예시

```json
{
  "id": 1,
  "name": "서울 러닝 크루",
  "description": "함께 달리며 건강을 챙기는 러닝 모임입니다",
  "category": "운동",
  "memberCount": 24,
  "maxMembers": 30,
  "location": "한강공원",
  "vibe": "energetic",
  "meetingFrequency": "주 2회"
}
```

### 추천 모임 예시

```json
{
  "id": 1,
  "title": "주말 한강 러닝",
  "description": "상쾌한 주말 아침 한강에서 10km 달리기",
  "location": "한강공원 반포지구",
  "scheduledAt": "2024-12-05T09:00:00.000Z",
  "maxMembers": 15,
  "category": "운동"
}
```

---

## 🔄 백엔드 준비 후 전환

백엔드가 배포되면 다음과 같이 전환:

### 로컬 환경

**Option 1: 코드 수정**
```dart
// lib/core/constants.dart
static const String apiBaseUrl = 
    String.fromEnvironment('API_URL', 
      defaultValue: 'https://your-backend.railway.app/api/v1');
```

**Option 2: 환경 변수 사용**
```bash
flutter run --dart-define=API_URL=https://your-backend.railway.app/api/v1
```

### Vercel 배포

**Vercel 대시보드 → Settings → Environment Variables:**

| Key | Value |
|-----|-------|
| `API_URL` | `https://your-backend.railway.app/api/v1` |

**재배포:**
```bash
git push
# Vercel이 자동으로 재배포하며 Real API 사용
```

---

## 🧪 테스트 방법

### 1. Mock API 작동 확인

```bash
flutter run -d chrome
```

**콘솔 확인:**
```
🔶 [API] Mock API 사용 (백엔드 없이 로컬 개발)
✅ [MOCK] Guest Session 생성: a1b2c3d4e5f6...
✅ [MOCK] 질문 10개 조회
✅ [MOCK] 답변 10개 제출 완료
✅ [MOCK] 결과 조회: 도전적인 탐험가
```

### 2. 성격 테스트 플로우

1. **앱 시작** → 세션 자동 생성
2. **질문 응답** → 10개 질문에 답변
3. **제출** → Mock 결과 반환
4. **결과 확인** → 성격 유형, 점수, 추천 클럽 표시

---

## 🎨 추가 Mock 데이터 커스터마이징

Mock 데이터를 수정하려면 `lib/models/api/mock_guest_api.dart` 파일 수정:

### 질문 추가/수정
```dart
List<Question> _getMockQuestions() {
  return [
    Question(
      id: 1,
      text: '새로운 질문을 추가할 수 있습니다',
      // ...
    ),
    // ...
  ];
}
```

### 클럽/모임 추가
```dart
GuestRecommendations _getMockRecommendations() {
  return GuestRecommendations(
    clubs: [
      Club(
        id: 99,
        name: '새로운 클럽',
        description: '설명',
        // ...
      ),
    ],
    // ...
  );
}
```

---

## ⚠️ 주의사항

1. **Mock API 한계:**
   - 실제 데이터베이스가 없어 데이터 영속성 없음
   - 세션마다 새로운 랜덤 결과 생성
   - 사용자 간 데이터 공유 불가

2. **개발 전용:**
   - Mock API는 개발 및 UI 테스트용
   - 프로덕션에서는 반드시 Real API 사용

3. **디버깅:**
   - 콘솔 로그로 Mock/Real API 확인 가능
   - `[MOCK]` 접두사가 있으면 Mock API 사용 중

---

## 📚 관련 파일

| 파일 | 역할 |
|------|------|
| `lib/models/api/mock_guest_api.dart` | Mock API 구현 |
| `lib/models/api/guest_api_factory.dart` | API 팩토리 (자동 전환) |
| `lib/models/api/guest_api.dart` | Real API 구현 |
| `lib/viewmodels/personality_test_viewmodel.dart` | API 사용 ViewModel |
| `lib/core/constants.dart` | API URL 설정 |

---

## 🚀 다음 단계

1. ✅ **로컬 개발 진행** - Mock API로 UI 구현
2. ⏳ **백엔드 배포 대기** - 팀원이 백엔드 배포
3. 🔄 **Real API 전환** - 환경 변수만 변경하면 완료!

---

**작성일**: 2024-12-01  
**버전**: 1.0.0
