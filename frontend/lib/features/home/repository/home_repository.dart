import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:store/features/bloc/current_user/current_user.dart';
import 'package:store/models/category.dart';
import 'package:store/models/product.dart';

import '../../../common/Utilities/error_handler.dart';
import '../../../common/constants/routes.dart';
import '../../../models/user.dart';

final homeRepoProvider = ChangeNotifierProvider((ref) {
  return HomeRepository(ref: ref);
});

class HomeRepository extends ChangeNotifier {
  final ChangeNotifierProviderRef ref;
  Category? _selectedCategory;
  List<Category> _fetchedCategories = [];
  HomeRepository({
    required this.ref,
  });

  Category? get selectedCategory => _selectedCategory;
  List<Category>? get fetchedCategories => _fetchedCategories;
  void changeSelectedCategory(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<List<Product>> fetchSearchedProduct({
    required BuildContext context,
    required String searchQuery,
  }) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    final UserModel userProvider = ref.read(currentUserProvider).currentUser!;
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/products/search/$searchQuery'),
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
            productList.add(
              Product.fromJson(jsonDecode(res.body)[i]),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return productList;
  }

  Future<List<Product>> fetchProductByCategory({
    required BuildContext context,
    required String categoryId,
  }) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    final UserModel userProvider = ref.read(currentUserProvider).currentUser!;
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/products?category=$categoryId'),
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
            productList.add(
              Product.fromMap(jsonDecode(res.body)[i]),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return productList;
  }

  Future<bool> addToFavourites(String productId, BuildContext context) async {
    final UserModel userProvider = ref.read(currentUserProvider).currentUser!;
    List<String> favourites = [];
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/favourites'),
        body: jsonEncode({"id": productId}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.token!,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          UserModel user = ref
              .read(currentUserProvider)
              .currentUser!
              .copyWith(favourites: jsonDecode(res.body));
          ref.read(currentUserProvider).setUser(user, context);
        },
      );

      return true;
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return false;
  }

  Future<Product?> fetchProductById({
    required BuildContext context,
    required String productId,
  }) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    final UserModel userProvider = ref.read(currentUserProvider).currentUser!;
    Product? product;
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/products-by-id/$productId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.token!,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          product = Product.fromJson(res.body);
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return product;
  }

  Future<List<Category>> fetchCategories({
    required BuildContext context,
  }) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    final UserModel userProvider = ref.read(currentUserProvider).currentUser!;
    List<Category> categories = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/categories'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.token!,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          List loopable = jsonDecode(res.body);
          for (int i = 0; i < loopable.length; i++) {
            categories.add(Category.fromMap(loopable[i]));
          }
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    _fetchedCategories = categories;
    notifyListeners();
    return categories;
  }

  Future<Product?> rateProduct(
      String id, double rating, BuildContext context) async {
      Product? temp;
    try {
      final url = Uri.parse('$uri/api/rate-product');
    final UserModel userProvider = ref.read(currentUserProvider).currentUser!;
      final response = await http.post(url,
          headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.token!,
        },
          body: json.encode({'id': id, 'rating': rating}));
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          temp = Product.fromJson(response.body);
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return temp;
  }

  Future<List<Product>> fetchPopularProducts({
    required BuildContext context,
  }) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    final UserModel userProvider = ref.read(currentUserProvider).currentUser!;
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/popular-products/'),
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
            productList.add(
              Product.fromJson(jsonDecode(res.body)[i]),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return productList;
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

}
