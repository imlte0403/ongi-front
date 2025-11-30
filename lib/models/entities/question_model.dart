/// 성격 테스트 질문 모델
/// 백엔드 GET /api/v1/questions 응답에 맞춤
class Question {
  final int id;
  final String text;
  final List<QuestionOption> options;
  
  Question({
    required this.id,
    required this.text,
    required this.options,
  });
  
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      text: json['text'] as String,
      options: (json['options'] as List<dynamic>)
          .map((o) => QuestionOption.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options.map((o) => o.toJson()).toList(),
    };
  }
}

/// 질문 선택지 모델
class QuestionOption {
  final int id;
  final String text;
  final double socialityScore;    // 사교성
  final double activityScore;     // 활동성
  final double intimacyScore;     // 친밀도
  final double immersionScore;    // 몰입도
  final double flexibilityScore;  // 유연성
  
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
    return QuestionOption(
      id: json['id'] as int,
      text: json['text'] as String,
      socialityScore: (json['sociality_score'] ?? 0).toDouble(),
      activityScore: (json['activity_score'] ?? 0).toDouble(),
      intimacyScore: (json['intimacy_score'] ?? 0).toDouble(),
      immersionScore: (json['immersion_score'] ?? 0).toDouble(),
      flexibilityScore: (json['flexibility_score'] ?? 0).toDouble(),
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
