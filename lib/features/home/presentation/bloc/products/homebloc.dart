 import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/home/domain/repository/productrepository.dart';
import 'package:livilon/features/home/domain/model/productmodel.dart';
import 'package:livilon/features/home/presentation/bloc/products/homeevent.dart';
import 'package:livilon/features/home/presentation/bloc/products/homestate.dart';

class HomeBloc extends Bloc<HomeEvent, Homestate> {
  ProductRepository _productRepository =ProductRepository();
  HomeBloc() :_productRepository=ProductRepository(), super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeProductWishlistButtonClickedEvent>(homeProductWishlistButtonClickedEvent);
    on<HomeProductCartButtonClickedEvent>(homeProductCartButtonClickedEvent);
    on<HomeWishlistButtonNavigateEvent>(homeWishlistButtonNavigateEvent);
    on<HomeCartButtonNavigateEvent>(homeProductCartButtonNavigateEvent);
  }

  FutureOr<void> homeInitialEvent(HomeInitialEvent event, Emitter<Homestate> emit)async {
    emit(HomeLoadinggstate());
     try {
     List<Productmodel> products = await _productRepository.fetchProducts();

      emit(HomeLoadedSuccesState(products: products));
    } catch (e) {
      log('Error: $e');
      
    }
  }
 
 FutureOr<void> homeProductWishlistButtonClickedEvent(
  HomeProductWishlistButtonClickedEvent event,Emitter<Homestate>emit){
  log('Wishlist product clicked');
 }
 FutureOr<void> homeProductCartButtonClickedEvent(
  HomeProductCartButtonClickedEvent event,Emitter<Homestate>emit){
  log('cart product clicked');
 }
  

  FutureOr<void> homeWishlistButtonNavigateEvent(
    HomeWishlistButtonNavigateEvent event, Emitter<Homestate> emit) {
      log('wishlist navigate clicked');
      emit(HomeNavigateTowishlistPageActionstate());
  }

  FutureOr<void> homeProductCartButtonNavigateEvent
  (HomeCartButtonNavigateEvent event, Emitter<Homestate> emit) {
    log('Cart navigate clicked');
    emit(HomeNavigateToCartPageActionstate());
  }
}

  




  
