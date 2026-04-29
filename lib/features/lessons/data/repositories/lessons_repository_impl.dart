import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../core/utils/result.dart';
import '../../domain/domain.dart';
import '../datasources/lessons_local_data_source.dart';
import '../datasources/lessons_remote_data_source.dart';
import '../mappers/lesson_mapper.dart';

class LessonsRepositoryImpl implements LessonsRepository {
  final LessonsLocalDataSource localDataSource;
  final LessonsRemoteDataSource? remoteDataSource;
  final NetworkInfo networkInfo;
  final LessonMapper mapper;

  LessonsRepositoryImpl({
    required this.localDataSource,
    this.remoteDataSource,
    required this.networkInfo,
    required this.mapper,
  });

  @override
  Future<Result<List<LessonEntity>>> getLessons({
    String searchQuery = '',
    String difficulty = 'All',
  }) async {
    try {
      if (await networkInfo.isConnected && remoteDataSource != null) {
        final remoteLessons = await remoteDataSource!.getLessons(
          searchQuery: searchQuery,
          difficulty: difficulty,
        );
        return Result.success(remoteLessons.map(mapper.toEntity).toList());
      }

      final localLessons = await localDataSource.getLessons(
        searchQuery: searchQuery,
        difficulty: difficulty,
      );
      return Result.success(localLessons.map(mapper.toEntity).toList());
    } catch (_) {
      return Result.failure(const CacheFailure('Failed to load lessons'));
    }
  }
}
