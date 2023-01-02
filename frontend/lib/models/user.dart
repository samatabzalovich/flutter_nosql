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

class UserModel {
  String? id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String email;
  final String password;
  final String type;
  String? token;
  final List<dynamic> cart;

  UserModel({required this.firstName, required this.lastName, required this.phoneNumber, 
    this.id,
    required this.email,
    required this.password,
    required this.address,
    required this.type,
    required this.token,
    required this.cart,
  });


  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(id != null){
      result.addAll({'id': id});
    }
    result.addAll({'firstName': firstName});
    result.addAll({'lastName': lastName});
    result.addAll({'phoneNumber': phoneNumber});
    result.addAll({'address': address});
    result.addAll({'email': email});
    result.addAll({'password': password});
    result.addAll({'type': type});
    if(token != null){
      result.addAll({'token': token});
    }
    result.addAll({'cart': cart});
  
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      type: map['type'] ?? '',
      token: map['token'],
      cart: List<dynamic>.from(map['cart']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
