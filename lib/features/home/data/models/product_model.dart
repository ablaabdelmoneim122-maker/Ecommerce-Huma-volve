import 'package:flutter/material.dart';

class ProductModel {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String categoryName;

  // الـ API مش بيرجع ألوان ولا مقاسات، فبنثبتهم للـ UI
  final List<Color> colors;
  final List<String> sizes;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.categoryName,
    this.colors = const [Colors.black, Colors.blueGrey, Colors.brown],
    this.sizes = const ['S', 'M', 'L', 'XL'],
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

  // الـ API أحياناً بيرجع الصور بشكل غريب، فبنفلترها
  static String _firstImage(dynamic images) {
    const fallback = 'https://placehold.co/600x600?text=No+Image';
    if (images is! List || images.isEmpty) return fallback;
    final url = images.first.toString().replaceAll(RegExp(r'[\[\]"]'), '');
    return url.startsWith('http') ? url : fallback;
  }
}
