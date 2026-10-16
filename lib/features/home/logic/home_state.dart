import '../domain/entities/category_entity.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

class HomeSuccess extends HomeState {
  final List<CategoryEntity> categories;
  final List<dynamic> products;
  final int selectedIndex; // 0 = All
  final bool isLoadingProducts;
  final bool isLoadingMore;   // جديد
  final bool hasReachedMax;   // جديد

  HomeSuccess({
    required this.categories,
    required this.products,
    this.selectedIndex = 0,
    this.isLoadingProducts = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  });

  HomeSuccess copyWith({
    List<dynamic>? products,
    int? selectedIndex,
    bool? isLoadingProducts,
    bool? isLoadingMore,
    bool? hasReachedMax,
  }) {
    return HomeSuccess(
      categories: categories,
      products: products ?? this.products,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}