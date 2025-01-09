import 'package:livilon/features/wishlist/domain/model/wishlist_model.dart';


abstract class FavouriteRepository {
  Future<void> addFavouriteService(FavouriteModel favorite);
  Future<void> removeFavouriteService(String docId);
  Future<List<FavouriteModel>> getFavouriteService();
}