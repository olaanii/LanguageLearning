import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInParams {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});
}

class SignInUser implements UseCase<UserEntity, SignInParams> {
  final AuthRepository repository;

  SignInUser({required this.repository});

  @override
  Future<Result<UserEntity>> call(SignInParams params) {
    return repository.signIn(params.email, params.password);
  }
}
