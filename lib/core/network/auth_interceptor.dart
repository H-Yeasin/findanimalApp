import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorageService, {this.onUnauthorized});

  final SecureStorageService _secureStorageService;
  final VoidCallback? onUnauthorized;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorageService.readAccessToken();
    
    if (kDebugMode) {
      print('DEBUG: AuthInterceptor - Token found: ${token != null && token.isNotEmpty}');
      if (token != null && token.isNotEmpty) {
        print('DEBUG: AuthInterceptor - Adding Token to: ${options.uri}');
      }
    }

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      final path = err.requestOptions.path;
      final hasToken = err.requestOptions.headers.containsKey('Authorization');

      // Only trigger logout if we sent a token and it was rejected.
      // This prevents background 401s on public endpoints (or before login is fully processed)
      // from kicking the user out.
      if (hasToken &&
          !path.contains('/auth/logout') &&
          !path.contains('/auth/generate-access-token')) {
        if (kDebugMode) {
          print(
            'DEBUG: AuthInterceptor - 401 Unauthorized (with token) detected on $path. Triggering logout.',
          );
        }
        onUnauthorized?.call();
      }
    }
    handler.next(err);
  }
}
