/// 비회원 테스트 결과 모델
/// GET /api/v1/guest/result/:sessionId 응답에 맞춤
class GuestResult {
  final String sessionId;
  final bool isLinked;
  final GuestScores scores;
  final String profileType;
  final List<String> descriptions;
  final GuestRecommendations recommendations;
  final String expiresAt;
  
  GuestResult({
    required this.sessionId,
    required this.isLinked,
    required this.scores,
    required this.profileType,
    required this.descriptions,
    required this.recommendations,
    required this.expiresAt,
  });
  
  factory GuestResult.fromJson(Map<String, dynamic> json) {
    return GuestResult(
      sessionId: json['session_id'] as String,
      isLinked: json['is_linked'] as bool,
      scores: GuestScores.fromJson(json['scores'] as Map<String, dynamic>),
      profileType: json['profile_type'] as String,
      descriptions: List<String>.from(json['descriptions'] as List),
      recommendations: GuestRecommendations.fromJson(
        json['recommendations'] as Map<String, dynamic>,
      ),
      expiresAt: json['expires_at'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'is_linked': isLinked,
      'scores': scores.toJson(),
      'profile_type': profileType,
      'descriptions': descriptions,
      'recommendations': recommendations.toJson(),
      'expires_at': expiresAt,
    };
  }
}

/// 성격 테스트 점수
class GuestScores {
  final double socialityScore;     // 사교성
  final double activityScore;      // 활동성
  final double intimacyScore;      // 친밀도
  final double immersionScore;     // 몰입도
  final double flexibilityScore;   // 유연성
  
  GuestScores({
    required this.socialityScore,
    required this.activityScore,
    required this.intimacyScore,
    required this.immersionScore,
    required this.flexibilityScore,
  });
  
  factory GuestScores.fromJson(Map<String, dynamic> json) {
    return GuestScores(
      socialityScore: (json['sociality_score'] ?? 0).toDouble(),
      activityScore: (json['activity_score'] ?? 0).toDouble(),
      intimacyScore: (json['intimacy_score'] ?? 0).toDouble(),
      immersionScore: (json['immersion_score'] ?? 0).toDouble(),
      flexibilityScore: (json['flexibility_score'] ?? 0).toDouble(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'sociality_score': socialityScore,
      'activity_score': activityScore,
      'intimacy_score': intimacyScore,
      'immersion_score': immersionScore,
      'flexibility_score': flexibilityScore,
    };
  }
}

/// 추천 결과
class GuestRecommendations {
  final List<Club> clubs;
  final List<Club> similarClubs;
  final List<Meeting> meetings;
  
  GuestRecommendations({
    required this.clubs,
    required this.similarClubs,
    required this.meetings,
  });
  
  factory GuestRecommendations.fromJson(Map<String, dynamic> json) {
    return GuestRecommendations(
      clubs: (json['clubs'] as List?)
              ?.map((c) => Club.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      similarClubs: (json['similar_clubs'] as List?)
              ?.map((c) => Club.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      meetings: (json['meetings'] as List?)
              ?.map((m) => Meeting.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'clubs': clubs.map((c) => c.toJson()).toList(),
      'similar_clubs': similarClubs.map((c) => c.toJson()).toList(),
      'meetings': meetings.map((m) => m.toJson()).toList(),
    };
  }
}

/// 클럽/모임 모델 (간단 버전)
class Club {
  final int id;
  final String name;
  final String description;
  final String? category;
  final String? imageUrl;
  final int? memberCount;
  final int? maxMembers;
  final String? location;
  final String? vibe;
  final String? meetingFrequency;
  
  Club({
    required this.id,
    required this.name,
    required this.description,
    this.category,
    this.imageUrl,
    this.memberCount,
    this.maxMembers,
    this.location,
    this.vibe,
    this.meetingFrequency,
  });
  
  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String?,
      imageUrl: json['image_url'] as String?,
      memberCount: json['member_count'] as int?,
      maxMembers: json['max_members'] as int?,
      location: json['location'] as String?,
      vibe: json['vibe'] as String?,
      meetingFrequency: json['meeting_frequency'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      if (category != null) 'category': category,
      if (imageUrl != null) 'image_url': imageUrl,
      if (memberCount != null) 'member_count': memberCount,
      if (maxMembers != null) 'max_members': maxMembers,
      if (location != null) 'location': location,
      if (vibe != null) 'vibe': vibe,
      if (meetingFrequency != null) 'meeting_frequency': meetingFrequency,
    };
  }
}

/// 모임 모델 (간단 버전)
class Meeting {
  final int id;
  final String title;
  final String? description;
  final String? location;
  final String? scheduledAt;
  final int? maxMembers;
  final String? category;
  
  Meeting({
    required this.id,
    required this.title,
    this.description,
    this.location,
    this.scheduledAt,
    this.maxMembers,
    this.category,
  });
  
  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      scheduledAt: json['scheduled_at'] as String?,
      maxMembers: json['max_members'] as int?,
      category: json['category'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (maxMembers != null) 'max_members': maxMembers,
      if (category != null) 'category': category,
    };
  }
}
