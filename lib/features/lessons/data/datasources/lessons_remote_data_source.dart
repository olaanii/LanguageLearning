import '../models/lesson_model.dart';

abstract class LessonsRemoteDataSource {
  Future<List<LessonModel>> getLessons({
    String searchQuery = '',
    String difficulty = 'All',
  });
}
