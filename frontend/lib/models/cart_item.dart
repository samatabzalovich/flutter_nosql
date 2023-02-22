
import 'dart:convert';

import 'package:store/models/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});



  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'product': product.toMap()});
    result.addAll({'quantity': quantity});
  
    return result;
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map['product']),
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) => CartItem.fromMap(json.decode(source));
}
