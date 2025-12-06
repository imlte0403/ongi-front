/// 채팅 메시지 타입
enum MessageType {
  /// 일반 텍스트 메시지
  text,

  /// 시스템 메시지 (입장, 퇴장 등)
  system,

  /// 챗봇 환영 메시지
  welcome,

  /// 일정 제안
  schedule,
}

/// 채팅 메시지 모델
class ChatMessage {
  final int id;
  final int senderId;
  final String senderName;
  final String? senderProfileUrl;
  final String content;
  final DateTime sentAt;
  final bool isMe;
  final MessageType type;
  final ScheduleProposal? scheduleData;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderProfileUrl,
    required this.content,
    required this.sentAt,
    required this.isMe,
    this.type = MessageType.text,
    this.scheduleData,
  });

  /// 시스템 메시지인지 확인
  bool get isSystemMessage => type == MessageType.system;

  /// 환영 메시지인지 확인
  bool get isWelcomeMessage => type == MessageType.welcome;

  /// 일정 제안인지 확인
  bool get isScheduleMessage => type == MessageType.schedule;
}

/// 일정 제안 데이터
class ScheduleProposal {
  final String title;
  final DateTime scheduledAt;
  final String location;
  final String? description;
  final int attendeeCount;
  final int absentCount;

  const ScheduleProposal({
    required this.title,
    required this.scheduledAt,
    required this.location,
    this.description,
    this.attendeeCount = 0,
    this.absentCount = 0,
  });
}
