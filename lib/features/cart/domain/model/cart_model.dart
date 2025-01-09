// import 'package:livilon/features/home/domain/model/dimensionmodel.dart';

class CartModel {
  final String? productid;
  final String? cartid;
  final int? count;
  final String? imageUrl;
  final String? name; 
  final String? price;
  final List<String> dimensions;

  CartModel({
    required this.productid,
    required this.cartid,
    required this.count,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.dimensions
});
}