import 'package:dio/dio.dart';

import '../../core/constants/endpoints.dart';
import '../../core/utils/token_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../api/dio_client.dart';
import '../models/user_model.dart';

class AuthService implements AuthRepository {
  AuthService(this._client);

  final DioClient _client;

  Dio get _dio => _client.client;
  TokenStorage get _storage => _client.tokenStorage;

  @override
  Future<String> login({required String email, required String password}) async {
    try {
      final res = await _dio.post(
        Endpoints.login,
        queryParameters: {'email': email, 'password': password},
      );
      final data = res.data as Map<String, dynamic>? ?? {};
      final token = data['accessToken'] ?? data['token'] ?? data['access_token'] ?? data['jwt'];
      if (token is! String) {
        throw Exception('Unable to parse access token');
      }
      await _storage.saveTokens(access: token, refresh: data['refreshToken'] as String?);
      return token;
    } on DioException catch (e) {
      // Handle Dio errors (network, 4xx, 5xx)
      final errorMessage = e.response?.data is String 
          ? e.response!.data 
          : e.response?.data?['message'] ?? e.message ?? 'Login failed';
      throw Exception(errorMessage);
    }
  }

  @override
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        Endpoints.register,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        },
      );
      // Backend returns a String message, check if it's an error
      if (res.statusCode != null && res.statusCode! >= 400) {
        final message = res.data is String ? res.data : 'Registration failed';
        throw Exception(message);
      }
    } on DioException catch (e) {
      // Handle Dio errors (network, 4xx, 5xx)
      final errorMessage = e.response?.data is String 
          ? e.response!.data 
          : e.response?.data?['message'] ?? e.message ?? 'Registration failed';
      throw Exception(errorMessage);
    }
  }

  @override
  Future<UserEntity?> me() async {
    final res = await _dio.get(Endpoints.me);
    if (res.data == null) return null;
    final model = UserModel.fromJson(res.data as Map<String, dynamic>);
    return UserEntity.fromModel(model);
  }

  @override
  Future<void> logout() async {
    await _storage.clear();
  }
}
