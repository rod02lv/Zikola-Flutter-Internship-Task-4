import 'package:zikola_project/core/network/api_endpoints.dart';
import 'package:zikola_project/features/auth/data/models/login/LoginRequestModel.dart';

import 'package:zikola_project/features/auth/data/models/login/LoginResponseModel.dart';

import '../../../../core/network/api_consumer.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/register/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiConsumer apiConsumer;
  final SecureStorageService secureStorage;

  AuthRepositoryImpl({required this.apiConsumer, required this.secureStorage});

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await apiConsumer.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );
    final loginResponse = LoginResponseModel.fromJson(response);

    await secureStorage.saveTokens(
      accessToken: loginResponse.accessToken,
      refreshToken: loginResponse.refreshToken,
    );
    return loginResponse; //object of login response model
  }

  Future<void> register(
      RegisterRequestModel request
      )async{

    await apiConsumer.post(ApiEndpoints.users,data: request.toJson());
  }
}
