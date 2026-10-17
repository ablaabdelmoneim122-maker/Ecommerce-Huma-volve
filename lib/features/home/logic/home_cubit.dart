import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/home_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  static const _pageSize = 20;

  final HomeService _service;
  Timer? _debounce;
  int _offset = 0;
  int? _categoryId;
  String? _title;

  HomeCubit(this._service) : super(HomeLoading());

  Future<void> loadHome() async {
    _offset = 0;
    _categoryId = null;
    _title = null;
    emit(HomeLoading());
    try {
      final categories = await _service.getCategories();
      final products = await _service.getProducts(offset: _offset);
      _offset = products.length;
      emit(
        HomeSuccess(
          categories: categories,
          products: products,
          hasReachedMax: products.length < _pageSize,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! HomeSuccess ||
        current.isLoadingProducts ||
        current.isLoadingMore ||
        current.hasReachedMax) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    try {
      final products = await _service.getProducts(
        categoryId: _categoryId,
        title: _title,
        offset: _offset,
      );
      _offset += products.length;
      emit(
        current.copyWith(
          products: [...current.products, ...products],
          isLoadingMore: false,
          hasReachedMax: products.length < _pageSize,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> selectCategory(int index) async {
    final current = state;
    if (current is! HomeSuccess || index == current.selectedIndex) return;

    _categoryId = index == 0 ? null : current.categories[index - 1].id;
    _title = null;
    _offset = 0;
    emit(current.copyWith(selectedIndex: index, isLoadingProducts: true));
    try {
      final products = await _service.getProducts(
        categoryId: _categoryId,
        offset: _offset,
      );
      _offset = products.length;
      emit(
        current.copyWith(
          selectedIndex: index,
          products: products,
          isLoadingProducts: false,
          isLoadingMore: false,
          hasReachedMax: products.length < _pageSize,
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

    _categoryId = null;
    _title = query.isEmpty ? null : query;
    _offset = 0;
    emit(current.copyWith(selectedIndex: 0, isLoadingProducts: true));
    try {
      final products = await _service.getProducts(
        title: _title,
        offset: _offset,
      );
      _offset = products.length;
      emit(
        current.copyWith(
          selectedIndex: 0,
          products: products,
          isLoadingProducts: false,
          isLoadingMore: false,
          hasReachedMax: products.length < _pageSize,
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
