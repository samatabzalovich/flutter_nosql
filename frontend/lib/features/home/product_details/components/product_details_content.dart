import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/features/bloc/cart/cart_provider.dart';
import 'package:store/features/bloc/current_user/current_user.dart';
import 'package:store/features/home/repository/home_repository.dart';
import 'package:store/features/orders/repository/orders_repository.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/models/cart_item.dart';
import 'package:store/models/product.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/common/constants/colors.dart';
// import 'package:store/features/bloc/cart/cart_bloc.dart';
// import 'package:store/features/bloc/cart/cart_event.dart';
import 'package:store/features/widgets/default_button.dart';
import '../../../../models/order.dart';
import 'product_description.dart';
import 'product_images.dart';
import 'top_rounded_container.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailsScreenContent extends ConsumerStatefulWidget {
  Product product;
  DetailsScreenContent({Key? key, required this.product}) : super(key: key);

  @override
  ConsumerState<DetailsScreenContent> createState() =>
      _DetailsScreenContentState();
}

class _DetailsScreenContentState extends ConsumerState<DetailsScreenContent> {
  bool isVerified = false;

  Future<bool> canUser(BuildContext context) async {
    List<Order> orders =
        await ref.read(ordersRepoProvider).getOrders(context: context);
    for (Order order in orders) {
      for (CartItem item in order.products) {
        if (item.product.id == widget.product.id) {
          return true;
        }
      }
    }
    return false;
  }

  Future<Product?> _showRatingDialog(BuildContext context) async {
    double initialRating = 0.0;
    final double maxRating = 5.0;
    final int starCount = 5;
    final double ratingSize = 30.0;
    Product? ratedProduct;
    bool isloading = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Rate this product"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RatingBar.builder(
                    initialRating: initialRating,
                    maxRating: maxRating,
                    itemCount: starCount,
                    itemSize: ratingSize,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        initialRating = rating;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      //TODO: submit the rating to the backend
                      setState(() {
                        isloading = true;
                      });
                      Product? temp = await ref
                          .read(homeRepoProvider)
                          .rateProduct(
                              widget.product.id, initialRating, context);
                      setState(() {
                        isloading = false;
                      });
                      if (temp != null) {
                        ratedProduct = temp;
                        Navigator.of(context).pop(temp);
                      }
                    },
                    child: isloading == true
                        ? CircularProgressIndicator()
                        : Text("Submit"),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
    return ratedProduct;
  }

  void showProgressDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: primaryColor),
            ],
          ),
        );
      },
    );
  }

  Future<void> cartFunction(BuildContext context) async {
    await ref.read(cartProvider).addProductToCard(
        CartItem(product: widget.product, quantity: 1), context);
    Navigator.of(context).pop();
  }

  int counter = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    counter++;
  }

  @override
  Widget build(BuildContext context) {
    // final bloc = BlocProvider.of<CartBloc>(context);
    Product? temp;
    return FutureBuilder(
        future: canUser(context),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            bool canRate = snapshot.data!;
            // Once you've checked if the user can rate, you can call the _showRatingDialog method
            if (counter == 1) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (canRate) {
                  temp = await _showRatingDialog(context);
                  if (temp != null) {
                    setState(() {
                      widget.product = temp!;
                    });
                  }
                }
              });
              counter++;
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  ProductImages(product: widget.product),
                  TopRoundedContainer(
                      color: Colors.white,
                      child: Column(
                        children: [
                          ProductDescription(
                              product: widget.product, onSeeMorePressed: () {}),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    SizeConfig.getProportionateScreenHeight(
                                        8.0)),
                            child: DefaultButton(
                              text: "Add to basket",
                              backgroundColor: primaryColor,
                              forgroundColor: Colors.white,
                              onPressed: () async {
                                showProgressDialog(context);
                                await cartFunction(context);
                              },
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            );
          }
        });
  }
}
