import 'dart:async';

import 'package:dio/dio.dart';
import 'package:zikola_project/core/storage/storage_keys.dart';

import '../storage/secure_storage_service.dart';
import 'api_endpoints.dart';

class ApiInterceptors extends Interceptor {
  final Dio dio; // علشان نعرف نعيد تنفيذ الطلب القديم
  final SecureStorageService
  secureStorage; //علشان نجيب التوكنات المتخزنة أو نخزن المتحدثة

  // Race Condition
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  ApiInterceptors({required this.dio, required this.secureStorage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await secureStorage.getAccessToken();
    if (accessToken != null) {
      options.headers["Authorization"] = 'Bearer $accessToken';
    }

    handler.next(options); //خلصت تعديلات -> كمل الريكويست  =
  }






  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {

    if (err.response?.statusCode == 401) {
      final refreshToken = await secureStorage.getRefreshToken();

      if (refreshToken == null) {
        await secureStorage.clearTokens();

        return handler.next(err);
      }

      try {
        final response = await dio.post(
          ApiEndpoints.refreshToken,
          data: {StorageKeys.reqRefreshTokenKey: refreshToken},
        );

        final accessToken = response.data[StorageKeys.accessTokenKey];

        final newRefreshToken = response.data[StorageKeys.resRefreshTokenKey];

        await secureStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: newRefreshToken,
        );

        err.requestOptions.headers['Authorization'] = 'Bearer $accessToken';

        final retryResponse = await dio.fetch(err.requestOptions);

        return handler.resolve(retryResponse);
      } catch (e) {
        await secureStorage.clearTokens();

        return handler.next(err);
      }
    }
    return handler.next(err);

  }
}

/*
 Interceptor مسؤول عن حاجتين
    1.
    قبل أي Request
    ضيف Authorization Header

    2.
    لو حصل 401
    اعمل Refresh

 */
/*

    1. Attach Authorization Header
    2. Refresh Token
    3. Retry Request
    4. Logout

 */
