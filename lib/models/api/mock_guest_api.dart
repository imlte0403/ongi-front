import 'dart:math';
import '../entities/question_model.dart';
import '../entities/guest_answer_model.dart';
import '../entities/guest_result_model.dart';

/// Mock Guest API - 백엔드 없이 로컬 개발용
/// 실제 백엔드 API와 동일한 인터페이스 제공
class MockGuestApi {
  final _random = Random();

  /// 1. Guest Session 생성 (Mock)
  /// 랜덤 세션 ID 반환
  Future<String> createSession() async {
    // 네트워크 지연 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 500));

    final sessionId = _generateSessionId();
    print('✅ [MOCK] Guest Session 생성: $sessionId');
    return sessionId;
  }

  /// 2. 질문 목록 조회 (Mock)
  /// 10개의 샘플 질문 반환
  Future<List<Question>> getQuestions() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final questions = _getMockQuestions();
    print('✅ [MOCK] 질문 ${questions.length}개 조회');
    return questions;
  }

  /// 3. 답변 제출 (Mock)
  /// 답변을 받지만 실제로 저장하지 않음
  Future<void> submitAnswers(
    String sessionId,
    List<GuestAnswer> answers,
  ) async {
    await Future.delayed(const Duration(milliseconds: 700));

    print('✅ [MOCK] 답변 ${answers.length}개 제출 완료');
  }

  /// 4. 결과 조회 (Mock)
  /// 랜덤 성격 유형과 추천 결과 반환
  Future<GuestResult> getResult(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final result = _getMockResult(sessionId);
    print('✅ [MOCK] 결과 조회: ${result.profileType}');
    return result;
  }

  // ======== Private Helper Methods ========

  /// 랜덤 세션 ID 생성
  String _generateSessionId() {
    const chars = 'abcdef0123456789';
    return List.generate(
      32,
      (index) => chars[_random.nextInt(chars.length)],
    ).join();
  }

  /// Mock 질문 데이터
  List<Question> _getMockQuestions() {
    return [
      Question(
        id: 1,
        text: '금요일 저녁, 친구가 갑자기 밖으로 불러냈다. 이때 당신의 반응은?',
        category: 'sociality',
        options: [
          QuestionOption(
            id: 1,
            text: '좋아! 바로 나갈게!',
            socialityScore: 5,
            activityScore: 4,
            intimacyScore: 0,
            immersionScore: 0,
            flexibilityScore: 5,
          ),
          QuestionOption(
            id: 2,
            text: '누가 오는지 물어본 후 결정',
            socialityScore: 3,
            activityScore: 2,
            intimacyScore: 4,
            immersionScore: 0,
            flexibilityScore: 3,
          ),
          QuestionOption(
            id: 3,
            text: '오늘은 쉬고 싶어서 거절',
            socialityScore: 1,
            activityScore: 1,
            intimacyScore: 0,
            immersionScore: 3,
            flexibilityScore: 1,
          ),
          QuestionOption(
            id: 4,
            text: '다음에 미리 약속 잡자고 함',
            socialityScore: 2,
            activityScore: 2,
            intimacyScore: 3,
            immersionScore: 4,
            flexibilityScore: 2,
          ),
        ],
      ),
      Question(
        id: 2,
        text: '새로운 취미 활동을 시작한다면?',
        category: 'activity',
        options: [
          QuestionOption(
            id: 5,
            text: '일단 시작하고 배우면서 익힌다',
            socialityScore: 4,
            activityScore: 5,
            intimacyScore: 0,
            immersionScore: 2,
            flexibilityScore: 5,
          ),
          QuestionOption(
            id: 6,
            text: '관련 자료를 충분히 찾아본 후 시작',
            socialityScore: 1,
            activityScore: 3,
            intimacyScore: 0,
            immersionScore: 5,
            flexibilityScore: 2,
          ),
          QuestionOption(
            id: 7,
            text: '친구나 동료와 함께 시작',
            socialityScore: 5,
            activityScore: 4,
            intimacyScore: 5,
            immersionScore: 0,
            flexibilityScore: 3,
          ),
          QuestionOption(
            id: 8,
            text: '강의나 레슨을 먼저 등록',
            socialityScore: 2,
            activityScore: 3,
            intimacyScore: 2,
            immersionScore: 4,
            flexibilityScore: 2,
          ),
        ],
      ),
      Question(
        id: 3,
        text: '모임에서 새로운 사람을 만났을 때?',
        category: 'intimacy',
        options: [
          QuestionOption(
            id: 9,
            text: '먼저 말을 걸고 친해지려 노력',
            socialityScore: 5,
            activityScore: 4,
            intimacyScore: 3,
            immersionScore: 0,
            flexibilityScore: 4,
          ),
          QuestionOption(
            id: 10,
            text: '상대가 말을 걸면 대화',
            socialityScore: 3,
            activityScore: 2,
            intimacyScore: 4,
            immersionScore: 0,
            flexibilityScore: 3,
          ),
          QuestionOption(
            id: 11,
            text: '관찰하면서 천천히 다가감',
            socialityScore: 2,
            activityScore: 1,
            intimacyScore: 5,
            immersionScore: 4,
            flexibilityScore: 2,
          ),
          QuestionOption(
            id: 12,
            text: '아는 사람들과만 어울림',
            socialityScore: 1,
            activityScore: 1,
            intimacyScore: 5,
            immersionScore: 3,
            flexibilityScore: 1,
          ),
        ],
      ),
      Question(
        id: 4,
        text: '관심 있는 주제를 공부할 때?',
        category: 'immersion',
        options: [
          QuestionOption(
            id: 13,
            text: '몇 시간이고 몰두해서 파고든다',
            socialityScore: 0,
            activityScore: 3,
            intimacyScore: 0,
            immersionScore: 5,
            flexibilityScore: 1,
          ),
          QuestionOption(
            id: 14,
            text: '필요한 만큼만 공부',
            socialityScore: 2,
            activityScore: 3,
            intimacyScore: 0,
            immersionScore: 2,
            flexibilityScore: 4,
          ),
          QuestionOption(
            id: 15,
            text: '친구와 함께 공부하며 토론',
            socialityScore: 5,
            activityScore: 3,
            intimacyScore: 4,
            immersionScore: 3,
            flexibilityScore: 3,
          ),
          QuestionOption(
            id: 16,
            text: '여러 주제를 조금씩 다양하게',
            socialityScore: 3,
            activityScore: 5,
            intimacyScore: 0,
            immersionScore: 1,
            flexibilityScore: 5,
          ),
        ],
      ),
      Question(
        id: 5,
        text: '갑자기 계획이 바뀌었을 때?',
        category: 'flexibility',
        options: [
          QuestionOption(
            id: 17,
            text: '재미있을 것 같으면 바로 수용',
            socialityScore: 4,
            activityScore: 5,
            intimacyScore: 0,
            immersionScore: 0,
            flexibilityScore: 5,
          ),
          QuestionOption(
            id: 18,
            text: '조금 당황하지만 적응',
            socialityScore: 2,
            activityScore: 3,
            intimacyScore: 0,
            immersionScore: 2,
            flexibilityScore: 3,
          ),
          QuestionOption(
            id: 19,
            text: '원래 계획을 유지하고 싶음',
            socialityScore: 1,
            activityScore: 1,
            intimacyScore: 0,
            immersionScore: 4,
            flexibilityScore: 1,
          ),
          QuestionOption(
            id: 20,
            text: '상황을 보고 판단',
            socialityScore: 3,
            activityScore: 2,
            intimacyScore: 3,
            immersionScore: 3,
            flexibilityScore: 4,
          ),
        ],
      ),
      Question(
        id: 6,
        text: '주말 시간을 보내는 방식은?',
        category: 'activity',
        options: [
          QuestionOption(
            id: 21,
            text: '밖에서 활동적으로 보낸다',
            socialityScore: 4,
            activityScore: 5,
            intimacyScore: 0,
            immersionScore: 0,
            flexibilityScore: 4,
          ),
          QuestionOption(
            id: 22,
            text: '집에서 쉬면서 취미 생활',
            socialityScore: 1,
            activityScore: 2,
            intimacyScore: 0,
            immersionScore: 5,
            flexibilityScore: 2,
          ),
          QuestionOption(
            id: 23,
            text: '친구들과 모임',
            socialityScore: 5,
            activityScore: 3,
            intimacyScore: 5,
            immersionScore: 0,
            flexibilityScore: 3,
          ),
          QuestionOption(
            id: 24,
            text: '그때그때 기분에 따라',
            socialityScore: 3,
            activityScore: 3,
            intimacyScore: 0,
            immersionScore: 2,
            flexibilityScore: 5,
          ),
        ],
      ),
      Question(
        id: 7,
        text: '모임에서 당신의 역할은?',
        category: 'sociality',
        options: [
          QuestionOption(
            id: 25,
            text: '분위기 메이커',
            socialityScore: 5,
            activityScore: 5,
            intimacyScore: 3,
            immersionScore: 0,
            flexibilityScore: 4,
          ),
          QuestionOption(
            id: 26,
            text: '경청하는 조력자',
            socialityScore: 3,
            activityScore: 2,
            intimacyScore: 5,
            immersionScore: 3,
            flexibilityScore: 3,
          ),
          QuestionOption(
            id: 27,
            text: '필요할 때만 의견 제시',
            socialityScore: 2,
            activityScore: 2,
            intimacyScore: 3,
            immersionScore: 4,
            flexibilityScore: 3,
          ),
          QuestionOption(
            id: 28,
            text: '주로 관찰하는 편',
            socialityScore: 1,
            activityScore: 1,
            intimacyScore: 2,
            immersionScore: 5,
            flexibilityScore: 2,
          ),
        ],
      ),
      Question(
        id: 8,
        text: '새로운 환경에 적응하는 방식은?',
        category: 'flexibility',
        options: [
          QuestionOption(
            id: 29,
            text: '빨리 적응하고 즐긴다',
            socialityScore: 5,
            activityScore: 5,
            intimacyScore: 0,
            immersionScore: 0,
            flexibilityScore: 5,
          ),
          QuestionOption(
            id: 30,
            text: '천천히 관찰하며 적응',
            socialityScore: 2,
            activityScore: 2,
            intimacyScore: 4,
            immersionScore: 4,
            flexibilityScore: 3,
          ),
          QuestionOption(
            id: 31,
            text: '누군가와 함께면 편함',
            socialityScore: 3,
            activityScore: 3,
            intimacyScore: 5,
            immersionScore: 0,
            flexibilityScore: 2,
          ),
          QuestionOption(
            id: 32,
            text: '적응하는데 시간이 걸림',
            socialityScore: 1,
            activityScore: 1,
            intimacyScore: 3,
            immersionScore: 5,
            flexibilityScore: 1,
          ),
        ],
      ),
      Question(
        id: 9,
        text: '프로젝트나 과제를 진행할 때?',
        category: 'immersion',
        options: [
          QuestionOption(
            id: 33,
            text: '완벽하게 마무리하려고 노력',
            socialityScore: 1,
            activityScore: 3,
            intimacyScore: 0,
            immersionScore: 5,
            flexibilityScore: 1,
          ),
          QuestionOption(
            id: 34,
            text: '빠르게 진행하고 수정',
            socialityScore: 3,
            activityScore: 5,
            intimacyScore: 0,
            immersionScore: 2,
            flexibilityScore: 5,
          ),
          QuestionOption(
            id: 35,
            text: '팀원들과 협력하며 진행',
            socialityScore: 5,
            activityScore: 3,
            intimacyScore: 5,
            immersionScore: 3,
            flexibilityScore: 3,
          ),
          QuestionOption(
            id: 36,
            text: '필요한 만큼만 투자',
            socialityScore: 2,
            activityScore: 3,
            intimacyScore: 0,
            immersionScore: 2,
            flexibilityScore: 4,
          ),
        ],
      ),
      Question(
        id: 10,
        text: '친구와의 관계에서 중요한 것은?',
        category: 'intimacy',
        options: [
          QuestionOption(
            id: 37,
            text: '깊은 대화와 이해',
            socialityScore: 2,
            activityScore: 1,
            intimacyScore: 5,
            immersionScore: 4,
            flexibilityScore: 2,
          ),
          QuestionOption(
            id: 38,
            text: '함께 즐거운 시간',
            socialityScore: 5,
            activityScore: 5,
            intimacyScore: 3,
            immersionScore: 0,
            flexibilityScore: 4,
          ),
          QuestionOption(
            id: 39,
            text: '서로 존중하고 배려',
            socialityScore: 3,
            activityScore: 2,
            intimacyScore: 5,
            immersionScore: 3,
            flexibilityScore: 3,
          ),
          QuestionOption(
            id: 40,
            text: '편안한 거리 유지',
            socialityScore: 2,
            activityScore: 2,
            intimacyScore: 3,
            immersionScore: 4,
            flexibilityScore: 3,
          ),
        ],
      ),
    ];
  }

  /// Mock 결과 데이터
  GuestResult _getMockResult(String sessionId) {
    // 랜덤 점수 생성
    final scores = GuestScores(
      socialityScore: 50 + _random.nextDouble() * 40, // 50-90
      activityScore: 50 + _random.nextDouble() * 40,
      intimacyScore: 50 + _random.nextDouble() * 40,
      immersionScore: 50 + _random.nextDouble() * 40,
      flexibilityScore: 50 + _random.nextDouble() * 40,
    );

    // 점수에 따른 성격 유형 결정
    final profileType = _determineProfileType(scores);

    // 만료 시간 (7일 후)
    final expiresAt =
        DateTime.now().add(const Duration(days: 7)).toIso8601String();

    return GuestResult(
      sessionId: sessionId,
      isLinked: false,
      scores: scores,
      profileType: profileType,
      descriptions: _getDescriptions(profileType),
      recommendations: _getMockRecommendations(),
      expiresAt: expiresAt,
    );
  }

  /// 점수 기반 성격 유형 결정
  String _determineProfileType(GuestScores scores) {
    final types = [
      '열정적인 사교가',
      '따뜻한 조력자',
      '도전적인 탐험가',
      '깊이있는 전문가',
      '유연한 적응형',
      '친근한 외향형',
      '집중하는 몰입형',
      '균형잡힌 조화형',
    ];

    // 가장 높은 점수에 따라 유형 결정
    if (scores.socialityScore > 70 && scores.activityScore > 70) {
      return types[0]; // 열정적인 사교가
    } else if (scores.intimacyScore > 70) {
      return types[1]; // 따뜻한 조력자
    } else if (scores.activityScore > 70 && scores.flexibilityScore > 70) {
      return types[2]; // 도전적인 탐험가
    } else if (scores.immersionScore > 70) {
      return types[3]; // 깊이있는 전문가
    } else if (scores.flexibilityScore > 70) {
      return types[4]; // 유연한 적응형
    } else if (scores.socialityScore > 70) {
      return types[5]; // 친근한 외향형
    } else if (scores.immersionScore > 60 && scores.socialityScore < 60) {
      return types[6]; // 집중하는 몰입형
    } else {
      return types[7]; // 균형잡힌 조화형
    }
  }

  /// 성격 유형별 설명
  List<String> _getDescriptions(String profileType) {
    final descriptions = {
      '열정적인 사교가': [
        '당신은 에너지 넘치는 사교가입니다! 사람들과 함께하는 활동을 즐기고, 새로운 경험에 열려있습니다.',
        '다양한 사람들과 쉽게 친해지며, 모임의 분위기를 활기차게 만듭니다.',
        '대규모 모임이나 파티를 좋아하며, 여러 활동을 동시에 즐기는 경향이 있습니다.',
      ],
      '따뜻한 조력자': [
        '당신은 깊은 관계를 중시하는 따뜻한 사람입니다. 친밀한 소수의 관계를 선호합니다.',
        '경청을 잘하고 공감 능력이 뛰어나 사람들이 편안함을 느낍니다.',
        '소규모 모임에서 진정성 있는 대화를 나누는 것을 좋아합니다.',
      ],
      '도전적인 탐험가': [
        '당신은 새로운 것을 시도하길 좋아하는 모험가입니다! 변화를 두려워하지 않고 적극적으로 받아들입니다.',
        '다양한 활동에 도전하며, 익숙하지 않은 환경에서도 빠르게 적응합니다.',
        '자유로운 분위기의 활동적인 모임을 선호합니다.',
      ],
      '깊이있는 전문가': [
        '당신은 관심 분야에 깊이 몰두하는 전문가형입니다. 한 가지를 오래 파고드는 것을 좋아합니다.',
        '표면적인 관계보다는 의미 있는 소수의 관계를 선호합니다.',
        '전문성을 추구하는 스터디 그룹이나 깊이 있는 토론 모임에 잘 맞습니다.',
      ],
      '유연한 적응형': [
        '당신은 상황에 따라 유연하게 대처하는 적응형입니다. 계획보다는 즉흥적인 것을 즐깁니다.',
        '다양한 상황에서 편안함을 느끼며, 변화를 즐깁니다.',
        '자유로운 분위기의 다양한 활동이 있는 모임이 잘 맞습니다.',
      ],
      '친근한 외향형': [
        '당신은 사람들과 쉽게 친해지는 친근한 외향형입니다. 사교 활동을 즐깁니다.',
        '새로운 사람을 만나는 것을 두려워하지 않으며, 자연스럽게 대화를 이끌어갑니다.',
        '다양한 사람들을 만날 수 있는 네트워킹 모임이나 소셜 이벤트가 잘 맞습니다.',
      ],
      '집중하는 몰입형': [
        '당신은 혼자 집중하는 시간을 소중히 여기는 몰입형입니다. 깊이 있는 활동을 선호합니다.',
        '한 가지에 집중하여 전문성을 키우는 것을 좋아합니다.',
        '소규모의 깊이 있는 활동이나 개인 프로젝트가 잘 맞습니다.',
      ],
      '균형잡힌 조화형': [
        '당신은 외향과 내향의 균형을 잘 맞추는 조화형입니다. 상황에 따라 유연하게 대처합니다.',
        '다양한 활동을 즐기되, 혼자만의 시간도 중요하게 생각합니다.',
        '균형잡힌 다양한 모임에서 모두 잘 어울릴 수 있습니다.',
      ],
    };

    return descriptions[profileType] ??
        [
          '당신은 독특한 성격을 가진 사람입니다.',
          '다양한 상황에서 자신만의 방식으로 대처합니다.',
          '여러 모임에서 당신만의 색깔을 발휘할 수 있습니다.',
        ];
  }

  /// Mock 추천 데이터
  GuestRecommendations _getMockRecommendations() {
    return GuestRecommendations(
      clubs: [
        Club(
          id: 1,
          name: '서울 러닝 크루',
          description: '함께 달리며 건강을 챙기는 러닝 모임입니다',
          category: '운동',
          imageUrl: 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5',
          memberCount: 24,
          maxMembers: 30,
          location: '한강공원',
          vibe: 'energetic',
          meetingFrequency: '주 2회',
        ),
        Club(
          id: 2,
          name: '독서 토론 모임',
          description: '한 달에 한 권, 깊이 있는 독서와 토론',
          category: '문화',
          imageUrl:
              'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f',
          memberCount: 12,
          maxMembers: 15,
          location: '강남 카페',
          vibe: 'calm',
          meetingFrequency: '월 2회',
        ),
        Club(
          id: 3,
          name: '보드게임 동호회',
          description: '다양한 보드게임을 즐기는 즐거운 모임',
          category: '게임',
          imageUrl:
              'https://images.unsplash.com/photo-1606503153255-59d7e07a6e6a',
          memberCount: 18,
          maxMembers: 25,
          location: '홍대 보드게임 카페',
          vibe: 'fun',
          meetingFrequency: '주 1회',
        ),
      ],
      similarClubs: [
        Club(
          id: 4,
          name: '요가 클래스',
          description: '심신의 균형을 찾는 요가 수업',
          category: '운동',
          imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b',
          memberCount: 15,
          maxMembers: 20,
          location: '강남 요가 스튜디오',
          vibe: 'peaceful',
          meetingFrequency: '주 3회',
        ),
        Club(
          id: 5,
          name: '사진 동호회',
          description: '함께 출사 다니며 사진 실력을 키우는 모임',
          category: '예술',
          imageUrl:
              'https://images.unsplash.com/photo-1452587925148-ce544e77e70d',
          memberCount: 20,
          maxMembers: 30,
          location: '서울 곳곳',
          vibe: 'creative',
          meetingFrequency: '주 1회',
        ),
      ],
      meetings: [
        Meeting(
          id: 1,
          title: '주말 한강 러닝',
          description: '상쾌한 주말 아침 한강에서 10km 달리기',
          location: '한강공원 반포지구',
          scheduledAt:
              DateTime.now().add(const Duration(days: 3)).toIso8601String(),
          maxMembers: 15,
          category: '운동',
        ),
        Meeting(
          id: 2,
          title: '이달의 책 토론',
          description: '"1984" 조지 오웰 토론',
          location: '강남 북카페',
          scheduledAt:
              DateTime.now().add(const Duration(days: 5)).toIso8601String(),
          maxMembers: 10,
          category: '문화',
        ),
        Meeting(
          id: 3,
          title: '보드게임 나이트',
          description: '새로운 보드게임 체험 및 대회',
          location: '홍대 보드게임 카페',
          scheduledAt:
              DateTime.now().add(const Duration(days: 2)).toIso8601String(),
          maxMembers: 20,
          category: '게임',
        ),
      ],
    );
  }
}

/// Mock GuestApi 싱글톤 인스턴스
final mockGuestApi = MockGuestApi();
