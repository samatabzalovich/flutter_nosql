
class Category{
  late final int id;
  late final String name;
  late final String image;

  Category({required this.id,required this.name,required this.image});

  Map<String, dynamic> toMap()
  {
    return {
      'id' :id,
      'name' : name,
      'image': image,
    };
  }
  Category.fromMap(dynamic map){
    id = map['id'];
    name = map['name'];
    image = map['image'];
  }

  Category toEntity() => Category(
      id: id,
      name: name,
    image: image,
  );


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