class LessonEntity {
  final String id;
  final String lessonPrefix;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final bool locked;
  final int progress;
  final int totalItems;
  final String? image;
  final String? colorBg;

  const LessonEntity({
    required this.id,
    required this.lessonPrefix,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.locked,
    required this.progress,
    required this.totalItems,
    this.image,
    this.colorBg,
  });
}
