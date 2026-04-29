import 'package:flutter_test/flutter_test.dart';
import 'package:lingualearn/core/utils/result.dart';
import 'package:lingualearn/features/lessons/domain/domain.dart';

class _FakeLessonsRepository implements LessonsRepository {
  String? lastQuery;
  String? lastDifficulty;

  @override
  Future<Result<List<LessonEntity>>> getLessons({
    String searchQuery = '',
    String difficulty = 'All',
  }) async {
    lastQuery = searchQuery;
    lastDifficulty = difficulty;
    return Result.success(const []);
  }
}

void main() {
  test('GetLessons forwards params to repository', () async {
    final repo = _FakeLessonsRepository();
    final usecase = GetLessons(repository: repo);

    final result = await usecase(
      const GetLessonsParams(searchQuery: 'hello', difficulty: 'Beginners'),
    );

    expect(result.isSuccess, isTrue);
    expect(repo.lastQuery, 'hello');
    expect(repo.lastDifficulty, 'Beginners');
  });
}
