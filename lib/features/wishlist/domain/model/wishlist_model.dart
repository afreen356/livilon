

class FavouriteModel {
  final String productId;
  final String favouriteid; 
  final String? imageUrl; 
  final String? name;   
  final String? description;  
  final String? price;

  FavouriteModel({
    required this.productId,
    required this.favouriteid,
    this.description,
    this.imageUrl,
    this.name,     
    required this.price,
  });   

  // Factory method to create a FavouriteModel from a map
  // factory FavouriteModel.fromMap(String id, Map<String, dynamic> data) {
  //   return FavouriteModel(
  //     productId: id,
  //     favouriteId: data['id'] ?? '', // Ensure no null value
  //     name: data['name'] ?? '',
  //     description: data['description'] ?? '',
  //     price: (data['price'] ?? 0).toDouble(),
  //     imageUrl: data['imageUrl'] ?? '', // Ensure consistent usage
  //   );
  // }

  // // Method to convert a FavouriteModel to a map (e.g., for Firestore)
  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': favouriteId,
  //     'name': name,
  //     'description': description,
  //     'price': price,
  //     'imageUrl': imageUrl, // Consistent naming
  //   };
  // }
}

