import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../core/utils/result.dart';
import '../../domain/domain.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../mappers/user_mapper.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource? localDataSource; // Placeholder for future
  final NetworkInfo networkInfo;
  final UserMapper mapper;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource,
    required this.networkInfo,
    required this.mapper,
  });

  @override
  Future<Result<UserEntity>> signIn(String email, String password) async {
    return _handleAuthCall(() => remoteDataSource.signIn(email, password));
  }

  @override
  Future<Result<UserEntity>> signUp(String email, String password) async {
    return _handleAuthCall(() => remoteDataSource.signUp(email, password));
  }

  @override
  Future<Result<void>> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signOut();
        // await localDataSource?.clearCache();
        return Result.success(null);
      } on ServerException catch (e) {
        return Result.failure(ServerFailure(e.message));
      }
    } else {
      return Result.failure(const NetworkFailure());
    }
  }

  @override
  Future<Result<UserEntity>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.getCurrentUser();
        // await localDataSource?.cacheUser(remoteUser);
        return Result.success(mapper.toEntity(remoteUser));
      } on ServerException catch (e) {
        return Result.failure(ServerFailure(e.message));
      }
    } else {
      // Future: Return from local cache if offline
      // return await _handleLocalUser();
      return Result.failure(const NetworkFailure());
    }
  }

  // Helper method to wrap repeated logic
  Future<Result<UserEntity>> _handleAuthCall(
    Future<UserModel> Function() remoteCall,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteModel = await remoteCall();
        // await localDataSource?.cacheUser(remoteModel);
        final entity = mapper.toEntity(remoteModel);
        return Result.success(entity);
      } on ServerException catch (e) {
        return Result.failure(ServerFailure(e.message));
      } catch (e) {
        return Result.failure(const ServerFailure("Unknown Error"));
      }
    } else {
      return Result.failure(const NetworkFailure());
    }
  }
}
