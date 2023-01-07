import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/features/bloc/cart/cart_provider.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/models/cart_item.dart';
import 'package:store/models/product.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/common/constants/colors.dart';
// import 'package:store/features/bloc/cart/cart_bloc.dart';
// import 'package:store/features/bloc/cart/cart_event.dart';
import 'package:store/features/widgets/default_button.dart';
import 'product_description.dart';
import 'product_images.dart';
import 'top_rounded_container.dart';


class DetailsScreenContent extends ConsumerWidget {
  final Product product;
  const DetailsScreenContent({Key? key,required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final bloc = BlocProvider.of<CartBloc>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          ProductImages(product: product),
          TopRoundedContainer(
                color: Colors.white,
                child: Column(
                  children: [
                    ProductDescription(product: product, onSeeMorePressed: (){}),
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: SizeConfig.getProportionateScreenHeight(8.0)),
                      child: DefaultButton(
                        text: "Add to basket",
                        backgroundColor: primaryColor,
                        forgroundColor: Colors.white,
                        onPressed: (){
                          ref.read(cartProvider).addProductToCard(CartItem(product: product,quantity: 1), context);
                        },
                      ),
                    ),
                  ],
                )
              ),
        ],
      ),
    );
  }
}
