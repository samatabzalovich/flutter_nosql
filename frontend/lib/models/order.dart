import 'dart:convert';

import 'package:store/models/cart_item.dart';
import 'package:store/models/product.dart';

class Order {
  final String? id;
  final List<CartItem> products;
  final double totalPrice;
  final String address;
  final String userId;
  final DateTime? orderedAt;
  final int status;
  Order({
    this.id,
    required this.products,
    required this.totalPrice,
    required this.address,
    required this.userId,
    this.orderedAt,
    required this.status,
  });


  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(id != null){
      result.addAll({'_id': id});
    }
    result.addAll({'products': products.map((x) => x.toMap()).toList()});
    result.addAll({'totalPrice': totalPrice});
    result.addAll({'address': address});
    result.addAll({'userId': userId});
    if(orderedAt != null) {
      result.addAll({'orderedAt': orderedAt!.toIso8601String()});
    }
    result.addAll({'status': status});
  
    return result;
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] ?? '',
      products: List<CartItem>.from(map['products']?.map((x) => CartItem.fromMap(x))),
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
      userId: map['userId'] ?? '',
      orderedAt: DateTime.parse(map['orderedAt']),
      status: map['status']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}

// List<Order> demoOrders = [
//   Order(id: -1),
//   Order(id: -2),
//   Order(id: -3),
//   Order(id: -4),
// ];