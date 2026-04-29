import '../../../../constants/dummy_data.dart';
import '../models/lesson_model.dart';

abstract class LessonsLocalDataSource {
  Future<List<LessonModel>> getLessons({
    String searchQuery = '',
    String difficulty = 'All',
  });
}

class LessonsLocalDataSourceImpl implements LessonsLocalDataSource {
  @override
  Future<List<LessonModel>> getLessons({
    String searchQuery = '',
    String difficulty = 'All',
  }) async {
    final normalizedQuery = searchQuery.toLowerCase();

    final filtered = DummyData.lessons.where((lesson) {
      final matchesDifficulty =
          difficulty == 'All' || lesson.difficulty == difficulty;
      final matchesSearch =
          lesson.title.toLowerCase().contains(normalizedQuery) ||
          lesson.description.toLowerCase().contains(normalizedQuery);
      return matchesDifficulty && matchesSearch;
    }).toList();

    return filtered
        .map(
          (lesson) => LessonModel(
            id: lesson.id,
            lessonPrefix: lesson.lessonPrefix,
            title: lesson.title,
            description: lesson.description,
            category: lesson.category,
            difficulty: lesson.difficulty,
            locked: lesson.locked,
            progress: lesson.progress,
            totalItems: lesson.totalItems,
            image: lesson.image,
            colorBg: lesson.colorBg,
          ),
        )
        .toList();
  }
}
