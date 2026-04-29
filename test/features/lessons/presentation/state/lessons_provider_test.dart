import 'package:flutter_test/flutter_test.dart';
import 'package:lingualearn/core/error/failures.dart';
import 'package:lingualearn/core/utils/result.dart';
import 'package:lingualearn/features/lessons/domain/domain.dart';
import 'package:lingualearn/features/lessons/presentation/state/lessons_provider.dart';

class _FakeLessonsRepository implements LessonsRepository {
  Result<List<LessonEntity>> result;

  _FakeLessonsRepository(this.result);

  @override
  Future<Result<List<LessonEntity>>> getLessons({
    String searchQuery = '',
    String difficulty = 'All',
  }) async {
    return result;
  }
}

void main() {
  const lessons = [
    LessonEntity(
      id: 'l1',
      lessonPrefix: 'Lesson One',
      title: 'Learn Hello World',
      description: 'desc',
      category: 'Lessons',
      difficulty: 'Beginners',
      locked: false,
      progress: 0,
      totalItems: 5,
    ),
  ];

  test('loads lessons successfully', () async {
    final provider = LessonsProvider(
      getLessons: GetLessons(
        repository: _FakeLessonsRepository(Result.success(lessons)),
      ),
    );

    await Future<void>.delayed(Duration.zero);

    expect(provider.state.lessons.length, 1);
    expect(provider.state.error, isNull);
    expect(provider.state.isLoading, isFalse);
  });

  test('exposes error on failure', () async {
    final provider = LessonsProvider(
      getLessons: GetLessons(
        repository: _FakeLessonsRepository(
          Result.failure(const CacheFailure('failed')),
        ),
      ),
    );

    await Future<void>.delayed(Duration.zero);

    expect(provider.state.lessons, isEmpty);
    expect(provider.state.error, isA<CacheFailure>());
    expect(provider.state.isLoading, isFalse);
  });
}
