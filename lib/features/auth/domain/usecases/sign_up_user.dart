import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpParams {
  final String email;
  final String password;

  const SignUpParams({required this.email, required this.password});
}

class SignUpUser implements UseCase<UserEntity, SignUpParams> {
  final AuthRepository repository;

  SignUpUser({required this.repository});

  @override
  Future<Result<UserEntity>> call(SignUpParams params) {
    return repository.signUp(params.email, params.password);
  }
}
