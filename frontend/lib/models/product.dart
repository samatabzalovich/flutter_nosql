import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store/models/rating.dart';

// class Product {
//   final String id;
//   final String title;
//   final String owner;
//   final Map<String, String> description;
//   final String image;
//   final List<String> images;
//   final List<String> colors;
//   final List<Rating>? rating;
//   final int quantity;
//   final double price;
//   final String category;
//   bool? isFavourite;
//   Product({
//     required this.id,
//     required this.title,
//     required this.owner,
//     required this.description,
//     required this.image,
//     required this.images,
//     required this.colors,
//     this.rating,
//     required this.quantity,
//     required this.price,
//     required this.category,
//     this.isFavourite = false,
//   });

//   Map<String, dynamic> toMap() {
//     final result = <String, dynamic>{};

//     result.addAll({'id': id});
//     result.addAll({'title': title});
//     result.addAll({'owner': owner});
//     result.addAll({'description': description});
//     result.addAll({'image': image});
//     result.addAll({'images': images});
//     result.addAll({'colors': colors});
//     if(rating != null){
//       result.addAll({'rating': rating!.map((x) => x?.toMap()).toList()});
//     }
//     result.addAll({'quantity': quantity});
//     result.addAll({'price': price});
//     result.addAll({'category': category});
//     if(isFavourite != null){
//       result.addAll({'isFavourite': isFavourite});
//     }

//     return result;
//   }

//   factory Product.fromMap(Map<String, dynamic> map) {
//     return Product(
//       id: map['id'] ?? '',
//       title: map['title'] ?? '',
//       owner: map['owner'] ?? '',
//       description: Map<String, String>.from(map['description']),
//       image: map['image'] ?? '',
//       images: List<String>.from(map['images']),
//       colors: List<String>.from(map['colors']),
//       rating: map['rating'] != null ? List<Rating>.from(map['rating']?.map((x) => Rating.fromMap(x))) : null,
//       quantity: map['quantity']?.toInt() ?? 0,
//       price: map['price']?.toDouble() ?? 0.0,
//       category: map['category'] ?? '',
//       isFavourite: map['isFavourite'],
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Product.fromJson(String source) => Product.fromMap(json.decode(source));
// }
class Product {
  final String id;
  final String title;
  final String description;
  final String image;
  final List<String> images;
  final List<dynamic> colors;
  final double rating;
  final double price;
  final String category;
  bool isFavourite, isPopular;
  // late DateTime createdAt;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.colors,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.price,
    required this.image,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'_id': id});
    result.addAll({'title': title});
    result.addAll({'description': description});
    result.addAll({'image': image});
    result.addAll({'images': images});
    result.addAll({'colors': colors});
    result.addAll({'rating': rating});
    result.addAll({'price': price});
    result.addAll({'category': category});
    ;

    return result;
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      images: List<String>.from(map['images']),
      colors: map['colors'],
      rating: map['rating']?.toDouble() ?? 0.0,
      price: map['price']?.toDouble() ?? 0.0,
      category: map['category'] ?? '',
      // isPopular: bool isFavourite,.fromMap(map['isPopular']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}

List<Product> demoProducts = [
  Product(
    id: '63b9995b9f7cf4265d1ec91c',
    image: "assets/images/p1.png",
    images: [
      "assets/images/p1_2.jpg",
      "assets/images/p1_3.jpg",
      "assets/images/p1_4.jpg",
    ],
    category: "Clock , Wearable",
    colors: [
      {"colorName": "Red Rose", "color": 0xFFF6625E},
      {"colorName": "Purple", "color": 0xFF836DB8},
      {"colorName": "Gold", "color":  0xFFDECB9C},
    ],
    title: "Apple Watch",
    price: 64.99,
    description:
        "headline: Get Apple TV+ free for a year, description: description",
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: '2',
    image: "assets/images/p2.png",
    images: [
      "assets/images/p2_1.png",
      "assets/images/p2_2.jpg",
    ],
    category: "Fashion",
    colors: [
      {"colorName": "Red Rose", "color": 0xFFF6625E},
      {"colorName": "Purple", "color": 0xFF836DB8},
      {"colorName": "Gold", "color": 0xFFDECB9C},
      {"colorName": "Red", "color": 0xE7FF0D29}
    ],
    title: "Apple Watch",
    price: 50.5,
    description:
        "headline: Get Apple TV+ free for a year, description: description",
    rating: 4.1,
    isPopular: true,
  ),
  Product(
    id: '3',
    image: "assets/images/p3.png",
    images: [
      "assets/images/p3_1.png",
    ],
    category: "Shoes",
    colors: [
      {"colorName": "Red Rose", "color": 0xFFF6625E},
      {"colorName": "Purple", "color": 0xFF836DB8},
      {"colorName": "Gold", "color": 0xFFDECB9C},
      {"colorName": "Red", "color": 0xE7FF0D29}
    ],
    title: "Nike Shoes",
    price: 20.20,
    description:
        "headline: Get Apple TV+ free for a year, description: description",
    rating: 4.1,
    isFavourite: false,
  ),
  Product(
    id: '4',
    image: "assets/images/p4.png",
    images: [
      "assets/images/p4.png",
      "assets/images/p4.png",
      "assets/images/p4.png",
    ],
    category: "Clocks",
    colors: [
      {"colorName": "Red Rose", "color": 0xFFF6625E},
      {"colorName": "Purple", "color": 0xFF836DB8},
      {"colorName": "Gold", "color": 0xFFDECB9C},
      {"colorName": "Red", "color": 0xE7FF0D29}
    ],
    title: "Apple Watch",
    price: 20.20,
    description:
        "headline: Get Apple TV+ free for a year, description: description",
    rating: 4.1,
    isFavourite: false,
  ),
  Product(
    id: '5',
    image: "assets/images/p5_1.png",
    images: [
      "assets/images/p5_1.png",
      "assets/images/p5_1.png",
    ],
    category: "Computers",
    colors: [
      {"colorName": "Red Rose", "color": const Color(0xFFF6625E)},
      {"colorName": "Purple", "color": const Color(0xFF836DB8)},
      {"colorName": "Gold", "color": const Color(0xFFDECB9C)},
      {"colorName": "Red", "color": const Color(0xE7FF0D29)},
      {"colorName": "Yellow", "color": const Color(0xE7FFD70D)}
    ],
    title: "Apple Laptop",
    price: 36.55,
    description:
        "headline: Get Apple TV+ free for a year, description: description",
    rating: 4.4,
    isFavourite: true,
    isPopular: true,
  ),
];

const String description =
    "Available when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial …";

Map s = {
  "image": "assets/images/p1.png",
  "images": [
    "assets/images/p1_2.jpg",
    "assets/images/p1_3.jpg",
    "assets/images/p1_4.jpg",
  ],
  "category": "Clock , Wearable",
  "colors": [
    {"colorName": "Red Rose", "color": const Color(0xFFF6625E)},
    {"colorName": "Purple", "color": const Color(0xFF836DB8)},
    {"colorName": "Gold", "color": const Color(0xFFDECB9C)},
  ],
  "title": "Apple Watch",
  "price": 64.99,
  "description": {
    "headline": "Get Apple TV+ free for a year",
    "description": description
  },
};
