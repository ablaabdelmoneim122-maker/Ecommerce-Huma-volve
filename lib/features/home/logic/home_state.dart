abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

class HomeSuccess extends HomeState {
  final List<dynamic> categories;
  final List<dynamic> products;
  final int selectedIndex; // 0 = All
  final bool isLoadingProducts;

  HomeSuccess({
    required this.categories,
    required this.products,
    this.selectedIndex = 0,
    this.isLoadingProducts = false,
  });

  HomeSuccess copyWith({
    List<dynamic>? products,
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