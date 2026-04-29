import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/lesson_entity.dart';
import '../repositories/lessons_repository.dart';

class GetLessonsParams {
  final String searchQuery;
  final String difficulty;

  const GetLessonsParams({this.searchQuery = '', this.difficulty = 'All'});
}

class GetLessons implements UseCase<List<LessonEntity>, GetLessonsParams> {
  final LessonsRepository repository;

  GetLessons({required this.repository});

  @override
  Future<Result<List<LessonEntity>>> call(GetLessonsParams params) {
    return repository.getLessons(
      searchQuery: params.searchQuery,
      difficulty: params.difficulty,
    );
  }
}
