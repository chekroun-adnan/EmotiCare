import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConstants {
  AppConstants._();

  // Platform-aware API base URL
  static String get apiBaseUrl {
    if (kIsWeb) {
      // For web, use localhost
      return 'http://localhost:8084';
    } else if (Platform.isAndroid) {
      // For Android emulator, use 10.0.2.2 to access host machine
      // For physical device, replace with your machine's IP address
      return 'http://10.0.2.2:8084';
    } else {
      // For iOS simulator and other platforms, use localhost
      return 'http://localhost:8084';
    }
  }

  static const secureStorageTokenKey = 'auth_token';
  static const secureStorageRefreshTokenKey = 'refresh_token';
}
