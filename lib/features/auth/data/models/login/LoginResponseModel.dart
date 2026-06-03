import 'package:zikola_project/core/network/api_keys.dart';

class LoginResponseModel {
  final String accessToken;
  final String refreshToken;

  LoginResponseModel({required this.accessToken, required this.refreshToken});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json[ApiKeys.accessToken],
      refreshToken: json[ApiKeys.refreshToken],
    );
  }
}
