import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:store/features/bloc/current_user/current_user.dart';
import 'package:store/models/category.dart';
import 'package:store/models/product.dart';

import '../../../common/Utilities/error_handler.dart';
import '../../../common/constants/routes.dart';
import '../../../models/order.dart';
import '../../../models/user.dart';

final ordersRepoProvider = ChangeNotifierProvider<OrdersRepository>((ref) {
  return OrdersRepository(ref: ref);
});

class OrdersRepository extends ChangeNotifier{
  final ChangeNotifierProviderRef ref;
  List<Order> _fetchedOrders = [];
  OrdersRepository({
    required this.ref,
  });

  // List<Order>? get fetchedOrders => _fetchedOrders;
  Future<List<Order>> getOrders({
    required BuildContext context,
  }) async {
    if (_fetchedOrders.isNotEmpty) {
      return _fetchedOrders;
    } else {
      return fetchOrders(context: context);
    }
  }

  Future<List<Order>> fetchOrders({
    required BuildContext context,
  }) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    final UserModel userProvider = ref.read(currentUserProvider).currentUser!;
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/orders/me'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.token!,
        },
      );
      
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromMap(jsonDecode(res.body)[i]),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    _fetchedOrders = orderList;
    return orderList;
  }

  Future<Order?> addOrder(Order order, BuildContext context) async {
    try {
      final String jsonOrder = order.toJson();
      final UserModel userProvider = ref.read(currentUserProvider).currentUser!;
      http.Response res = await http.post(
        Uri.parse('$uri/api/order'),
        body: jsonOrder,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.token!,
        },
      );
      Order? received;
      bool isOk = httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          if(res.statusCode == 200) {
            received = Order.fromJson(res.body);
          showSnackBar(context: context, content: 'Order created');
          }
        },
      );
      if (isOk) {
        _fetchedOrders.add(received!);
      }
      return received;
    } catch (e) {
      showSnackBar(context: context, content: 'Something went wrong');
    }
    return null;
  }


}


  // void addProduct(Map<String, dynamic> map, BuildContext context) async {
  //   try {
  //     http.Response res = await http.post(
  //       Uri.parse('$uri/seller/add-product'),
  //       body: json.encode({map}),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //     );
  //     bool isOk = httpErrorHandle(
  //       response: res,
  //       context: context,
  //       onSuccess: () {
  //         showSnackBar(context: context, content: 'Product created');
  //       },
  //     );
  //     if (isOk) {
  //       //////////////////////////////////////////////////////////////////////////////
  //       _products.add(Product.fromMap(res.body));
  //     }
  //   } catch (e) {
  //     showSnackBar(context: context, content: 'Something went wrong');
  //   }
  // }
  // void updateProduct(Product product, BuildContext context) async {
  //   try {
  //     http.Response res = await http.post(
  //       Uri.parse('$uri/seller/update-product'),
  //       body: product.toMap(),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //     );
  //     bool isOk = httpErrorHandle(
  //       response: res,
  //       context: context,
  //       onSuccess: () {
  //         showSnackBar(context: context, content: 'Product updated');
  //       },
  //     );
  //     if (isOk) {
  //       // Product updatedProduct = Product.fr(res.body);
  //       Product updatedProduct = product;
  //       _products[_products.indexWhere(
  //           (element) => element.id == updatedProduct.id)] = updatedProduct;
  //     }
  //   } catch (e) {
  //     showSnackBar(context: context, content: 'Something went wrong');
  //   }
  // }