import 'package:flutter_test/flutter_test.dart';
import 'package:lingualearn/core/utils/result.dart';
import 'package:lingualearn/features/auth/domain/domain.dart';

class _FakeAuthRepository implements AuthRepository {
  String? lastEmail;
  String? lastPassword;

  @override
  Future<Result<UserEntity>> signIn(String email, String password) async {
    lastEmail = email;
    lastPassword = password;
    return Result.success(
      const UserEntity(
        id: '1',
        email: 'mail@test.dev',
        name: 'Test',
        avatar: 'a',
        score: 0,
        level: 1,
        progress: 0,
      ),
    );
  }

  @override
  Future<Result<UserEntity>> signUp(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> signOut() {
    throw UnimplementedError();
  }

  @override
  Future<Result<UserEntity>> getCurrentUser() {
    throw UnimplementedError();
  }
}

void main() {
  test('SignInUser forwards params to repository', () async {
    final repo = _FakeAuthRepository();
    final useCase = SignInUser(repository: repo);

    final result = await useCase(
      const SignInParams(email: 'john@doe.dev', password: 'secret'),
    );

    expect(result.isSuccess, isTrue);
    expect(repo.lastEmail, 'john@doe.dev');
    expect(repo.lastPassword, 'secret');
  });
}
