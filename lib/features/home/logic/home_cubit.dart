import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/home_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeService _service;
  Timer? _debounce;

  HomeCubit(this._service) : super(HomeLoading());

  Future<void> loadHome() async {
    emit(HomeLoading());
    try {
      final categories = await _service.getCategories();
      final products = await _service.getProducts();
      emit(HomeSuccess(categories: categories, products: products));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> selectCategory(int index) async {
    final current = state;
    if (current is! HomeSuccess || index == current.selectedIndex) return;

    emit(current.copyWith(selectedIndex: index, isLoadingProducts: true));
    try {
      final categoryId = index == 0 ? null : current.categories[index - 1].id;
      final products = await _service.getProducts(categoryId: categoryId);
      emit(
        current.copyWith(
          selectedIndex: index,
          products: products,
          isLoadingProducts: false,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void onSearchChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => _search(text.trim()),
    );
  }

  Future<void> _search(String query) async {
    final current = state;
    if (current is! HomeSuccess) return;

    emit(current.copyWith(selectedIndex: 0, isLoadingProducts: true));
    try {
      final products = await _service.getProducts(
        title: query.isEmpty ? null : query,
      );
      emit(
        current.copyWith(
          selectedIndex: 0,
          products: products,
          isLoadingProducts: false,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
