import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../models/product_model.dart';
import '../../../repositories/products/products_repository.dart';

part 'products_controller.g.dart';

enum ProductsStateStatus { initial, loading, loaded, error, addOrUpdateProduct }

class ProductsController = ProductsControllerBase with _$ProductsController;

abstract class ProductsControllerBase with Store {
  final ProductsRepository _productsRepository;
  ProductsControllerBase({
    required ProductsRepository productsRepository,
  }) : _productsRepository = productsRepository;

  @readonly
  var _status = ProductsStateStatus.initial;

  @readonly
  var _products = <ProductModel>[];

  @readonly
  String? _errorMessage;

  @readonly
  String? _filterName;

  @readonly
  ProductModel? _productSelected;

  @action
  Future<void> loadProducts() async {
    try {
      _status = ProductsStateStatus.loading;
      _products = await _productsRepository.findAll(_filterName);
      _status = ProductsStateStatus.loaded;
    } catch (e, s) {
      const message = 'Erro ao carregar produtos';
      log(message, error: e, stackTrace: s);
      _status = ProductsStateStatus.error;
      _errorMessage = message;
    }
  }

  @action
  Future<void> filterByName(String name) async {
    _filterName = name;
    await loadProducts();
  }

  @action
  Future<void> addProduct() async {
    _status = ProductsStateStatus.loading;
    Future.delayed(Duration.zero);
    _productSelected = null;
    _status = ProductsStateStatus.addOrUpdateProduct;
  }

  @action
  Future<void> editProduct(ProductModel productModel) async {
    _status = ProductsStateStatus.loading;
    Future.delayed(Duration.zero);
    _productSelected = productModel;
    _status = ProductsStateStatus.addOrUpdateProduct;
  }
}
