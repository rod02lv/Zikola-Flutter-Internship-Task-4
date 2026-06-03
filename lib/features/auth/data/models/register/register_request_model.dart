import '../../../../../core/network/api_keys.dart';

class RegisterRequestModel {

  final String name;
  final String email;
  final String password;
  final String avatar;

  RegisterRequestModel(
      {required this.name, required this.email, required this.password, required this.avatar});


  Map<String, dynamic> toJson() {
    return {
      ApiKeys.name: name,
      ApiKeys.email: email,
      ApiKeys.password: password,
      ApiKeys.avatar : avatar,
    };
  }
}