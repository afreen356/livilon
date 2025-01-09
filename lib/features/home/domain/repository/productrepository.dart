import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livilon/features/home/domain/model/productmodel.dart';


class ProductRepository{
   
   Future<List<Productmodel>> fetchProducts() async {
    final firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('Products').get();

      return snapshot.docs.map((doc) {
        return Productmodel.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

 
}