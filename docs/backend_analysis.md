# 백엔드 분석 및 호환성 검증 보고서

## 📋 분석 개요

백엔드 프로젝트 `ongi-back`를 분석하여 Flutter Web 프론트엔드 개발 계획과의 호환성을 검증했습니다.

**분석 일시**: 2025-11-30
**백엔드 기술**: Go + Fiber + PostgreSQL
**API 버전**: v1

---

## ✅ 현재 구현된 기능

### 1. 비회원 설문 시스템 (Guest API)
**상태**: ✅ **완전 구현됨**

#### 엔드포인트
- `POST /api/v1/guest/session` - 세션 생성
- `POST /api/v1/guest/answers` - 답변 제출
- `GET /api/v1/guest/result/:sessionId` - 결과 조회
- `GET /api/v1/guest/session/:sessionId` - 세션 정보
- `POST /api/v1/guest/link` - 계정 연동
- `POST /api/v1/guest/compatibility` - 궁합 계산

#### 특징
- 세션 ID 기반 비회원 설문
- 7일 만료
- 나중에 계정 연동 가능
- 로컬 스토리지 활용 권장

**프론트엔드 적용**: 온보딩 플로우에서 비회원으로 성격 테스트 가능

---

### 2. 사용자 관리 (Users)
**상태**: ✅ **완전 구현됨**

#### 엔드포인트
- `POST /api/v1/users` - 사용자 생성
- `GET /api/v1/users` - 모든 사용자 조회
- `GET /api/v1/users/:id` - 특정 사용자 조회
- `GET /api/v1/users/:id/profile` - 프로필 조회
- `POST /api/v1/users/:id/auto-match` - 자동 매칭
- `POST /api/v1/users/:id/auto-match-group` - 그룹 자동 매칭

#### 데이터 모델
```go
type User struct {
    ID        uint
    Email     string
    Name      string
    CreatedAt time.Time
    UpdatedAt time.Time
}
```

**주의**: ⚠️ **인증(Auth) 시스템이 없음**
- 로그인/회원가입 API 없음
- JWT 토큰 발급 없음
- 비밀번호 관리 없음

**프론트엔드 영향**: 
- Sprint 1 (인증 기능) 구현 전에 **백엔드에 인증 API 추가 필요**
- 또는 일단 비회원 세션으로 시작하고 나중에 계정 연동

---

### 3. 성격 테스트 (Questions & Answers)
**상태**: ✅ **완전 구현됨**

#### 엔드포인트
- `GET /api/v1/questions` - 질문 목록 (10개)
- `GET /api/v1/questions/:id` - 특정 질문
- `POST /api/v1/answers` - 단일 답변
- `POST /api/v1/answers/batch` - 일괄 답변
- `GET /api/v1/answers/user/:userId` - 사용자 답변
- `GET /api/v1/results/:userId` - 분석 결과

#### 데이터 모델
```go
type Question struct {
    ID      uint
    Text    string
    Options []QuestionOption  // 5개 옵션
}

type Answer struct {
    UserID     uint
    QuestionID uint
    OptionID   uint
}

type UserProfile struct {
    SociabilityScore  float64  // 사교성
    ActivityScore     float64  // 활동성
    IntimacyScore     float64  // 친밀도
    ImmersionScore    float64  // 몰입도
    FlexibilityScore  float64  // 유연성
    ProfileType       string   // 성격 유형
    ResultSummary     string   // 결과 요약
}
```

**프론트엔드 적용**: Sprint 2 (성격 테스트) 완벽히 호환

---

### 4. 클럽/모임 관리
**상태**: ✅ **기본 기능 구현됨**

#### 엔드포인트
- `GET /api/v1/clubs` - 클럽 목록
- `POST /api/v1/clubs` - 클럽 생성
- `GET /api/v1/clubs/:id` - 클럽 상세
- `POST /api/v1/clubs/join` - 클럽 가입
- `GET /api/v1/meetings` - 모임 목록
- `POST /api/v1/meetings` - 모임 생성
- `GET /api/v1/meetings/:id` - 모임 상세

#### 데이터 모델
```go
type Club struct {
    ID          uint
    Name        string
    Description string
    Category    string
    ImageURL    string
    MemberCount int
    Members     []ClubMember
}

type ClubMember struct {
    UserID uint
    ClubID uint
}

type Meeting struct {
    Title       string
    Description string
    ClubID      uint
    Location    string
    ScheduledAt time.Time
    MaxMembers  int
    Category    string
}
```

**프론트엔드 적용**: Sprint 3-4 (모임 탐색 및 가입) 완벽히 호환

---

## ❌ 미구현 기능

### 1. 실시간 채팅 (WebSocket)
**상태**: ❌ **미구현**

#### 현재 상태
- `PROJECT_SUMMARY.md`에 계획만 있음
- 실제 코드 없음
- Socket.io 또는 WebSocket 라이브러리 미설치

#### 필요한 구현
```go
// 백엔드에 추가 필요
handlers/chat.go        // 채팅 핸들러
models/message.go       // 메시지 모델
services/websocket.go   // WebSocket 서비스
```

**권장 구현 방법**:
1. **gorilla/websocket** 사용 (Go 표준)
2. 또는 **Socket.io Go 라이브러리** 사용

**프론트엔드 영향**: 
- ⚠️ **Sprint 5-6 (채팅) 시작 전에 백엔드 WebSocket 구현 필수**
- 없으면 프론트엔드에서 채팅 기능 개발 불가

---

### 2. 인증 시스템 (Auth)
**상태**: ❌ **미구현**

#### 현재 상태
- 로그인/회원가입 API 없음
- JWT 토큰 발급 없음
- 비밀번호 관리 없음

#### 필요한 구현
```go
// 백엔드에 추가 필요
POST /api/v1/auth/signup   // 회원가입
POST /api/v1/auth/login    // 로그인
POST /api/v1/auth/refresh  // 토큰 갱신
```

**프론트엔드 영향**:
- Sprint 1 (인증) 시작 전에 백엔드 구현 필요
- **대안**: 비회원 세션 → 나중에 계정 연동 (Guest API 활용)

---

### 3. 채팅 관련 API
**상태**: ❌ **미구현**

#### 필요한 엔드포인트
```
GET  /api/v1/groups/:groupId/messages      // 메시지 조회
POST /api/v1/groups/:groupId/messages      // 메시지 전송
POST /api/v1/messages/:messageId/respond   // 일정 응답
WebSocket: ws://api.ongi.com/ws            // 실시간 연결
```

---

### 4. 푸시 알림
**상태**: ❌ **미구현**

#### 필요한 구현
- FCM 서버 키 설정
- 푸시 발송 로직
- 사용자별 토큰 저장

---

## 📊 API 호환성 매트릭스

| 프론트엔드 스프린트 | 필요 API | 백엔드 상태 | 호환성 |
|-------------------|---------|-----------|--------|
| Sprint 0 (초기화) | - | - | ✅ 호환 |
| Sprint 1 (인증) | Auth API | ❌ 미구현 | ⚠️ **백엔드 작업 필요** |
| Sprint 2 (성격 테스트) | Questions, Answers, Results | ✅ 완료 | ✅ 완전 호환 |
| Sprint 3 (모임 탐색) | GET /clubs | ✅ 완료 | ✅ 완전 호환 |
| Sprint 4 (모임 가입) | POST /clubs/join | ✅ 완료 | ✅ 완전 호환 |
| Sprint 5-6 (채팅) | Chat API, WebSocket | ❌ 미구현 | ⚠️ **백엔드 작업 필수** |
| Sprint 7 (카카오맵) | - | - | ✅ 호환 (프론트만) |
| Sprint 8 (푸시 알림) | Push API | ❌ "미구현 | ⚠️ **백엔드 작업 필요** |

---

## 🔧 백엔드 수정 필요 사항

### 우선순위 1: 인증 시스템 (Sprint 1 전까지)
```go
// handlers/auth.go 생성 필요
type SignupRequest struct {
    Email    string `json:"email"`
    Password string `json:"password"`
    Nickname string `json:"nickname"`
}

type LoginRequest struct {
    Email    string `json:"email"`
    Password string `json:"password"`
}

func Signup(c *fiber.Ctx) error { /* JWT 발급 */ }
func Login(c *fiber.Ctx) error { /* JWT 발급 */ }
func RefreshToken(c *fiber.Ctx) error { /* 토큰 갱신 */ }
```

**필요한 패키지**:
- `github.com/golang-jwt/jwt/v5` (JWT)
- `golang.org/x/crypto/bcrypt` (비밀번호 해싱)

---

### 우선순위 2: WebSocket 채팅 (Sprint 5 전까지)

#### 방법 1: gorilla/websocket 사용 (권장)
```go
// handlers/websocket.go
import "github.com/gorilla/websocket"

var upgrader = websocket.Upgrader{
    CheckOrigin: func(r *http.Request) bool {
        return true // CORS 설정
    },
}

func HandleWebSocket(c *fiber.Ctx) error {
    conn, err := upgrader.Upgrade(c.Response(), c.Request(), nil)
    // WebSocket 로직
}
```

#### 방법 2: Socket.io Go 사용
```go
import socketio "github.com/googollee/go-socket.io"

server := socketio.NewServer(nil)

server.OnEvent("/", "message", func(s socketio.Conn, msg string) {
    // 메시지 처리
})
```

**필요한 테이블**:
```sql
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    type VARCHAR(50),          -- text, schedule_proposal, location, event
    user_id INT,
    group_id INT,
    content JSONB,
    timestamp TIMESTAMP
);
```

---

### 우선순위 3: 푸시 알림 (Sprint 8 전까지)
```go
// services/fcm.go
import "firebase.google.com/go/messaging"

func SendPushNotification(token string, title string, body string) error {
    message := &messaging.Message{
        Notification: &messaging.Notification{
            Title: title,
            Body:  body,
        },
        Token: token,
    }
    // FCM 전송
}
```

---

## 🔄 기존 API와의 차이점

### 1. Base URL
**프론트엔드 계획**: `https://api.ongi.com/v1`
**백엔드 실제**: `http://localhost:3000/api/v1`

→ 프로덕션 배포 시 환경 변수로 설정

### 2. 응답 형식
백엔드는 일관되게 다음 형식 사용:
```json
{
  "success": true,
  "data": {...},
  "message": "..."  // 선택적
}
```

→ 프론트엔드에서 동일한 형식 처리

### 3. 에러 처리
```json
{
  "error": "Error message"
}
```

→ 프론트엔드에서 에러 핸들링 필요

---

## 📝 프론트엔드 개발 계획 수정 제안

### 수정 1: Sprint 1 (인증) 연기 또는 대체
**옵션 A**: 백엔드 인증 구현 대기
- Sprint 1을 Sprint 5 이후로 이동
- 먼저 비회원 기능 완성

**옵션 B**: 임시로 비회원 세션 사용 (권장)
- Guest API로 시작
- Sprint 2-4 진행
- 나중에 계정 연동

### 수정 2: Sprint 5-6 (채팅) 조정
**백엔드 개발 병행 필요**
- 프론트엔드 개발 중 백엔드팀이 WebSocket 구현
- 또는 프론트엔드에서 Mock 채팅으로 UI 먼저 개발

### 수정 3: 개발 순서 재조정
```
기존 계획:
Sprint 1 (인증) → Sprint 2 (테스트) → Sprint 3-4 (모임) → Sprint 5-6 (채팅)

수정 제안:
Sprint 0 (초기화)
→ Sprint 2 (성격 테스트) 비회원으로 먼저
→ Sprint 3-4 (모임 탐색 및 가입)
→ [백엔드 WebSocket 개발]
→ Sprint 5-6 (채팅)
→ Sprint 1 (인증) + 계정 연동
→ Sprint 7-10
```

---

## ✅ 긍정적인 점

1. **성격 테스트 시스템 완벽**: Sprint 2 즉시 개발 가능
2. **비회원 API 우수**: Guest API로 인증 없이 시작 가능
3. **모임 시스템 준비됨**: Sprint 3-4 문제없음
4. **일관된 API 구조**: Fiber 프레임워크로 깔끔한 코드
5. **추천 알고리즘 구현**: 성향 기반 추천 완료

---

## ⚠️ 주의 사항

1. **CORS 설정 필요**
   - Flutter Web은 다른 도메인에서 실행
   - 백엔드에 CORS 미들웨어 설정 확인

2. **환경 변수 관리**
   - `.env` 파일에 API URL 설정
   - Production/Development 분리

3. **데이터베이스 동기화**
   - `go run cmd/seed/main.go` 실행하여 초기 데이터 생성

---

## 🎯 다음 단계

### 1. 백엔드팀과 협의
- 인증 API 구현 일정
- WebSocket 채팅 구현 일정
- API 명세서 최신화

### 2. 개발 순서 확정
- 비회원 먼저 vs 인증 먼저
- 채팅 기능 타이밍

### 3. Mock 데이터 준비
- 백엔드 구현 전 프론트엔드 개발용

---

## 📌 결론

### ✅ 호환 가능
- 성격 테스트, 모임 탐색/가입 기능은 **즉시 개발 가능**
- 비회원 API가 우수하여 **인증 없이 시작 가능**

### ⚠️ 백엔드 작업 필요
- **인증 시스템** (Sprint 1)
- **WebSocket 채팅** (Sprint 5-6)
- **푸시 알림** (Sprint 8)

### 📝 권장 사항
1. **Sprint 2부터 시작** (비회원 성격 테스트)
2. **백엔드 WebSocket 구현 병행**
3. **인증은 마지막에 추가**

Flutter 프론트엔드 계획은 **80% 호환** 가능하며, 일부 스프린트 순서 조정과 백엔드 추가 개발이 필요합니다.
