import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/features/bloc/cart/cart_provider.dart';
import 'package:store/features/widgets/custom_app_bar.dart';
import 'components/cart_body.dart';

class CartScreen extends ConsumerWidget {
  static String routeName = "/cart";
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SizeConfig.init(context);
    // final bloc = BlocProvider.of<CartBloc>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height +
            SizeConfig.getProportionateScreenHeight(40)),
        child: CustomAppBar(
          title: "Basket",
          icon: const Icon(
            Icons.restore_from_trash,
            color: Colors.redAccent,
          ),
          onIconTapped: () {
            // bloc.add(const ClearCartContentEvent());
            ref.read(cartProvider).removeProductsFromCart(context);
          },
        ),
      ),
      body: const CartBody(),
    );
  }
}
