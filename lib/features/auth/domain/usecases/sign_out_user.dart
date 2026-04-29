import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class SignOutUser implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SignOutUser({required this.repository});

  @override
  Future<Result<void>> call(NoParams params) {
    return repository.signOut();
  }
}
