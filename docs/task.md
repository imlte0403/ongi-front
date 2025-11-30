# 온기 Flutter Web 개발 계획

## Phase 1: 사전 조사 및 계획
- [x] 백엔드 서버 상태 확인
- [x] API 엔드포인트 테스트
- [x] 상세 개발 계획서 작성 (Flutter Web)
  - [x] 기술 스택 정의
  - [x] 프로젝트 구조 설계 (MVVM)
  - [x] 채팅 기능 구현 방안 (Socket.io)
  - [x] 웹 푸시 알림 설계
  - [x] 지도 서비스 선택 (Kakao Map)
- [x] 백엔드 호환성 검증 완료
- [x] 개발 시작 승인 ✅

## Phase 2: Sprint 0 - 프로젝트 초기화 (진행중 🚀)
- [/] Flutter 프로젝트 생성 (Web 지원)
- [ ] 필수 패키지 설치
  - [ ] socket_io_client
  - [ ] provider (상태 관리)
  - [ ] dio (HTTP)
  - [ ] kakao_map_plugin (웹용)
- [ ] MVVM 폴더 구조 설정
- [ ] 환경 변수 설정

## Phase 3: Model & ViewModel 레이어
- [ ] Model 구현
  - [ ] API 서비스
  - [ ] WebSocket 서비스
  - [ ] 데이터 모델
- [ ] ViewModel 구현
  - [ ] AuthViewModel
  - [ ] ChatViewModel
  - [ ] ClubViewModel

## Phase 4: View 레이어 (UI)
- [ ] 온보딩 플로우 (성격 테스트)
- [ ] 메인 화면 (홈/둘러보기/내모임/채팅/마이)
- [ ] 채팅 화면
- [ ] 모임 상세 화면

## Phase 5: 고급 기능
- [ ] Socket.io 실시간 채팅
- [ ] 웹 푸시 알림
- [ ] 카카오맵 통합

## Phase 6: 웹 배포
- [ ] Flutter Web 빌드
- [ ] Firebase Hosting / Vercel 배포
- [ ] 반응형 디자인 검증
