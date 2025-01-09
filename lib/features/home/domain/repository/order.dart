import 'package:cloud_firestore/cloud_firestore.dart';

abstract class OrderRepository{
  Future<QuerySnapshot<Object>?> fetchOrderDetails();
}
