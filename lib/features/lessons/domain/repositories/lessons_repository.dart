import '../../../../core/utils/result.dart';
import '../entities/lesson_entity.dart';

abstract class LessonsRepository {
  Future<Result<List<LessonEntity>>> getLessons({
    String searchQuery = '',
    String difficulty = 'All',
  });
}
