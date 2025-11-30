/// 비회원 사용자의 답변 모델
/// POST /api/v1/guest/answers 요청에 사용
class GuestAnswer {
  final int questionId;
  final int optionId;
  
  GuestAnswer({
    required this.questionId,
    required this.optionId,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'option_id': optionId,
    };
  }
  
  factory GuestAnswer.fromJson(Map<String, dynamic> json) {
    return GuestAnswer(
      questionId: json['question_id'] as int,
      optionId: json['option_id'] as int,
    );
  }
}
