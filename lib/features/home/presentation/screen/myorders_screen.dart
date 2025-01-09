import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livilon/components/categorybox.dart';
import 'package:livilon/features/auth/presentation/widgets/text.dart';
import 'package:livilon/features/cart/presentation/bloc/cart_state.dart';
import 'package:livilon/features/home/data/order_service.dart';
import 'package:livilon/features/home/domain/repository/order.dart';
import 'package:livilon/features/home/presentation/screen/checkout_screen.dart';
import 'package:livilon/features/home/presentation/screen/order_detail.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final OrderRepository orderRepository = OrderRepositoryImplementation();
    return Scaffold(
        backgroundColor: getScaffoldColor(),
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: customCategoryAppbar('Order History', context,bgColor: Colors.transparent)),
        body: FutureBuilder(
            future: orderRepository.fetchOrderDetails(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: customText('All Orders'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/sticker-removebg-preview.png',
                        height: 300,
                        width: 300,
                      ),
                    ),
                    const Center(
                        child: Text(
                      'No orders found!!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ))
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ordersList(snapshot.data!.docs),
                );
              }
            }));
  }

  Widget ordersList(List<dynamic> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final orderData = order.data() as Map<String, dynamic>;
        return OrderCard(
          orderData: orderData,
          order: order,
        );
      },
    );
  }
}


class OrderCard extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final dynamic order;

  const OrderCard({required this.orderData, required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    final addressMap = orderData['address'] as Map<String, dynamic>;
    final cartItems = orderData['cartItems'] as List<dynamic>? ?? [];
    final orderId = orderData['orderId'] ?? 'N/A';
    final timestamp = orderData['timestamp'] ?? 'N/A';

    DateTime date = timestamp.toDate();
    String formattedDate = DateFormat('MMMM d, yyyy').format(date);

    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Adds gap between orders
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("ORDER ID"),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderDetail(
                        cartItems: cartItems,
                        orders: order,
                        addressMap: addressMap,
                      ),
                    ));
                  },
                  child: button(),
                ),
              ],
            ),
            customText(
              "$orderId",
            ),
            const SizedBox(height: 15),
            customText('${cartItems.length} Item(s)'),
            Text('Package ordered on $formattedDate'),
            const SizedBox(height: 10),
            if (cartItems.isNotEmpty)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: cartItems.map((item) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        item['image'] ?? '',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget button() {
    return Container(
      width: 100,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.grey.withOpacity(0.4),
        ),
      ),
      child: const Center(
        child: Text(
          'Order Details',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  int getTotalQuantity(CartLoadedSuccessState state) {
    return state.cartItems.fold(0, (sum, item) {
      int quantity = item['count'] ?? 1;
      return sum + quantity;
    });
  }
}

