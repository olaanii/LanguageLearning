import 'package:flutter_test/flutter_test.dart';
import 'package:lingualearn/core/error/exceptions.dart';
import 'package:lingualearn/core/error/failures.dart';
import 'package:lingualearn/core/network/network_info.dart';
import 'package:lingualearn/features/auth/data/data.dart';

class _FakeNetworkInfo implements NetworkInfo {
  _FakeNetworkInfo(this.connected);
  final bool connected;

  @override
  Future<bool> get isConnected async => connected;
}

class _FakeRemoteDataSource implements AuthRemoteDataSource {
  _FakeRemoteDataSource({this.user, this.shouldThrow = false});

  final UserModel? user;
  final bool shouldThrow;

  @override
  Future<UserModel> signIn(String email, String password) async {
    if (shouldThrow) throw ServerException('boom');
    return user!;
  }

  @override
  Future<UserModel> signUp(String email, String password) async {
    if (shouldThrow) throw ServerException('boom');
    return user!;
  }

  @override
  Future<void> signOut() async {
    if (shouldThrow) throw ServerException('boom');
  }

  @override
  Future<UserModel> getCurrentUser() async {
    if (shouldThrow) throw ServerException('boom');
    return user!;
  }
}

void main() {
  const userModel = UserModel(
    id: 'u1',
    email: 'mail@test.dev',
    name: 'Test User',
    avatar: 'avatar',
    score: 10,
    level: 2,
    progress: 50,
  );

  final mapper = UserMapper();

  test('returns NetworkFailure when offline', () async {
    final repo = AuthRepositoryImpl(
      remoteDataSource: _FakeRemoteDataSource(user: userModel),
      networkInfo: _FakeNetworkInfo(false),
      mapper: mapper,
    );

    final result = await repo.signIn('a@b.com', 'pw');
    expect(result.isFailure, isTrue);
    expect(result.failure, isA<NetworkFailure>());
  });

  test('maps remote model to entity when online', () async {
    final repo = AuthRepositoryImpl(
      remoteDataSource: _FakeRemoteDataSource(user: userModel),
      networkInfo: _FakeNetworkInfo(true),
      mapper: mapper,
    );

    final result = await repo.signIn('a@b.com', 'pw');
    expect(result.isSuccess, isTrue);
    expect(result.data?.id, 'u1');
    expect(result.failure, isNull);
  });

  test('maps server exceptions to ServerFailure', () async {
    final repo = AuthRepositoryImpl(
      remoteDataSource: _FakeRemoteDataSource(shouldThrow: true),
      networkInfo: _FakeNetworkInfo(true),
      mapper: mapper,
    );

    final result = await repo.signIn('a@b.com', 'pw');
    expect(result.isFailure, isTrue);
    expect(result.failure, isA<ServerFailure>());
  });
}
