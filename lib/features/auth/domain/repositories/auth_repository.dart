
import '../../data/models/LoginRequestModel.dart';
import '../../data/models/LoginResponseModel.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(
      LoginRequestModel request,
      );
}

// أي كلاس هيستدعي الكلاس دا لازم ينفذ الميثودز المتعرفة فيه