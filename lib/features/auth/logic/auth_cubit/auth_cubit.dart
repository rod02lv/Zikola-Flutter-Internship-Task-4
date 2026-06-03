import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zikola_project/features/auth/data/models/register/register_request_model.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../data/models/login/LoginRequestModel.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());

    try {
      final request = LoginRequestModel(email: email, password: password);
      await authRepository.login(request);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());

    try {
      final request = RegisterRequestModel(
        name: name,
        email: email,
        password: password,
        avatar: "assets/images/avatar1.jpg",
      );
      await authRepository.register(request);
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}
