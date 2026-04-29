import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  GetCurrentUser({required this.repository});

  @override
  Future<Result<UserEntity>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}
