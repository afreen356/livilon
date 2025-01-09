class Productmodel {
  final String id;
  final String name;
  final String category;
  final String description;
  final String price;
  final List<dynamic> dimensions;
  final List<dynamic> images;

  Productmodel(
      {required this.id,
      required this.name,
      required this.category,
      required this.description,
      required this.price,
    required this.dimensions,
      required this.images});


factory Productmodel.fromMap(String id, Map<String, dynamic> data) {
    return Productmodel(
      id: id,
      name: data['name'] ?? '',
      category: data['category']??'',
      description: data['description'],
      price: (data['price'] ?? 0),
      dimensions: data['dimensions'],
      images: data['image'] ?? '',
      
    );
  }
}

