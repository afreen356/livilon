import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livilon/features/wishlist/domain/model/wishlist_model.dart';

import 'package:livilon/features/wishlist/domain/repository/wishlist_repository.dart';

 class FavouritesRepositoryImplementation implements FavouriteRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addFavouriteService(FavouriteModel favourite) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      print("Error: User must be logged in to add favourites.");
      return;
    }

    try {
      await _firestore
          .collection("user's")
          .doc(user.uid)
          .collection("wishlist")
          .doc(favourite.favouriteid)
          .set({
        "id": favourite.favouriteid,
        "name": favourite.name,
        "price": favourite.price.toString(),
        "image": favourite.imageUrl,
        "productId": favourite.productId,
      });
      log(
          "Added favourite with ID: ${favourite.favouriteid} for user: ${user.uid}");
    } catch (e) {
      log("Error adding favourite: $e");
    }
  }

    Future<void> removeFavouriteService(String favouriteId) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      log("Error: User must be logged in to remove favourites.");
      return;
    }

    try {
      await _firestore
          .collection("user's")
          .doc(user.uid)
          .collection("wishlist")
          .doc(favouriteId)
          .delete();
      log(
          "Successfully removed favourite with ID: $favouriteId for user: ${user.uid}");
    } catch (e) {
      log("Error removing favourite: $e");
    }
  }
   Future<List<FavouriteModel>> getFavouriteService() async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      log("Error: User must be logged in to view favourites.");
      return [];
    }

    try {
      final querySnapshot = await _firestore
          .collection("user's")
          .doc(user.uid)
          .collection("wishlist")
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return FavouriteModel(
          favouriteid: doc.id,
          name: data['name'] ,
          price: data['price'].toString() ,
          imageUrl: data['image'] ,
          productId: data['productId'] ,
        );
      }).toList();
    } catch (e) {
      log("Error fetching favourites: $e");
      return [];
    }
  }


}