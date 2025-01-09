import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:livilon/features/cart/domain/repository/cart_repository.dart';
import 'package:livilon/features/cart/presentation/bloc/cart_event.dart';
import 'package:livilon/features/cart/presentation/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc(this.cartRepository) : super(CartInitialState()) {
    debugPrint('CartBloc Initialized');
    on<AddtoCartEvent>(addtoCartEvent);
    on<FetchCartEvent>(fetchCartEvent);
    on<RemoveCartItemEvent>(removeCartItemEvent);
    on<IncrementQuantityEvent>(incrementQuantityEvent);
    on<DecrementQuantityEvent>(decrementQuantityEvent);
    on<ClearCartEvent>(clearCartEvent);
  }

  FutureOr<void> addtoCartEvent(
      AddtoCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      log('Bloc 1');
      await cartRepository.addToCart(event.productId, event.productName,
          event.productPrice, event.productQuantity, event.image,event.dimensions);
          log('Bloc 2');
      final cartItems = await cartRepository.fetchCart();
      log('Bloc 3');
      emit(CartLoadedSuccessState(cartItems));
    } catch (e) {
    
      emit(CartErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> fetchCartEvent(
      FetchCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      final cartItems = await cartRepository.fetchCart();
       if (cartItems.isNotEmpty) {
      emit(CartLoadedSuccessState(cartItems));
    } else {
      emit(CartLoadedSuccessState([]));
    }
      
    } catch (e) {
      log("errror fetching");
      emit(CartErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> removeCartItemEvent(
      RemoveCartItemEvent event, Emitter<CartState> emit) async {
    if (state is CartLoadedSuccessState) {
      final currentState = state as CartLoadedSuccessState;
      final updatedCartItems =
          List<Map<String, dynamic>>.from(currentState.cartItems);

      updatedCartItems.removeWhere((item) => item['cartId'] == event.cartId);

      emit(CartLoadedSuccessState(updatedCartItems));
      try {
        await cartRepository.deleteCartItem(event.cartId);
      } catch (e) {
        emit(CartErrorState(errorMessage: e.toString()));

        final fetchedCartItems = await cartRepository.fetchCart();
        emit(CartLoadedSuccessState(fetchedCartItems));
      }
    }
  }

  FutureOr<void> incrementQuantityEvent(
      IncrementQuantityEvent event, Emitter<CartState> emit) {
    if (state is CartLoadedSuccessState) {
      final currentState = state as CartLoadedSuccessState;
      final updatedCartItems =
          List<Map<String, dynamic>>.from(currentState.cartItems);

      final index = updatedCartItems
          .indexWhere((item) => item['productId'] == event.productId);
      if (index != -1) {
        final updatedItem = Map<String, dynamic>.from(updatedCartItems[index]);
        int currentQuantity = updatedItem['count'] ?? 1;
        updatedItem['count'] = currentQuantity + 1;
        updatedCartItems[index] = updatedItem;

        emit(CartLoadedSuccessState(updatedCartItems));
      }
    }
  }

  FutureOr<void> decrementQuantityEvent(
      DecrementQuantityEvent event, Emitter<CartState> emit) {
    if (state is CartLoadedSuccessState) {
      final currentState = state as CartLoadedSuccessState;
      final updatedCartItems =
          List<Map<String, dynamic>>.from(currentState.cartItems);

      final index = updatedCartItems
          .indexWhere((item) => item['productId'] == event.productId);
      if (index != -1) {
        final updatedItem = Map<String, dynamic>.from(updatedCartItems[index]);
        int currentQuantity = updatedItem['count'] ?? 1;

        if (currentQuantity > 1) {
          updatedItem['count'] = currentQuantity - 1;
          updatedCartItems[index] = updatedItem;

          emit(CartLoadedSuccessState(updatedCartItems));
        }
      }
    }
  }

  FutureOr<void> clearCartEvent(
      ClearCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      await cartRepository.clearCart();
      emit(CartLoadedSuccessState([]));
    } catch (e) {
      emit(CartErrorState(errorMessage: e.toString()));
    }
  }
}
