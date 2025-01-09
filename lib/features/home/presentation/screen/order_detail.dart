import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livilon/components/categorybox.dart';
import 'package:livilon/features/auth/presentation/widgets/text.dart';
import 'package:livilon/features/home/presentation/screen/checkout_screen.dart';
import 'package:livilon/features/home/presentation/widget/text.dart';

class OrderDetail extends StatelessWidget {
  const OrderDetail({
    super.key,
    required this.orders,
    required this.cartItems,
    required this.addressMap,
  });

  final QueryDocumentSnapshot<Object?> orders;
  final List<dynamic> cartItems;
  final Map<String, dynamic> addressMap;

  @override
  Widget build(BuildContext context) {
    final timestamp = orders['timestamp'];
    DateTime date = timestamp.toDate();
    String formattedDate = DateFormat('MMMM d, yyyy').format(date);

    double totalPrice = 0.0;
    for (var cartItem in cartItems) {
      final price = double.tryParse(cartItem['price'].toString());
      final quantity = cartItem['quantity'] is int ? cartItem['quantity'] : 1;
      totalPrice += (price ?? 0.0) * quantity;
    }

    return Scaffold(
      backgroundColor: getScaffoldColor(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: customCategoryAppbar(
          'Order History',
          context,
          bgColor: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            orderSummary(orders),
            const SizedBox(height: 15),
            shippingAddress(addressMap),
            const SizedBox(height: 15),
            orderDetails(orders, cartItems, formattedDate),
            const SizedBox(height: 15),
            paymentDetails(cartItems, totalPrice, orders['totalAmount']),
          ],
        ),
      ),
    );
  }

  Widget orderSummary(QueryDocumentSnapshot<Object?> orders) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.white, blurRadius: 1, spreadRadius: 1)
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Text('ORDER ID'),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20, top: 10),
                child: Text('Total'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(orders['orderId']),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text('₹${orders['totalAmount'].toString()}'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget shippingAddress(Map<String, dynamic> addressMap) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.white, blurRadius: 1, spreadRadius: 1)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: customText('Shipping Address'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              addressMap['name'],
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "${addressMap['city']}, ${addressMap['state']} - ${addressMap['pinNo'] ?? 671124}",
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "${addressMap['phoneNo']}",
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget orderDetails(
    QueryDocumentSnapshot<Object?> orders,
    List<dynamic> cartItems,
    String formattedDate,
  ) {
    return Container(
    
      width: double.infinity,
      decoration:  BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow:const [
          BoxShadow(color: Colors.white, blurRadius: 1, spreadRadius: 1)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Text('Amount Paid: ₹${orders['totalAmount']}'),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: customText('${cartItems.length} Item(s)'),
          ),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('Package Ordered On'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              formattedDate,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 20),
          for (var cartItem in cartItems)
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                height: 70,
                  decoration: const BoxDecoration(
                   
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      cartItem['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartItem['productName'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Qty: ${cartItem['quantity']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '₹${orders['totalAmount']}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget paymentDetails(
    List<dynamic> cartItems,
    double totalPrice,
    dynamic totalAmount,
  ) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.white, blurRadius: 1, spreadRadius: 1)
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextCustom(
            text: "Payment Details",
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextCustom(
                text: "Items (${cartItems.length})",
                fontSize: 17,
              ),
              TextCustom(
                text: "₹$totalPrice",
                fontSize: 17,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextCustom(text: "Shipping"),
              TextCustom(text: "₹40"),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextCustom(text: "Discount"),
              TextCustom(
                text: "(-)₹0",
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextCustom(
                text: "Total Amount",
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              customText(
                "₹${totalAmount ?? '0'}",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
