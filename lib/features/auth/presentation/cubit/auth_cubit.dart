import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _login;
  final RegisterUseCase _register;
  AuthCubit(this._login, this._register) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await _login(email, password);
    result.fold(
      (failure) => emit(AuthError(failure.failureMessage)),
      (_) => emit(AuthSuccess()),
    );
  }

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    final result = await _register(name, email, password);
    result.fold(
      (failure) => emit(AuthError(failure.failureMessage)),
      (_) => emit(AuthSuccess()),
    );
  }
}