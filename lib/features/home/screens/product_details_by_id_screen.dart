import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection_container.dart';
import '../../details/screens/product_details_screen.dart';
import '../logic/product_details_cubit.dart';
import '../logic/product_details_state.dart';

class ProductDetailsByIdScreen extends StatelessWidget {
  final int productId;
  const ProductDetailsByIdScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductDetailsCubit>()..load(productId),
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsSuccess) {
            return ProductDetailsScreen(product: state.product);
          }
          if (state is ProductDetailsError) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProductDetailsCubit>().load(productId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}