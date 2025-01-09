
import 'package:livilon/features/wishlist/domain/model/wishlist_model.dart';

abstract class FavouriteEvent {}
class LoadFavouritesEvent extends FavouriteEvent{}

class AddFavouriteEvent extends FavouriteEvent {
  final FavouriteModel favourite;

  AddFavouriteEvent(this.favourite);
}

class RemoveFavouriteEvent extends FavouriteEvent {
  final String favouriteId;

  RemoveFavouriteEvent(this.favouriteId);
}