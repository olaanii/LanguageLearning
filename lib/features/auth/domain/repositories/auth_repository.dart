import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> signIn(String email, String password);
  Future<Result<UserEntity>> signUp(String email, String password);
  Future<Result<void>> signOut();
  Future<Result<UserEntity>> getCurrentUser();
}
