

import 'package:livilon/features/wishlist/domain/model/wishlist_model.dart';

abstract class FavouriteState {}

class FavouriteInitial extends FavouriteState {}

class FavouriteLoading extends FavouriteState {}

class FavouriteSuccess extends FavouriteState {
  final List<FavouriteModel> favourites;

  FavouriteSuccess(this.favourites);
}

class FavouriteError extends FavouriteState {
  final String message;

  FavouriteError(this.message);
}