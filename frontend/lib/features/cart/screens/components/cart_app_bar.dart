import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/common/constants/colors.dart';
import 'package:store/features/bloc/cart/cart_provider.dart';
// import 'package:store/features/bloc/cart/cart_bloc.dart';
// import 'package:store/features/bloc/cart/cart_event.dart';

class CartAppBar extends ConsumerWidget {
  const CartAppBar({
    Key? key,
  }) : super(key: key);

  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final bloc = BlocProvider.of<CartBloc>(context);
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.getProportionateScreenWidth(30),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: SizeConfig.getProportionateScreenWidth(40),
                  height: SizeConfig.getProportionateScreenWidth(40),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      foregroundColor: primaryColor,
                      // backgroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Text(
                  "Basket",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  child: const Icon(
                    Icons.restore_from_trash,
                    color: Colors.redAccent,
                  ),
                  onTap: () {
                    // bloc.add(const ClearCartContentEvent());
                    ref.read(cartProvider).removeProductsFromCart(context);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
