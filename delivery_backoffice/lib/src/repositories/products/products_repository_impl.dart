import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../core/exceptions/repository_exception.dart';
import '../../core/rest_client/custom_dio.dart';
import '../../models/product_model.dart';
import './products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final CustomDio _dio;
  ProductsRepositoryImpl({
    required CustomDio dio,
  }) : _dio = dio;
  @override
  Future<List<ProductModel>> findAll(String? name) async {
    try {
      final productsResult = await _dio.auth().get(
        '/products',
        queryParameters: {
          if (name != null) 'name': name,
          'enabled': true,
        },
      );

      return productsResult.data
          .map<ProductModel>(
            (p) => ProductModel.fromMap(p),
          )
          .toList();
    } on DioError catch (e, s) {
      const message = 'Falha ao carregar produtos';
      log(message, error: e, stackTrace: s);
      throw RepositoryException(message: message);
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await _dio.auth().put('/products/$id', data: {'enabled': false});
    } on DioError catch (e, s) {
      const message = 'Falha ao deletar produto';
      log(message, error: e, stackTrace: s);
      throw RepositoryException(message: message);
    }
  }

  @override
  Future<ProductModel> getProduct(int id) async {
    try {
      final product = await _dio.auth().get('/products/$id');

      return ProductModel.fromMap(product.data);
    } on DioError catch (e, s) {
      const message = 'Falha ao retornar produto';
      log(message, error: e, stackTrace: s);
      throw RepositoryException(message: message);
    }
  }

  @override
  Future<void> saveProduct(ProductModel productModel) async {
    try {
      final client = _dio.auth();
      final data = productModel.toMap();

      if (productModel.id != null) {
        await client.put(
          '/products/${productModel.id}',
          data: data,
        );
      } else {
        await client.post(
          '/products',
          data: data,
        );
      }
    } on DioError catch (e, s) {
      const message = 'Falha ao salvar produto';
      log(message, error: e, stackTrace: s);
      throw RepositoryException(message: message);
    }
  }

  @override
  Future<String> uploadProductImage(Uint8List file, String filenName) async {
    try {
      final formData = FormData.fromMap(
        {
          'file': MultipartFile.fromBytes(
            file,
            filename: filenName,
          ),
        },
      );
      final response = await _dio.auth().post('/uploads', data: formData);
      return response.data['url'];
    } on DioError catch (e, s) {
      const message = 'Falha ao efetuar upload do arquivo';
      log(message, error: e, stackTrace: s);
      throw RepositoryException(message: message);
    }
  }
}
