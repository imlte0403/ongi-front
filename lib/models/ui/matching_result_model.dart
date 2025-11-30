class SimilarProfile {
  final String name;
  final String mbti;
  final String imageUrl;
  final String description;

  SimilarProfile({
    required this.name,
    required this.mbti,
    required this.imageUrl,
    required this.description,
  });
}

class CategoryStat {
  final String label;
  final String icon; // 이모지를 사용하므로 String
  final int percentage;

  CategoryStat({
    required this.label,
    required this.icon,
    required this.percentage,
  });
}

class RecommendedClub {
  final String name;
  final String emoji;
  final int matchRate;
  final int memberCount;
  final double rating;
  final String description;
  final List<String> tags;

  RecommendedClub({
    required this.name,
    required this.emoji,
    required this.matchRate,
    required this.memberCount,
    required this.rating,
    required this.description,
    required this.tags,
  });
}
