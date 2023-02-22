import 'dart:convert';

class Category {
  final String id;
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
    Category temp = Category(
      id: map['_id'] ?? '',
      title: map['title'] ?? '',
      image: map['image'] ?? '',
    );
    return temp;
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(jsonDecode(source));
}


// List<Map<String, dynamic>> categoriess = [
//   {"title": "Wearable"},
//   {"title": "Laptop"},
//   {"title": "Phones"},
//   {"title": "Clock"},
//   {"title": "Smartphone"},
//   {"title": "Fashion"},
//   {"title": "Computers"},
//   {"title": "Shoes"},
//   {"title": "Drones"},
// ];