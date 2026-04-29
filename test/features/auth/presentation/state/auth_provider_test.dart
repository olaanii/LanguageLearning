import 'package:flutter_test/flutter_test.dart';
import 'package:lingualearn/core/error/failures.dart';
import 'package:lingualearn/core/utils/result.dart';
import 'package:lingualearn/features/auth/domain/domain.dart';
import 'package:lingualearn/features/auth/presentation/state/auth_provider.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    required this.signInResult,
    required this.signUpResult,
    required this.signOutResult,
    required this.currentUserResult,
  });

  Result<UserEntity> signInResult;
  Result<UserEntity> signUpResult;
  Result<void> signOutResult;
  Result<UserEntity> currentUserResult;

  @override
  Future<Result<UserEntity>> signIn(String email, String password) async {
    return signInResult;
  }

  @override
  Future<Result<UserEntity>> signUp(String email, String password) async {
    return signUpResult;
  }

  @override
  Future<Result<void>> signOut() async {
    return signOutResult;
  }

  @override
  Future<Result<UserEntity>> getCurrentUser() async {
    return currentUserResult;
  }
}

void main() {
  const user = UserEntity(
    id: 'u1',
    email: 'mail@test.dev',
    name: 'Test User',
    avatar: 'avatar',
    score: 0,
    level: 1,
    progress: 0,
  );

  test('initializes with current user when available', () async {
    final repo = _FakeAuthRepository(
      signInResult: Result.success(user),
      signUpResult: Result.success(user),
      signOutResult: Result.success(null),
      currentUserResult: Result.success(user),
    );

    final provider = AuthProvider(
      signInUser: SignInUser(repository: repo),
      signUpUser: SignUpUser(repository: repo),
      signOutUser: SignOutUser(repository: repo),
      getCurrentUser: GetCurrentUser(repository: repo),
    );

    await Future<void>.delayed(Duration.zero);

    expect(provider.state.user?.id, 'u1');
    expect(provider.state.error, isNull);
  });

  test('exposes failure after sign in error', () async {
    final repo = _FakeAuthRepository(
      signInResult: Result.failure(const ServerFailure('Invalid credentials')),
      signUpResult: Result.success(user),
      signOutResult: Result.success(null),
      currentUserResult: Result.failure(const ServerFailure('No current user')),
    );

    final provider = AuthProvider(
      signInUser: SignInUser(repository: repo),
      signUpUser: SignUpUser(repository: repo),
      signOutUser: SignOutUser(repository: repo),
      getCurrentUser: GetCurrentUser(repository: repo),
    );

    await provider.signIn('a@b.com', 'bad');

    expect(provider.state.isLoading, isFalse);
    expect(provider.state.error, isA<ServerFailure>());
    expect(provider.state.user, isNull);
  });
}
