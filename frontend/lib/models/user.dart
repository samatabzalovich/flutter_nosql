// class UserModel {
//   late final String firstName;
//   late final String lastName;
//   late final String phoneNumber;
//   late final String address;
//   late final String email;
//   late final String password;
//   String? id;

//   UserModel(
//       {required this.firstName,
//       required this.lastName,
//       required this.phoneNumber,
//       required this.address,
//       required this.email,
//       required this.password, this.id});

//   Map<String, dynamic> toMap() {
//     return {
//       'firstName': firstName,
//       'lastName': lastName,
//       'phoneNumber': phoneNumber,
//       'address': address,
//       'email': email,
//       'password': password
//     };
//   }

//   UserModel.fromMap(dynamic map) {
//     firstName = map['firstName'];
//     lastName = map['lastName'];
//     phoneNumber = map['phoneNumber'];
//     address = map['address'];
//     email = map['email'];
//     password = map['password'];
//   }

//   UserModel toEntity() => UserModel(
//         firstName: firstName,
//         lastName: lastName,
//         phoneNumber: phoneNumber,
//         address: address,
//         email: email,
//         password: password,
//       );
// }

import 'dart:convert';

import 'package:store/models/cart_item.dart';
import 'package:store/models/product.dart';

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String email;
  final String password;
  final String type;
  final String? profilePic;
  String? token;
  final List<CartItem> cart;
  List? favourites = [];

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.password,
    required this.type,
    this.profilePic,
    required this.token,
    required this.cart,
    this.favourites,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'_id': id});
    result.addAll({'firstName': firstName});
    result.addAll({'lastName': lastName});
    result.addAll({'phoneNumber': phoneNumber});
    result.addAll({'address': address});
    result.addAll({'email': email});
    result.addAll({'password': password});
    result.addAll({'type': type});
    if(profilePic != null){
      result.addAll({'profilePic': profilePic});
    }
    if(token != null){
      result.addAll({'token': token});
    }
    result.addAll({'cart': cart.map((x) => x.toMap()).toList()});
    if(favourites != null){
      result.addAll({'favourites': favourites});
    }
  
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      type: map['type'] ?? '',
      profilePic: map['profilePic'],
      token: map['token'],
      cart: List<CartItem>.from(map['cart']?.map((x) => CartItem.fromMap(x))),
      favourites: List<String>.from(map['favourites']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? address,
    String? email,
    String? password,
    String? type,
    String? profilePic,
    String? token,
    List<CartItem>? cart,
    List? favourites,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      email: email ?? this.email,
      password: password ?? this.password,
      type: type ?? this.type,
      profilePic: profilePic ?? this.profilePic,
      token: token ?? this.token,
      cart: cart ?? this.cart,
      favourites: favourites ?? this.favourites,
    );
  }
}
