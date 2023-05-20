import 'dart:convert';

class ProductModel {
  final int? id;
  final String name;
  final String description;
  final double price;
  final bool enabled;
  final String image;
  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.enabled,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'enabled': enabled,
      'image': image,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      enabled: map['enabled'] ?? false,
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));
}
