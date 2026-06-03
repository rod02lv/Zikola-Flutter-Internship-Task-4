import '../../../../../core/network/api_keys.dart';

class LoginRequestModel {
  String email;
  String password;
  LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {ApiKeys.email: email, ApiKeys.password: password};
  }
}
