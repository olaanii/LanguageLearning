import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/data.dart';
import '../../features/auth/domain/domain.dart';
import '../../features/auth/presentation/state/auth_provider.dart' as app_auth;

Future<void> initAuth() async {
  final sl = GetIt.instance;

  // Providers / State Controllers
  sl.registerFactory(
    () => app_auth.AuthProvider(
      signInUser: sl(),
      signUpUser: sl(),
      signOutUser: sl(),
      getCurrentUser: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => SignInUser(repository: sl()));
  sl.registerLazySingleton(() => SignUpUser(repository: sl()));
  sl.registerLazySingleton(() => SignOutUser(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentUser(repository: sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      mapper: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(auth: sl(), firestore: sl(), logger: sl()),
  );

  // Mappers
  sl.registerLazySingleton<UserMapper>(() => UserMapper());

  // External / SDKs
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
