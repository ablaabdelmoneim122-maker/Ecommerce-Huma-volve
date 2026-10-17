import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/usecases/get_product_by_id_usecase.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductByIdUseCase _getProduct;

  ProductDetailsCubit(this._getProduct) : super(ProductDetailsLoading());

  Future<void> load(int id) async {
    emit(ProductDetailsLoading());
    final result = await _getProduct.invoke(id);
    result.fold(
      (f) => emit(ProductDetailsError(f.failureMessage)),
      (p) => emit(ProductDetailsSuccess(p)),
    );
  }
}