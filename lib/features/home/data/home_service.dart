import 'package:dio/dio.dart';
import 'models/category_model.dart';
import 'models/product_model.dart';

class HomeService {
  final Dio _dio;

  HomeService(this._dio);

  Future<List<ProductModel>> getProducts({
    int? categoryId,
    String? title,
    int offset = 0,
  }) async {
    try {
      final path = categoryId == null
          ? '/products'
          : '/categories/$categoryId/products';
      final res = await _dio.get(
        path,
        queryParameters: {
          'offset': offset,
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
