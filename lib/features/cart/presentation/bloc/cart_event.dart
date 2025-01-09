abstract class CartEvent {}

class AddtoCartEvent extends CartEvent {
  final String productId;
  final String productName;
  final String productPrice;
  final int productQuantity;
  final String image;
  final List<String> dimensions;

  AddtoCartEvent(
      {
        required this.productId,
      required this.productName,
      required this.productPrice,
      required this.productQuantity,
      required this.image,
      required this.dimensions
      });
}

class FetchCartEvent extends CartEvent{

}

class RemoveCartItemEvent extends CartEvent {
final String cartId;
  RemoveCartItemEvent({required this.cartId});
}

class IncrementQuantityEvent extends CartEvent{
final String productId;
  IncrementQuantityEvent({required this.productId});
}

class DecrementQuantityEvent extends CartEvent{
final String productId;
  DecrementQuantityEvent({required this.productId});
}
class ClearCartEvent extends CartEvent{

}
