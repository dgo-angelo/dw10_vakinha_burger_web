import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../core/exceptions/unauthorized_exception.dart';
import '../../services/auth/login_service.dart';

part 'login_controller.g.dart';

enum LoginStateStatus {
  initial,
  loading,
  success,
  error,
}

class LoginController = LoginControllerBase with _$LoginController;

abstract class LoginControllerBase with Store {
  final LoginService _loginService;

  @readonly
  var _loginStatus = LoginStateStatus.initial;

  @readonly
  String? _errorMessage;

  LoginControllerBase({
    required LoginService loginService,
  }) : _loginService = loginService;

  @action
  Future<void> login(String email, String password) async {
    try {
      _loginStatus = LoginStateStatus.loading;
      await _loginService.execute(email, password);
      _loginStatus = LoginStateStatus.success;
    } on UnauthorizedException catch (e, s) {
      _errorMessage = 'Login ou senha inválidos';
      _loginStatus = LoginStateStatus.error;
      log('Falha ao realizar Login', error: e, stackTrace: s);
    } catch (e, s) {
      log('Falha ao realizar Login', error: e, stackTrace: s);
      _errorMessage = 'Tente novamente mais tarde';
      _loginStatus = LoginStateStatus.error;
    }
  }
}
