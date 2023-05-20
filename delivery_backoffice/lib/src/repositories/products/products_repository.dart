import 'dart:typed_data';

import '../../models/product_model.dart';

abstract class ProductsRepository {
  Future<List<ProductModel>> findAll(String? name);
  Future<ProductModel> getProduct(int id);
  Future<void> saveProduct(ProductModel productModel);
  Future<String> uploadProductImage(Uint8List file, String filenName);
  Future<void> deleteProduct(int id);
}
