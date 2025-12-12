import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<String> login({required String email, required String password});
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });
  Future<UserEntity?> me();
  Future<void> logout();
}
