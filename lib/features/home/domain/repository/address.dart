import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livilon/features/home/domain/model/addressmodel.dart';

abstract class ShippingAddress{
 Future<void>saveAddress(AddressModel address);
 Stream<QuerySnapshot> fetchAddress(String userId);
  Future<void> deleteAddress(AddressModel address);
  Future<void> updateAddress(AddressModel address);

}