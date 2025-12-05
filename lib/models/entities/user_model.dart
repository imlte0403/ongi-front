class User {
  final int id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final String? nickname;
  final String? bio;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    this.nickname,
    this.bio,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      nickname: json['nickname'] as String?,
      bio: json['bio'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profile_image_url': profileImageUrl,
      'nickname': nickname,
      'bio': bio,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
