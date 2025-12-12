import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/token_storage.dart';
import '../../data/api/dio_client.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../routes/app_router.dart';
import 'app_providers.dart';

class AuthState {
  const AuthState({this.user, this.isLoading = false, this.error});

  final UserEntity? user;
  final bool isLoading;
  final String? error;

  bool get isAuthenticated => user != null;

  AuthState copyWith({UserEntity? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repo, this._dioClient) : super(const AuthState());

  final AuthRepository _repo;
  final DioClient _dioClient;

  TokenStorage get _storage => _dioClient.tokenStorage;

  Future<void> loadSession() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await _storage.readAccess();
      if (token == null) {
        state = const AuthState();
        return;
      }
      final user = await _repo.me();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.login(email: email, password: password);
      final user = await _repo.me();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      await login(email, password);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout(WidgetRef ref) async {
    await _repo.logout();
    state = const AuthState();
    ref.read(goRouterProvider).go('/login');
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authServiceProvider);
  final client = ref.watch(dioClientProvider);
  final notifier = AuthNotifier(repo, client);
  notifier.loadSession();
  return notifier;
});
