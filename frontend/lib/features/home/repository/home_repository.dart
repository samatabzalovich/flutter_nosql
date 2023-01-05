import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:store/models/product.dart';
import 'package:http/http.dart' as http;

import '../../../common/Utilities/error_handler.dart';
import '../../../common/constants/routes.dart';

class HomeRepository extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products {
    return _products;
  }
 Future<List<Product>> fetchSearchedProduct({
    required BuildContext context,
    required String searchQuery,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/products/search/$searchQuery'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }
  void addProduct(Map<String, dynamic> map, BuildContext context) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/seller/add-product'),
        body: json.encode({map}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      bool isOk = httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context: context, content: 'Product created');
        },
      );
      if (isOk) {
        //////////////////////////////////////////////////////////////////////////////
        _products.add(Product.fromMap(res.body));
        notifyListeners();
      }
    } catch (e) {
      showSnackBar(context: context, content: 'Something went wrong');
    }
  }

  void updateProduct(Product product, BuildContext context) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/seller/update-product'),
        body: product.toMap(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      bool isOk = httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context: context, content: 'Product updated');
        },
      );
      if (isOk) {
        // Product updatedProduct = Product.fr(res.body);
        Product updatedProduct = product;
        _products[_products.indexWhere(
            (element) => element.id == updatedProduct.id)] = updatedProduct;
        notifyListeners();
      }
    } catch (e) {
      showSnackBar(context: context, content: 'Something went wrong');
    }
  }
}
