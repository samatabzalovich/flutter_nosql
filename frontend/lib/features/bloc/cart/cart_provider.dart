import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:store/features/bloc/current_user/current_user.dart';
import 'package:store/models/cart_item.dart';
import 'package:store/models/user.dart';

import '../../../common/Utilities/error_handler.dart';
import '../../../common/constants/routes.dart';

final cartProvider = ChangeNotifierProvider<Cart>((ref) {
  return Cart(ref: ref);
});

class Cart extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  ChangeNotifierProviderRef ref;
  Cart({
    required this.ref,
  });
  Future<List<CartItem>> get cartItems async {
    UserModel currentUserData = ref.read(currentUserProvider).currentUser!;
    Map<String, String> map = {"id": currentUserData.id!};
    http.Response res = await http.post(
      Uri.parse('$uri/tokenIsValid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': currentUserData.token!
      },
      // body: json.encode(map));
    );
    UserModel resultDynamic = UserModel.fromJson(res.body);
    _cartItems = resultDynamic.cart;
    return _cartItems;
  }

  Future<void> addProductToCard(CartItem cartItem, BuildContext context) async {
    _cartItems.add(cartItem);
    UserModel currentUserData = ref.read(currentUserProvider).currentUser!;
    Map<String, dynamic> map = {
      "id": cartItem.product.id,
      "quantity": cartItem.quantity
    };
    http.Response res = await http.post(Uri.parse('$uri/api/add-to-cart'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': currentUserData.token!
        },
        body: json.encode(map));
    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        UserModel resultModel = UserModel.fromJson(res.body);
        UserModel user = ref
            .read(currentUserProvider)
            .currentUser!
            .copyWith(cart: resultModel.cart);
        ref.read(currentUserProvider).setUser(user, context);
      },
    );
    notifyListeners();
  }

  void removeFromCart(CartItem cartItem, BuildContext context) async {
    _cartItems.remove(cartItem);
    UserModel currentUserData = ref.read(currentUserProvider).currentUser!;
    // Map<String, String> map = {
    //   "id": currentUserData.id!,
    //   "cartItem": cartItem.toJson()
    // };
    http.Response res = await http.delete(
      Uri.parse('$uri/api/remove-from-cart/${cartItem.product.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': currentUserData.token!
      },
    );
    // body: jsonEncode({map}));
    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        UserModel resultModel = UserModel.fromJson(res.body);
        UserModel user = ref
            .read(currentUserProvider)
            .currentUser!
            .copyWith(cart: resultModel.cart);
        ref.read(currentUserProvider).setUser(user, context);
        showSnackBar(context: context, content: 'Product removed from cart');
      },
    );
    notifyListeners();
  }

  void removeProductsFromCart(BuildContext context) async {
    _cartItems.clear();
    UserModel currentUserData = ref.read(currentUserProvider).currentUser!;
    http.Response res = await http.delete(
      Uri.parse('$uri/api/remove-products-from-cart/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': currentUserData.token!
      },
    );
    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        List<CartItem> temp = [];
        for (var i = 0; i < json.decode(res.body)['cart'].length; i++) {
          temp.add(CartItem.fromMap(json.decode(res.body)['cart'][i]));
        }
        UserModel user =
            ref.read(currentUserProvider).currentUser!.copyWith(cart: temp);
        ref.read(currentUserProvider).setUser(user, context);
        showSnackBar(
            context: context, content: 'All products removed from cart');
      },
    );
    notifyListeners();
  }
}
