import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_lessons.dart';
import 'lessons_state.dart';

class LessonsProvider extends ChangeNotifier {
  final GetLessons getLessons;

  LessonsState _state = const LessonsState();
  LessonsState get state => _state;

  LessonsProvider({required this.getLessons}) {
    loadLessons();
  }

  static const List<String> tabs = [
    'All',
    'Beginners',
    'Intermediate',
    'Advanced',
  ];

  void _setState(LessonsState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> loadLessons() async {
    _setState(_state.copyWith(isLoading: true, clearError: true));
    final result = await getLessons(
      GetLessonsParams(
        searchQuery: _state.searchQuery,
        difficulty: _state.activeDifficulty,
      ),
    );

    if (result.isSuccess) {
      _setState(
        _state.copyWith(
          isLoading: false,
          lessons: result.data ?? const [],
          clearError: true,
        ),
      );
    } else {
      _setState(_state.copyWith(isLoading: false, error: result.failure));
    }
  }

  Future<void> updateSearchQuery(String query) async {
    _setState(_state.copyWith(searchQuery: query));
    await loadLessons();
  }

  Future<void> updateDifficulty(String difficulty) async {
    _setState(_state.copyWith(activeDifficulty: difficulty));
    await loadLessons();
  }
}
