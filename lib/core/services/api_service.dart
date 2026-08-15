import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: AppConstants.apiTimeout,
    receiveTimeout: AppConstants.apiTimeout,
    sendTimeout: AppConstants.apiTimeout,
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  ));

  dio.interceptors.add(AuthInterceptor(dio, ref));
  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      logPrint: (object) => debugPrint('[DIO] $object'),
    ));
  }

  return dio;
});

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final Ref _ref;
  bool _isRefreshing = false;

  AuthInterceptor(this._dio, this._ref);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final storage = _ref.read(secureStorageProvider);
    String? token;
    try {
      token = await storage.read(key: AppConstants.accessTokenKey);
    } catch (_) {}
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final path = err.requestOptions.path;
    final isAuthEndpoint = path.contains('/auth/logout') ||
        path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh') ||
        path.contains('/auth/verify-otp') ||
        path.contains('/auth/forgot-password') ||
        path.contains('/auth/reset-password');

    if (err.response?.statusCode == 401 && !_isRefreshing && !isAuthEndpoint) {
      _isRefreshing = true;
      try {
        final storage = _ref.read(secureStorageProvider);
        final refreshToken =
            await storage.read(key: AppConstants.refreshTokenKey);

        if (refreshToken == null) {
          _handleAuthFailure();
          handler.next(err);
          return;
        }

        final response = await _dio
            .post('/auth/refresh', data: {'refreshToken': refreshToken});
        final data = response.data['data'] as Map<String, dynamic>?;
        final newToken = data?['accessToken'] ?? data?['token'];
        final newRefreshToken = data?['refreshToken'];

        if (newToken != null) {
          await storage.write(
              key: AppConstants.accessTokenKey, value: newToken.toString());
        }
        if (newRefreshToken != null && newRefreshToken.toString().isNotEmpty) {
          await storage.write(
              key: AppConstants.refreshTokenKey,
              value: newRefreshToken.toString());
        }

        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newToken';
        final retryResponse = await _dio.fetch(opts);
        handler.resolve(retryResponse);
      } catch (refreshErr) {
        String? reasonMsg;
        if (refreshErr is DioException) {
          final resData = refreshErr.response?.data;
          final code = resData is Map ? resData['code']?.toString() : null;
          final upperCode = code?.toUpperCase() ?? '';
          if (upperCode == 'SESSION_REVOKED_SECURITY' ||
              upperCode == 'SESSION_REVOKED' ||
              upperCode == 'REFRESH_TOKEN_REUSED' ||
              upperCode == 'INVALID_REFRESH_TOKEN') {
            reasonMsg =
                'নিরাপত্তার কারণে আপনাকে লগ আউট করা হয়েছে, দয়া করে আবার লগইন করুন';
          }
        }
        _handleAuthFailure(reasonMessage: reasonMsg);
        handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      handler.next(err);
    }
  }

  void _handleAuthFailure({String? reasonMessage}) async {
    try {
      final storage = _ref.read(secureStorageProvider);
      await storage.deleteAll();
    } catch (_) {}
    try {
      _ref
          .read(authProvider.notifier)
          .clearLocalSessionOnly(reasonMessage: reasonMessage);
    } catch (_) {}
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;
  final dynamic rawData;

  const ApiException({
    required this.message,
    this.statusCode,
    this.code,
    this.rawData,
  });

  bool get isEmailVerificationRequired {
    if (statusCode != 403) return false;
    final c = code?.toUpperCase() ?? '';
    final msg = message.toLowerCase();
    return c == 'EMAIL_VERIFICATION_REQUIRED' ||
        c == 'EMAIL_NOT_VERIFIED' ||
        c == 'VERIFY_EMAIL_REQUIRED' ||
        msg.contains('email verification') ||
        msg.contains('verify email') ||
        msg.contains('ইমেইল যাচাই');
  }

  int? get attemptsRemaining {
    if (rawData is Map<String, dynamic>) {
      final val = rawData['attemptsRemaining'] ??
          rawData['remainingAttempts'] ??
          rawData['attemptsLeft'];
      if (val is num) return val.toInt();
    }
    return null;
  }

  int? get cooldownSeconds {
    if (rawData is Map<String, dynamic>) {
      final val = rawData['cooldownSeconds'] ?? rawData['retryAfter'];
      if (val is num) return val.toInt();
    }
    return null;
  }

  @override
  String toString() => message;

  factory ApiException.fromDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    String message = 'Something went wrong. Please try again.';
    String? code;
    dynamic rawData;

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      message = 'Connection timed out. Please check your internet.';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'No internet connection.';
    } else if (e.response?.data != null) {
      rawData = e.response?.data;
      if (rawData is Map<String, dynamic>) {
        message = rawData['message'] ?? message;
        code = rawData['code']?.toString() ?? rawData['error']?.toString();
      } else if (rawData is String) {
        message = rawData;
      }

      final upperCode = code?.toUpperCase() ?? '';
      if (statusCode == 429 ||
          upperCode == 'TOO_MANY_ATTEMPTS' ||
          upperCode == 'ACCOUNT_LOCKED' ||
          upperCode == 'ACCOUNT_TEMPORARILY_LOCKED' ||
          upperCode == 'TOO_MANY_REQUESTS') {
        int? cooldown;
        if (rawData is Map<String, dynamic>) {
          final val = rawData['cooldownSeconds'] ?? rawData['retryAfter'];
          if (val is num) cooldown = val.toInt();
        }
        if (cooldown != null && cooldown > 0) {
          message = 'অনেকবার ভুল চেষ্টা করা হয়েছে। $cooldown সেকেন্ড পর আবার চেষ্টা করুন।';
        } else {
          message = 'অনেকবার ভুল চেষ্টা করা হয়েছে, কিছুক্ষণ পর আবার চেষ্টা করুন।';
        }
      }
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      code: code,
      rawData: rawData,
    );
  }
}

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<T> get<T>(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParams);
      return response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<T> post<T>(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<T> patch<T>(String path, {dynamic data}) async {
    try {
      final response = await _dio.patch(path, data: data);
      return response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<T> delete<T>(String path) async {
    try {
      final response = await _dio.delete(path);
      return response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(ref.read(dioProvider));
});
