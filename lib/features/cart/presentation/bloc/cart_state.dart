
abstract class CartState {}

class CartInitialState extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedSuccessState extends CartState {
  final List<Map<String, dynamic>> cartItems;

  CartLoadedSuccessState(this.cartItems);
   int get itemCount => cartItems.length;
   
   
}
class CartItemAddedState extends CartState {}

class CartErrorState extends CartState {
  final String errorMessage;

  CartErrorState({required this.errorMessage});
}

class CartItemDeletedState extends CartState {}