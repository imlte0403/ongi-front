import 'package:ongi_front/models/entities/club_detail_model.dart';

/// Mock 모임 상세 데이터
class MockClubDetail {
  // Private 생성자
  MockClubDetail._();

  /// 주말 러닝크루 Mock 데이터
  static ClubDetail get weekendRunningCrew => ClubDetail(
        id: 1,
        name: '주말 러닝크루',
        description:
            '매주 토요일 아침, 한강에서 가볍게 러닝하며 건강한 주말을 시작해요. 초보자도 환영합니다! 5km, 10km 코스 중 선택 가능하며, 러닝 후에는 함께 근처 맛집에서 간단하게 식사하실 수 있어요. (선택)',
        coverImageUrl:
            'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=800',
        members: _mockMembers,
        nextMeeting: ClubSchedule(
          id: 1,
          title: '3회차 모임',
          scheduledAt: DateTime(2025, 12, 6, 8, 0),
          location: '한강 뚝섬유원지',
        ),
        rules: [
          '시간 약속은 꼭 지켜주세요',
          '불참 시 최소 하루 전 공유해주세요',
          '서로 존중하며 즐겁게 운동해요',
          '개인 페이스를 존중합니다',
        ],
      );

  /// Mock 멤버 리스트
  static List<ClubMember> get _mockMembers => [
        const ClubMember(id: 1, nickname: '김러닝'),
        const ClubMember(id: 2, nickname: '나는거지'),
        const ClubMember(id: 3, nickname: '정주나요'),
        const ClubMember(id: 4, nickname: '열계백숙'),
        const ClubMember(id: 5, nickname: '달려라 허니'),
        const ClubMember(id: 6, nickname: '우주하마'),
        const ClubMember(id: 7, nickname: '함도니'),
        const ClubMember(id: 8, nickname: '키작은꼬마'),
        const ClubMember(id: 9, nickname: '냉면시카'),
        const ClubMember(id: 10, nickname: '순정마초'),
        const ClubMember(id: 11, nickname: '광수'),
        const ClubMember(id: 12, nickname: '열심히달린다'),
      ];
}
