import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  final List<Color> _colors;

  @override
  List<Color> get colors => _colors;

  const ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.imageUrl,
    required super.description,
    required super.categoryName,
    this._colors = const [Colors.black, Colors.blueGrey, Colors.brown],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imageUrl: _firstImage(json['images']),
      description: json['description'] ?? '',
      categoryName: json['category']?['name'] ?? '',
    );
  }

  static String _firstImage(dynamic images) {
    const fallback = 'https://placehold.co/600x600?text=No+Image';
    if (images is! List || images.isEmpty) return fallback;
    final url = images.first.toString().replaceAll(RegExp(r'[\[\]"]'), '');
    return url.startsWith('http') ? url : fallback;
  }
}