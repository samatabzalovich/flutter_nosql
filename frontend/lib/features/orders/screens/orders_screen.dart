import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/common/constants/colors.dart';
import 'package:store/features/cart/screens/components/cart_card.dart';
import 'package:store/features/orders/repository/orders_repository.dart';
import 'package:store/features/widgets/custom_app_bar.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/features/bloc/order/order_bloc.dart';
import 'package:store/features/bloc/order/order_event.dart';
import 'package:store/features/bloc/order/order_state.dart';
import 'package:store/models/cart_item.dart';

import '../../../models/order.dart';
import 'components/no_orders.dart';

class OrderScreen extends ConsumerStatefulWidget {
  static const String routeName = "/order";
  const OrderScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  @override
  void initState() {
    // var bloc = BlocProvider.of<OrderBloc>(context);
    // bloc.add(const FetchOrdersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height +
              SizeConfig.getProportionateScreenHeight(40)),
          child: const CustomAppBar(
            title: "Orders History",
          )),
      body: SafeArea(
        child: FutureBuilder(
          future: ref.read(ordersRepoProvider).fetchOrders(context: context),
          builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const NoOrder();
              } else {
                List<Order> orders = snapshot.data!;
                return Padding(
                  padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getProportionateScreenWidth(20)),
                  child: Flexible(
                flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                      child: ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                              margin: EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.all(
                                            10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                "Order with id ${orders[index].id}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontFamily: "Serif")),
                                    SizedBox(height: 10,),
                                  Column(
                                    children: [
                                      ...List.generate(orders[index].products.length,
                                      (i) =>  Column(
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            child: OrderItemCard(
                                                cartItem: orders[index].products[i],
                                                itemIndex: i),
                                          ),
                                          SizedBox(height: 8,)
                                        ],
                                      ),
                                      )
                                    ],
                                  ),
                                  Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontFamily: "Serif"),
                              ),
                                  SizedBox(width: 20,),
                                  Text(
                                    "\$${orders[index].totalPrice}",
                                    style: TextStyle(
                                      color: Color(0xff5956e9),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  
                                
                              )
                            ],
                          ),
                                  Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Status",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontFamily: "Serif"),
                              ),
                                  SizedBox(width: 20,),
                                  Text(
                                    "${orders[index].status}",
                                    style: TextStyle(
                                      color: Color(0xff5956e9),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  
                                
                              )
                            ],
                          )
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                );
              }
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  CartItem cartItem;
  final int itemIndex;
  OrderItemCard(
      {Key? key, required this.cartItem, required this.itemIndex})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final bloc = BlocProvider.of<CartBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product's image
        SizedBox(
          width: 88,
          // Container contains product's image
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding:
                  EdgeInsets.all(SizeConfig.getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: cartItem.product.image.startsWith("asset") ? Image.asset(
                      cartItem.product.image,
                      fit: BoxFit.contain,
                    ) : Image.network(
                      cartItem.product.image,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
        ),
        // Product's details
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            cartItem.product.title,
            style: const TextStyle(color: Colors.black, fontSize: 16),
            maxLines: 2,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "\$${cartItem.product.price}",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Quantity",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    letterSpacing: 0.52,
                    fontFamily: "Serif"),
              ),
              const SizedBox(
                width: 10,
              ),
              Text("${cartItem.quantity}"),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
        ]),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
