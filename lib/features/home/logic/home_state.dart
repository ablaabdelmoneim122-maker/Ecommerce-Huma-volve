import '../data/models/category_model.dart';
import '../data/models/product_model.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

class HomeSuccess extends HomeState {
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final int selectedIndex; // 0 = All
  final bool isLoadingProducts;

  HomeSuccess({
    required this.categories,
    required this.products,
    this.selectedIndex = 0,
    this.isLoadingProducts = false,
  });

  HomeSuccess copyWith({
    List<ProductModel>? products,
    int? selectedIndex,
    bool? isLoadingProducts,
  }) {
    return HomeSuccess(
      categories: categories,
      products: products ?? this.products,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
    );
  }
}
