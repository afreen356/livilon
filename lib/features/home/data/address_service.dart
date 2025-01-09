import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livilon/features/home/domain/model/addressmodel.dart';
import 'package:livilon/features/home/domain/repository/address.dart';

class ShippingAddressImplement implements ShippingAddress {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> saveAddress(AddressModel address) async {
    User? user = firebaseAuth.currentUser;

    if (user != null) {
      try {
        await firestore
            .collection("user's")
            .doc(user.uid)
            .collection('address')
            .add({
          'id': address.id,
          'fullName': address.fullName,
          'phoneNo': address.phoneNo,
          'pincode': address.pincode,
          'city': address.city,
          'state': address.state
        });
      } catch (e) {
        throw Exception('failed to save$e');
      }
    }
  }

  Future<bool> hasAdresses(String userID)async{
    final snapshot = await fetchAddress(userID).first;
    return snapshot.docs.isNotEmpty;

  }
@override
  Stream<QuerySnapshot<Object?>> fetchAddress(String userId) {
    User? user = firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
          code: "USER_NOT_LOGGED_IN", message: "User must be logged in");
    }
    // if (user.uid != userId) {
    //   throw Exception("Cannot fetch addresses for another user");
    // }
    // fetchAddress(userId);
    return firestore
        .collection("user's")
        .doc(user.uid)
        .collection('address')
        .snapshots();
  }
  @override
  Future<void> updateAddress(AddressModel address)async{
     User? user = firebaseAuth.currentUser;
     if (user!=null) {
       try {
         await firestore.collection("user's").doc(user.uid).collection('address').doc(address.id).update({
           'fullName': address.fullName,
          'phoneNo': address.phoneNo,
          'pincode': address.pincode,
          'city': address.city,
          'state': address.state
         });
       } catch (e) {
          throw Exception('failed to update $e');
       }
     }
  }
  @override
   Future<void> deleteAddress(AddressModel address) async {
    User? user = firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
          code: "USER_NOT_LOGGED_IN", message: "User must be logged in");
    }

    try {
      await firestore
          .collection("user's")
          .doc(user.uid)
          .collection("address")
          .doc(address.id)
          .delete();
    } catch (e) {
      throw Exception("failed to delete$e");
    }
  }
}
