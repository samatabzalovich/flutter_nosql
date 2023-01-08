
import 'dart:convert';

import 'package:flutter/widgets.dart';

class Category extends ChangeNotifier {
  final int id;
  final String title;
  final String image;
  Category({
    required this.id,
    required this.title,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'image': image});
  
    return result;
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) => Category.fromMap(json.decode(source));
}


List<Map<String, dynamic>> categories = [
  {"title": "Wearable"},
  {"title": "Laptop"},
  {"title": "Phones"},
  {"title": "Clock"},
  {"title": "Smartphone"},
  {"title": "Fashion"},
  {"title": "Computers"},
  {"title": "Shoes"},
  {"title": "Drones"},
];