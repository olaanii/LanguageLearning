import '../../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';

class AuthState {
  final bool isLoading;
  final UserEntity? user;
  final Failure? error;

  const AuthState({this.isLoading = false, this.user, this.error});

  bool get isAuthenticated => user != null;
  bool get isSuccess => user != null && error == null;

  AuthState copyWith({
    bool? isLoading,
    UserEntity? user,
    Failure? error,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: clearUser ? null : (user ?? this.user),
      error: clearError ? null : (error ?? this.error),
    );
  }
}
