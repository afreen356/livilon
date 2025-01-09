import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livilon/features/home/domain/repository/order.dart';

class OrderRepositoryImplementation implements OrderRepository {
  @override
  Future<QuerySnapshot<Object>> fetchOrderDetails() async{
    User? user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      try {
        final orderSnap = await FirebaseFirestore.instance
            .collection("user's")
            .doc(user.uid)
            .collection('orders')
            .get();
        return orderSnap;
      } catch (e) {
        throw Exception("Failed to fetch order details: $e");
      }
    } else {
      throw Exception("User is not logged in");
    }
    
   
  }
}
  

