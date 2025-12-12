import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

/// Handles persistence of auth tokens.
class TokenStorage {
  const TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  Future<void> saveTokens({required String access, String? refresh}) async {
    await _storage.write(key: AppConstants.secureStorageTokenKey, value: access);
    if (refresh != null) {
      await _storage.write(
        key: AppConstants.secureStorageRefreshTokenKey,
        value: refresh,
      );
    }
  }

  Future<String?> readAccess() => _storage.read(key: AppConstants.secureStorageTokenKey);

  Future<void> clear() async {
    await _storage.delete(key: AppConstants.secureStorageTokenKey);
    await _storage.delete(key: AppConstants.secureStorageRefreshTokenKey);
  }
}
