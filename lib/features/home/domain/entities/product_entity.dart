import 'package:flutter/material.dart';

class ProductEntity {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String categoryName;
  final List<Color> colors; // ثابتة للـ UI لأن الـ API مش بيرجعها
  final List<String> sizes;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.categoryName,
    this.colors = const [Colors.black, Colors.blueGrey, Colors.brown],
    this.sizes = const ['S', 'M', 'L', 'XL'],
  });
}