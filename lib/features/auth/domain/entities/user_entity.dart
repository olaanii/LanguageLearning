class UserEntity {
  final String id;
  final String email;
  final String name;
  final String avatar;
  final int score;
  final int level;
  final int progress;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.score,
    required this.level,
    required this.progress,
  });
}
