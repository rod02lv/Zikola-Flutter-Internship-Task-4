import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zikola_project/core/storage/storage_keys.dart';

class SecureStorageService {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  // repository          هيستخدمها يخزن التوكن
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await secureStorage.write(
      key: StorageKeys.accessTokenKey,
      value: accessToken,
    );
    await secureStorage.write(
      key: StorageKeys.resRefreshTokenKey,
      value: refreshToken,
    );
  }

  // Interceptor يستخدمهم ف الريكوستس والإيرورز
  Future<String?> getAccessToken() async {
    return await secureStorage.read(
      key: StorageKeys.accessTokenKey,);
  }

  Future<String?> getRefreshToken() async {
    return await secureStorage.read(
      key: StorageKeys.resRefreshTokenKey,);
  }

  // in case : Logout
  // Refresh Failed
  Future<void> clearTokens() async{
    await secureStorage.delete(key:  StorageKeys.accessTokenKey);
    await secureStorage.delete(key:  StorageKeys.resRefreshTokenKey);

  }
}