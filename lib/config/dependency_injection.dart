import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:zikola_project/core/network/api_endpoints.dart';

import '../core/network/api_consumer.dart';
import '../core/network/dio_consumer.dart';
import '../core/storage/secure_storage_service.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/logic/auth_cubit/auth_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {

  /// Dio
  getIt.registerLazySingleton<Dio>(
        () => Dio(    BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
        ),),
  );

  /// ApiConsumer
  getIt.registerLazySingleton<ApiConsumer>(
        () =>
        DioConsumer(
          getIt<Dio>(),
        ),
  );

  /// Secure Storage
  getIt.registerLazySingleton<SecureStorageService>(
        () => SecureStorageService(),
  );

  /// Auth Repository
  getIt.registerLazySingleton<AuthRepository>(
        () =>
        AuthRepositoryImpl(
          apiConsumer: getIt<ApiConsumer>(),
          secureStorage: getIt<SecureStorageService>(),
        ),
  );
  getIt.registerFactory(
        () => AuthCubit(
      getIt<AuthRepository>(),
    ),
  );
}