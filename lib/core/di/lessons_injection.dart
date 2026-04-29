import 'package:get_it/get_it.dart';
import '../../features/lessons/data/data.dart';
import '../../features/lessons/domain/domain.dart';
import '../../features/lessons/presentation/state/lessons_provider.dart';

Future<void> initLessons() async {
  final sl = GetIt.instance;

  sl.registerFactory(() => LessonsProvider(getLessons: sl()));

  sl.registerLazySingleton(() => GetLessons(repository: sl()));

  sl.registerLazySingleton<LessonsRepository>(
    () => LessonsRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      mapper: sl(),
    ),
  );

  sl.registerLazySingleton<LessonsLocalDataSource>(
    () => LessonsLocalDataSourceImpl(),
  );

  sl.registerLazySingleton(() => LessonMapper());
}
