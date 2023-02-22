import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/features/bloc/cart/cart_provider.dart';
import 'package:store/features/bloc/current_user/current_user.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:store/features/bloc/cart/cart_bloc.dart';
// import 'package:store/features/bloc/cart/cart_event.dart';
// import 'package:store/features/bloc/cart/cart_state.dart';
import 'package:store/features/cart/screens/components/no_items_found.dart';
import 'package:store/features/widgets/banner.dart';
import 'package:store/models/cart.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/common/constants/colors.dart';
import 'package:store/features/cart/screens/checkout/checkout_screen.dart';
import 'package:store/features/widgets/custom_page_transition.dart';
import 'package:store/features/widgets/default_button.dart';
import 'package:store/models/cart_item.dart';
import 'package:store/models/order.dart';

import 'cart_card.dart';

class CartBody extends ConsumerStatefulWidget {
  const CartBody({Key? key}) : super(key: key);

  @override
  _CartBodyState createState() => _CartBodyState();
}

class _CartBodyState extends ConsumerState<CartBody> {
  late final bloc;
  @override
  void initState() {
    super.initState();
    // bloc = BlocProvider.of<CartBloc>(context);
  }
    double totalPrice = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder(
      future: ref.watch(cartProvider).cartItems,
      builder: (BuildContext context, AsyncSnapshot<List<CartItem>> snapshot) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getProportionateScreenWidth(20)),
          child: (snapshot.connectionState == ConnectionState.waiting)? Center(child: CircularProgressIndicator()):Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const CustomBanner(
                text: "Delivery for FREE until the end of the month",
                backgroundColor: Color(0xffd3f1ff),
              ),
              // List of cart's products
              Flexible(
                flex: 3,
                child: 
                    
                    (snapshot.data!.isNotEmpty)
                            ? Builder(builder: (context) {
                                
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Container(
                                        color: Colors.white,
                                        child: Dismissible(
                                          key: Key(snapshot
                                              .data![index].product.id
                                              .toString()),
                                          direction:
                                              DismissDirection.endToStart,
                                          onDismissed: (direction) {
                                            ref
                                                .read(cartProvider)
                                                .removeFromCart(
                                                    snapshot.data![index],
                                                    context);
                                          },
                                          background: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            decoration: BoxDecoration(
                                                color: const Color(0xFFFFE6E6),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Row(
                                              children: const [
                                                Spacer(),
                                                Icon(
                                                  Icons.restore_from_trash,
                                                  color: Colors.redAccent,
                                                )
                                              ],
                                            ),
                                          ),
                                          child: CartItemCard(
                                              cartItem: snapshot.data![index],
                                              itemIndex: index),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                            : const NoItemsFound()
              ),
              const SizedBox(
                height: 45,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontFamily: "Serif"),
                        ),
                        Builder(
                          builder: (context) {
                            snapshot.data!.forEach((element) {
                                  totalPrice = element.product.price *
                                      element.quantity;
                                });
                            return Text(
                              "\$${totalPrice}",
                              style: TextStyle(
                                color: Color(0xff5956e9),
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          }
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  DefaultButton(
                    text: "Checkout",
                    backgroundColor: primaryColor,
                    forgroundColor: Colors.white,
                    onPressed: () => Navigator.push(
                        context,
                        CustomScaleTransition(
                            nextPageUrl: CheckoutScreen.routeName,
                            nextPage:  CheckoutScreen(order: Order(products: snapshot.data!, totalPrice: totalPrice, address: ref.read(currentUserProvider).currentUser!.address, userId: ref.read(currentUserProvider).currentUser!.id, status: 0),))),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                ],
              )
            ],
          ),
        );
      },
    ));
  }
}
