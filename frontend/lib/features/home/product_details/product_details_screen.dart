import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/features/bloc/current_user/current_user.dart';
import 'package:store/models/product.dart';
import 'components/custom_app_bar.dart';
import 'components/product_details_content.dart';

class ProductDetailsScreen extends ConsumerWidget {
  static const routeName = '/details';
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Receive object from pushNamed Route
    bool isFav = false;
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: CustomAppBar(
          productId: product.id,
          // isProductFavourite: isFav,
        ),
      ),
      body: DetailsScreenContent(product: product),
    );
  }
}
