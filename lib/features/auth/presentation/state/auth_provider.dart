import 'package:flutter/foundation.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../domain/domain.dart';
import 'auth_state.dart';

class AuthProvider extends ChangeNotifier {
  final SignInUser signInUser;
  final SignUpUser signUpUser;
  final SignOutUser signOutUser;
  final GetCurrentUser getCurrentUser;

  AuthState _state = const AuthState();
  AuthState get state => _state;

  // Backwards compatibility for legacy screens
  UserEntity? get user => _state.user;
  bool get isAuthenticated => _state.isAuthenticated;
  bool get isLoading => _state.isLoading;

  AuthProvider({
    required this.signInUser,
    required this.signUpUser,
    required this.signOutUser,
    required this.getCurrentUser,
  }) {
    _init();
  }

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> _init() async {
    _setState(_state.copyWith(isLoading: true, clearError: true));
    final result = await getCurrentUser(const NoParams());

    if (result.isSuccess) {
      _setState(_state.copyWith(isLoading: false, user: result.data));
    } else {
      _setState(_state.copyWith(isLoading: false, error: result.failure));
    }
  }

  Future<void> signIn(String email, String password) async {
    _setState(_state.copyWith(isLoading: true, clearError: true));
    final result = await signInUser(
      SignInParams(email: email, password: password),
    );

    if (result.isSuccess) {
      _setState(_state.copyWith(isLoading: false, user: result.data));
    } else {
      _setState(_state.copyWith(isLoading: false, error: result.failure));
    }
  }

  Future<void> signUp(String email, String password) async {
    _setState(_state.copyWith(isLoading: true, clearError: true));
    final result = await signUpUser(
      SignUpParams(email: email, password: password),
    );

    if (result.isSuccess) {
      _setState(_state.copyWith(isLoading: false, user: result.data));
    } else {
      _setState(_state.copyWith(isLoading: false, error: result.failure));
    }
  }

  Future<void> signOut() async {
    _setState(_state.copyWith(isLoading: true, clearError: true));
    final result = await signOutUser(const NoParams());

    if (result.isSuccess) {
      _setState(_state.copyWith(isLoading: false, clearUser: true));
    } else {
      _setState(_state.copyWith(isLoading: false, error: result.failure));
    }
  }

  void clearError() {
    _setState(_state.copyWith(clearError: true));
  }
}
