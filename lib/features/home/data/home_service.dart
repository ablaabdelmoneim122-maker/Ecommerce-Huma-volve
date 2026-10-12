import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'models/category_model.dart';
import 'models/product_model.dart';

class HomeService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.escuelajs.co/api/v1',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  )..interceptors.add(PrettyDioLogger());

  Future<List<ProductModel>> getProducts({
    int? categoryId,
    String? title,
  }) async {
    try {
      final path = categoryId == null
          ? '/products'
          : '/categories/$categoryId/products';
      final res = await _dio.get(
        path,
        queryParameters: {
          'offset': 0,
          'limit': 20,
          if (title != null) 'title': title,
        },
      );
      return (res.data as List).map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handle(e);
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final res = await _dio.get('/categories');
      return (res.data as List).map((e) => CategoryModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handle(e);
    }
  }

  String _handle(DioException e) {
    if (e.type == DioExceptionType.connectionError)
      return 'No internet connection';
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out';
    }
    return e.response?.data?['message']?.toString() ?? 'Something went wrong';
  }
}
