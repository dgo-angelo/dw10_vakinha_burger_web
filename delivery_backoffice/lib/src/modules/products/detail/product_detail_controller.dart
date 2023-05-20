import 'dart:developer';
import 'dart:typed_data';

import 'package:mobx/mobx.dart';

import '../../../models/product_model.dart';
import '../../../repositories/products/products_repository.dart';

part 'product_detail_controller.g.dart';

enum ProductDetailStateStatus {
  initial,
  loading,
  loaded,
  saved,
  error,
  errorLoadingProduct,
  deleted,
  uploaded,
}

class ProductDetailController = ProductDetailControllerBase
    with _$ProductDetailController;

abstract class ProductDetailControllerBase with Store {
  final ProductsRepository _productsRepository;

  @readonly
  var _status = ProductDetailStateStatus.initial;

  @readonly
  String? _errorMessage;

  @readonly
  String? _imagePath;

  @readonly
  ProductModel? _productModel;

  ProductDetailControllerBase({
    required ProductsRepository productsRepository,
  }) : _productsRepository = productsRepository;

  @action
  Future<void> uploadProductImage(Uint8List file, String fileName) async {
    try {
      _status = ProductDetailStateStatus.loading;
      _imagePath = await _productsRepository.uploadProductImage(file, fileName);
      _status = ProductDetailStateStatus.uploaded;
    } catch (e, s) {
      log('Falha ao enviar imagem', error: e, stackTrace: s);
      _status = ProductDetailStateStatus.error;
    }
  }

  @action
  Future<void> save(String name, double price, String description) async {
    try {
      _status = ProductDetailStateStatus.loading;
      final productModel = ProductModel(
        id: _productModel?.id,
        name: name,
        description: description,
        price: price,
        enabled: _productModel?.enabled ?? true,
        image: _imagePath!,
      );

      await _productsRepository.saveProduct(productModel);
      _status = ProductDetailStateStatus.saved;
    } catch (e, s) {
      const message = 'Erro ao salvar produto';
      log(message, error: e, stackTrace: s);
      _status = ProductDetailStateStatus.error;
      _errorMessage = message;
    }
  }

  Future<void> loadProduct(int? id) async {
    try {
      _status = ProductDetailStateStatus.loading;
      _productModel = null;
      _imagePath = null;
      if (id != null) {
        _productModel = await _productsRepository.getProduct(id);
        _imagePath = _productModel!.image;
      }
      _status = ProductDetailStateStatus.loaded;
    } catch (e, s) {
      const message = 'Erro ao carregar o produto';
      log(message, error: e, stackTrace: s);
      _errorMessage = message;
      _status = ProductDetailStateStatus.errorLoadingProduct;
    }
  }

  Future<void> deleteProduct() async {
    try {
      _status = ProductDetailStateStatus.loading;
      if (_productModel != null && _productModel!.id != null) {
        await _productsRepository.deleteProduct(_productModel!.id!);
        _status = ProductDetailStateStatus.deleted;
      } else {
        Future.delayed(Duration.zero);
        _status = ProductDetailStateStatus.error;
        _errorMessage =
            'Produto não cadastrado, não é permitido deletar o produto.';
      }
    } catch (e, s) {
      const message = 'Erro ao deletar produto';
      log(message, error: e, stackTrace: s);
      _errorMessage = message;
      _status = ProductDetailStateStatus.error;
    }
  }
}
