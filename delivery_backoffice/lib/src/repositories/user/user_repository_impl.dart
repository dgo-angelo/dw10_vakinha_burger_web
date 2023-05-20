import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/exceptions/repository_exception.dart';
import '../../core/rest_client/custom_dio.dart';
import '../../models/user_model.dart';
import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final CustomDio _dio;
  UserRepositoryImpl({
    required CustomDio dio,
  }) : _dio = dio;

  @override
  Future<UserModel> getById(int id) async {
    try {
      final userResponse = await _dio.auth().get('/users/$id');
      return UserModel.fromMap(userResponse.data);
    } on DioError catch (e, s) {
      const message = 'Falha ao buscar usuário';
      log(message, error: e, stackTrace: s);
      throw RepositoryException(message: message);
    }
  }
}
