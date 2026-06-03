
import 'package:zikola_project/features/auth/data/models/register/register_request_model.dart';

import '../../data/models/login/LoginRequestModel.dart';
import '../../data/models/login/LoginResponseModel.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(
      LoginRequestModel request,
      );

  Future<void> register(
      RegisterRequestModel request
      );
}

// أي كلاس هيستدعي الكلاس دا لازم ينفذ الميثودز المتعرفة فيه