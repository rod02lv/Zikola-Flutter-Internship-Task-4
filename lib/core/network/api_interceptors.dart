import 'dart:async';

import 'package:dio/dio.dart';
import 'package:zikola_project/core/storage/storage_keys.dart';

import '../auth/auth_event_bus.dart';
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
  void onRequest(RequestOptions options,
      RequestInterceptorHandler handler,) async {
    final accessToken = await secureStorage.getAccessToken();
    if (accessToken != null) {
      options.headers["Authorization"] = 'Bearer $accessToken';
    }

    handler.next(options); //خلصت تعديلات -> كمل الريكويست  =
  }


  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // بمنع إن يحصل infinite loop
    if (err.requestOptions.path ==
        ApiEndpoints.refreshToken) {
      return handler.next(err);
    }


    // handle other errors
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // what happens to the waiting requests
    if(_isRefreshing){
      try{
        await _refreshCompleter?.future; // pause other refresh requests if one is founded

        final accessToken = await secureStorage.getAccessToken();

        if (accessToken == null) {
          return handler.next(err);
        }

        // add new token to header
        err.requestOptions.headers['Authorization'] =
        'Bearer $accessToken';

        // retry the requests
        final retryResponse =
        await dio.fetch(err.requestOptions);

        return handler.resolve(retryResponse);


      }catch(_){
        return handler.next(err);
      }
    }

    //  هبدأ هنا أعمل ريفريش وأجيب توكنز جديدة
    _isRefreshing = true;

    _refreshCompleter = Completer<void>();

    final refreshToken =
    await secureStorage.getRefreshToken();


    if (refreshToken == null) {
      await _performLogout();

      _refreshCompleter?.complete();

      return handler.next(err);
    }

    try {
      final response = await dio.post(ApiEndpoints.refreshToken,
          data: { StorageKeys.reqRefreshTokenKey: refreshToken});
      final newAccessToken =
      response.data[StorageKeys.accessTokenKey];

      final newRefreshToken =
      response.data[
      StorageKeys.resRefreshTokenKey];

      await secureStorage.saveTokens(
          accessToken: newAccessToken, refreshToken: newRefreshToken);

      _refreshCompleter?.complete();

      err.requestOptions.headers['Authorization'] =
      'Bearer $newAccessToken';

      final retryResponse =
      await dio.fetch(err.requestOptions);

      return handler.resolve(retryResponse);
    }catch(e){
      await _performLogout();
      _refreshCompleter?.completeError(e);

      return handler.next(err);
    }
    finally {
      _isRefreshing = false;
    }


  }

  Future<void> _performLogout() async {
    await secureStorage.clearTokens();

    AuthEventBus.instance.addEvent(AuthEvent.logout);
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
