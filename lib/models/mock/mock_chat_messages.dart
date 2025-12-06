import 'package:ongi_front/models/entities/chat_message_model.dart';

/// Mock 채팅 메시지 데이터
class MockChatMessages {
  // Private 생성자
  MockChatMessages._();

  /// 현재 사용자 ID (Mock)
  static const int currentUserId = 100;

  /// 주말 러닝크루 채팅 Mock 데이터
  static List<ChatMessage> get weekendRunningCrewChat => [
        // 시스템 메시지 - 입장
        ChatMessage(
          id: 1,
          senderId: 0,
          senderName: '시스템',
          content: "'달려라 사자'님께서 입장했습니다",
          sentAt: DateTime(2025, 11, 20, 18, 30),
          isMe: false,
          type: MessageType.system,
        ),

        // 챗봇 환영 메시지
        ChatMessage(
          id: 2,
          senderId: -1,
          senderName: '채팅봇',
          content: '주말 러닝크루\n가입을 환영합니다!\n\n'
              '모임을 시작하기 전,\n첫 가이드를 꼭 읽어보세요 :)',
          sentAt: DateTime(2025, 11, 20, 18, 36),
          isMe: false,
          type: MessageType.welcome,
        ),

        // 멤버 메시지 1
        ChatMessage(
          id: 3,
          senderId: 1,
          senderName: '김러닝',
          content: '안녕하세요 사자님!\n가입을 환영합니다 😀😀😀',
          sentAt: DateTime(2025, 11, 20, 18, 38),
          isMe: false,
          type: MessageType.text,
        ),

        // 멤버 메시지 2
        ChatMessage(
          id: 4,
          senderId: 1,
          senderName: '김러닝',
          content: '모임 규칙 한번 읽어주시고,\n확인하셨으면 좋아요 버튼 한번 눌러 주세요!!',
          sentAt: DateTime(2025, 11, 20, 18, 38),
          isMe: false,
          type: MessageType.text,
        ),

        // 일정 제안 메시지
        ChatMessage(
          id: 5,
          senderId: 12,
          senderName: '열심히달린다',
          content: '마침 이번주에 다같이 만나기로 했는데, 스케줄 괜찮으세요?',
          sentAt: DateTime(2025, 11, 20, 18, 40),
          isMe: false,
          type: MessageType.text,
        ),

        // 일정 제안 카드
        ChatMessage(
          id: 6,
          senderId: 12,
          senderName: '열심히달린다',
          content: '',
          sentAt: DateTime(2025, 11, 20, 18, 40),
          isMe: false,
          type: MessageType.schedule,
          scheduleData: ScheduleProposal(
            title: '이번주 토요일 오전 8시',
            scheduledAt: DateTime(2025, 11, 23, 8, 0),
            location: '한강공원 뚝섬유원지',
            description: '5km 가볍게 달리고 브런치',
            attendeeCount: 8,
            absentCount: 1,
          ),
        ),

        // 내 메시지
        ChatMessage(
          id: 7,
          senderId: currentUserId,
          senderName: '달리는 사자',
          content: '네! 좋습니다 ㅎㅎㅎ\n앞으로 잘 부탁드려요!!',
          sentAt: DateTime(2025, 11, 20, 18, 44),
          isMe: true,
          type: MessageType.text,
        ),
      ];
}
