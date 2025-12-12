import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/token_storage.dart';

/// Configures Dio instance with base options and auth header.
class DioClient {
  DioClient() {
    final options = BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
    );
    _dio = Dio(options);

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }

    _tokenStorage = TokenStorage(const FlutterSecureStorage());
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _tokenStorage.readAccess();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await _tokenStorage.clear();
        }
        handler.next(error);
      },
    ));
  }

  late final Dio _dio;
  late final TokenStorage _tokenStorage;

  Dio get client => _dio;
  TokenStorage get tokenStorage => _tokenStorage;
}
