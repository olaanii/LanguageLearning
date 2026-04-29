class UserModel {
  final String id;
  final String email;
  final String name;
  final String avatar;
  final int score;
  final int level;
  final int progress;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.score,
    required this.level,
    required this.progress,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? 'Learner',
      avatar:
          json['avatar'] as String? ??
          'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix&backgroundColor=E0E7FF',
      score: (json['score'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'avatar': avatar,
      'score': score,
      'level': level,
      'progress': progress,
    };
  }
}
