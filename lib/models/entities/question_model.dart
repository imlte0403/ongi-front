/// 성격 테스트 질문 모델
/// 백엔드 GET /api/v1/questions 응답에 맞춤
class Question {
  final int id;
  final String text;
  final String? category;
  final List<QuestionOption> options;

  Question({
    required this.id,
    required this.text,
    this.category,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      text: json['question_text'] as String? ?? json['text'] as String? ?? '',
      category: json['category'] as String?,
      options: (json['options'] as List<dynamic>)
          .map((o) => QuestionOption.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'category': category,
      'options': options.map((o) => o.toJson()).toList(),
    };
  }
}

/// 질문 선택지 모델
class QuestionOption {
  final int id;
  final String text;
  final double socialityScore; // 사교성
  final double activityScore; // 활동성
  final double intimacyScore; // 친밀도
  final double immersionScore; // 몰입도
  final double flexibilityScore; // 유연성

  QuestionOption({
    required this.id,
    required this.text,
    required this.socialityScore,
    required this.activityScore,
    required this.intimacyScore,
    required this.immersionScore,
    required this.flexibilityScore,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    // 백엔드는 option_text 필드 사용
    final text =
        json['option_text'] as String? ?? json['text'] as String? ?? '';
    // 백엔드는 score와 weight 필드 사용 (개별 점수 없음)
    final score = (json['score'] ?? 0).toDouble();

    return QuestionOption(
      id: json['id'] as int,
      text: text,
      // weight에 따라 해당 점수만 설정
      socialityScore: json['weight'] == 'sociality' ? score : 0,
      activityScore: json['weight'] == 'activity' ? score : 0,
      intimacyScore: json['weight'] == 'intimacy' ? score : 0,
      immersionScore: json['weight'] == 'immersion' ? score : 0,
      flexibilityScore: json['weight'] == 'flexibility' ? score : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'sociality_score': socialityScore,
      'activity_score': activityScore,
      'intimacy_score': intimacyScore,
      'immersion_score': immersionScore,
      'flexibility_score': flexibilityScore,
    };
  }
}
