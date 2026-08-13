import 'package:dio/dio.dart';
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
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    error: true,
    logPrint: (object) => print('[DIO] $object'),
  ));

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
    if (err.response?.statusCode == 401 && !_isRefreshing) {
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
        final newToken = response.data['data']['accessToken'];
        await storage.write(key: AppConstants.accessTokenKey, value: newToken);

        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newToken';
        final retryResponse = await _dio.fetch(opts);
        handler.resolve(retryResponse);
      } catch (_) {
        _handleAuthFailure();
        handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      handler.next(err);
    }
  }

  void _handleAuthFailure() async {
    try {
      final storage = _ref.read(secureStorageProvider);
      await storage.deleteAll();
    } catch (_) {}
    // AuthService will handle navigation
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  // Make this a const constructor
  const ApiException({required this.message, this.statusCode});

  @override
  String toString() => message;

  // This factory method cannot be const, but that's fine
  factory ApiException.fromDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    String message = 'Something went wrong. Please try again.';

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      message = 'Connection timed out. Please check your internet.';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'No internet connection.';
    } else if (e.response?.data != null) {
      message = e.response?.data['message'] ?? message;
    }

    return ApiException(message: message, statusCode: statusCode);
  }
}

// class ApiException implements Exception {
//   final String message;
//   final int? statusCode;

//   ApiException({required this.message, this.statusCode});

//   @override
//   String toString() => message;

//   factory ApiException.fromDioException(DioException e) {
//     final statusCode = e.response?.statusCode;
//     String message = 'Something went wrong. Please try again.';

//     if (e.type == DioExceptionType.connectionTimeout ||
//         e.type == DioExceptionType.receiveTimeout ||
//         e.type == DioExceptionType.sendTimeout) {
//       message = 'Connection timed out. Please check your internet.';
//     } else if (e.type == DioExceptionType.connectionError) {
//       message = 'No internet connection.';
//     } else if (e.response?.data != null) {
//       message = e.response?.data['message'] ?? message;
//     }

//     return ApiException(message: message, statusCode: statusCode);
//   }
// }

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
