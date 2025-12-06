/// 모임 상세 정보 모델
class ClubDetail {
  final int id;
  final String name;
  final String description;
  final String coverImageUrl;
  final List<ClubMember> members;
  final ClubSchedule? nextMeeting;
  final List<String> rules;

  const ClubDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.coverImageUrl,
    required this.members,
    this.nextMeeting,
    required this.rules,
  });
}

/// 모임 멤버
class ClubMember {
  final int id;
  final String nickname;
  final String? profileImageUrl;

  const ClubMember({
    required this.id,
    required this.nickname,
    this.profileImageUrl,
  });
}

/// 모임 일정
class ClubSchedule {
  final int id;
  final String title;
  final DateTime scheduledAt;
  final String location;

  const ClubSchedule({
    required this.id,
    required this.title,
    required this.scheduledAt,
    required this.location,
  });
}
