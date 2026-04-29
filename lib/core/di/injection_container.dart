import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../logger/app_logger.dart';
import '../network/network_info.dart';
import 'auth_injection.dart';
import 'dashboard_injection.dart';
import 'flashcards_injection.dart';
import 'lessons_injection.dart';
import 'quiz_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<AppLogger>(() => AppLoggerImpl());

  // ! External
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  // ! Features
  await initAuth();
  await initDashboard();
  await initLessons();
  await initFlashcards();
  await initQuiz();
}
