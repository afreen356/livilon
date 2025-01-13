import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/auth/presentation/widgets/text.dart';
import 'package:livilon/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:livilon/features/cart/presentation/bloc/cart_event.dart';
import 'package:livilon/features/cart/presentation/bloc/cart_state.dart';
import 'package:livilon/features/home/presentation/screen/address/view_address.dart';
import 'package:livilon/features/home/presentation/screen/detail_screen.dart';
import 'package:livilon/features/home/presentation/screen/dimension_screen.dart';
import 'package:livilon/features/home/presentation/screen/home_screen.dart';
import 'package:livilon/features/home/presentation/widget/text.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  static const double shippingCharges = 40.00;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    context.read<CartBloc>().add(FetchCartEvent());
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      if (state is CartLoadingState) {
        log('loaded state');
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'My Cart',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (state is CartLoadedSuccessState) {
        log("Cart Loaded Successfully with items: ${state.cartItems}");
        log("Current state: $state");
        final cartList = state.cartItems;
        if (cartList.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey[50],
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomePage()));
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text(
                'Bag',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Image(
                    image: AssetImage('assets/bag.png'),
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Your home is waiting",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "for the best furniture  and decor ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: screenWidth * 0.6,
                    decoration: BoxDecoration(
                        color: getButtonColor(),
                        borderRadius: BorderRadius.circular(2)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>const HomePage()));
                      },
                      child: const Text(
                        "Start Shopping now !",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              backgroundColor: Colors.grey[50],
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomePage()));
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text(
                'Bag',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartList.length,
                    itemBuilder: (context, index) {
                      final cartItems = cartList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DetailScreen(productId:cartItems['productId'] )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: Colors.grey.withOpacity(0.2)),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, 
                                  children: [
                                    ClipRRect(
                                      
                                      borderRadius: BorderRadius.circular(8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          cartItems['image'] ??
                                              "default image url",
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.cover,
                                          height: 80,
                                          width: 80,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Center(
                                                child:
                                                    Text("Image not available"));
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0), // Add spacing
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment
                                              .center, // Align to center
                                          children: [
                                            title('Livilon'),
                                            const SizedBox(height: 5),
                                            productName(
                                                cartItems['productName'] ??
                                                    'unnamed product'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10), // Adjust left padding
                                      child: Center(
                                        // Align price vertically to center
                                        child: productPrice(
                                            '₹ ${cartItems['price']}'.toString()),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Divider(
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          context.read<CartBloc>().add(
                                              RemoveCartItemEvent(
                                                  cartId: cartItems['cartId']));
                                        },
                                        child: const Text(
                                          "Remove",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 14),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.4)),
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                context.read<CartBloc>().add(
                                                    DecrementQuantityEvent(
                                                        productId: cartItems[
                                                            'productId']));
                                              },
                                              child: const Icon(Icons.remove,
                                                  color: Colors.red, size: 20),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              cartItems['count']?.toString() ??
                                                  '1',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                context.read<CartBloc>().add(
                                                    IncrementQuantityEvent(
                                                        productId: cartItems[
                                                            'productId']));
                                              },
                                              child: const Icon(Icons.add,
                                                  color: Colors.green, size: 20),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 3,
                      spreadRadius: 2,
                    )
                  ]),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: customText('Price Details'),
                      ),
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          final itemCount = state is CartLoadedSuccessState
                              ? getTotalQuantity(state)
                              : 0;
                          final totalSum = state is CartLoadedSuccessState
                              ? getTotalSum(state)
                              : 0.0;
                          return ListTile(
                            title: Text('Items($itemCount)'),
                            trailing: Text('₹$totalSum'),
                          );
                        },
                      ),
                      const ListTile(
                        title: Text('Shipping'),
                        trailing: Text('₹$shippingCharges'),
                      ),
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          final totalPrice = state is CartLoadedSuccessState
                              ? getTotalSum(state)
                              : 0.0;
                          return ListTile(
                            title: customText('Order Total'),
                            trailing:
                                customText('₹${totalPrice + shippingCharges}'),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          final cartSTate = context.read<CartBloc>().state
                              as CartLoadedSuccessState;
                          final totalPrice =
                              getTotalSum(cartSTate) + shippingCharges;
                          final cartData = {
                            'totalAmount': totalPrice.toInt(),
                            'cartItems': cartSTate.cartItems.map((item) {
                              return {
                                'pdouctName':
                                    item['productName'] ?? 'unknown product',
                                'price': item['price'] ?? 0,
                                'quantity': item['count'] ?? 'N/A',
                                'dimensions': item['dimensions'] ?? [],
                                'image': item['image'] ?? 'default image',
                              };
                            }).toList(),
                          };
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Viewaddress(
                                    userId: userId,
                                    cartData: cartData,
                                  )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: addButton('Proceed'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'My Cart',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          body: const Center(
            child: Text("Something went wrong."),
          ),
        );
      }
    });
  }

  double getTotalSum(CartLoadedSuccessState state) {
    return state.cartItems.fold(0.0, (sum, item) {
      int quantity = item['count'] ?? 1;
      double price = double.tryParse(item['price'].toString()) ?? 0;
      return sum + (price * quantity);
    });
  }

  int getTotalQuantity(CartLoadedSuccessState state) {
    return state.cartItems.fold(0, (sum, item) {
      int quantity = item['count'] ?? 1;
      return sum + quantity;
    });
  }
}
