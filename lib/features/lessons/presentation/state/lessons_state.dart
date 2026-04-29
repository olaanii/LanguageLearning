import '../../../../../core/error/failures.dart';
import '../../domain/entities/lesson_entity.dart';

class LessonsState {
  final bool isLoading;
  final List<LessonEntity> lessons;
  final String searchQuery;
  final String activeDifficulty;
  final Failure? error;

  const LessonsState({
    this.isLoading = false,
    this.lessons = const [],
    this.searchQuery = '',
    this.activeDifficulty = 'All',
    this.error,
  });

  LessonsState copyWith({
    bool? isLoading,
    List<LessonEntity>? lessons,
    String? searchQuery,
    String? activeDifficulty,
    Failure? error,
    bool clearError = false,
  }) {
    return LessonsState(
      isLoading: isLoading ?? this.isLoading,
      lessons: lessons ?? this.lessons,
      searchQuery: searchQuery ?? this.searchQuery,
      activeDifficulty: activeDifficulty ?? this.activeDifficulty,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
