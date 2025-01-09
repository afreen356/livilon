import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/wishlist/domain/model/wishlist_model.dart';
import 'package:livilon/features/wishlist/domain/repository/wishlist_repository.dart';
import 'package:livilon/features/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:livilon/features/wishlist/presentation/bloc/wishlist_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final FavouriteRepository favouriteRepository;
  List<FavouriteModel> favouriteItems = [];

  FavouriteBloc(this.favouriteRepository) : super(FavouriteInitial()) {
    on<LoadFavouritesEvent>(_onLoadFavourites);
    on<AddFavouriteEvent>(_onAddFavourite);
    on<RemoveFavouriteEvent>(_onRemoveFavourite);
  }

  /// Handles loading favourites
  Future<void> _onLoadFavourites(
      LoadFavouritesEvent event, Emitter<FavouriteState> emit) async {
    emit(FavouriteLoading());
    try {
      favouriteItems = await favouriteRepository.getFavouriteService();
      emit(FavouriteSuccess(List.from(favouriteItems))); // Emit success with items
    } catch (e) {
      emit(FavouriteError('Failed to load favourites: ${e.toString()}'));
    }
  }

  /// Handles adding a favourite
  Future<void> _onAddFavourite(
      AddFavouriteEvent event, Emitter<FavouriteState> emit) async {
    try {
      await favouriteRepository.addFavouriteService(event.favourite);
      favouriteItems.add(event.favourite); // Update the local list
      emit(FavouriteSuccess(List.from(favouriteItems))); // Emit updated list
    } catch (e) {
      emit(FavouriteError('Failed to add favourite: ${e.toString()}'));
    }
  }

  /// Handles removing a favourite
  Future<void> _onRemoveFavourite(
      RemoveFavouriteEvent event, Emitter<FavouriteState> emit) async {
    try {
      await favouriteRepository.removeFavouriteService(event.favouriteId);
      favouriteItems.removeWhere(
          (item) => item.favouriteid == event.favouriteId); // Corrected key
      emit(FavouriteSuccess(List.from(favouriteItems))); // Emit updated list
    } catch (e) {
      emit(FavouriteError('Failed to remove favourite: ${e.toString()}'));
    }
  }
}
