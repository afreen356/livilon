import 'dart:developer';
import 'dart:js' as js;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:livilon/features/cart/presentation/bloc/cart_state.dart';
import 'package:livilon/features/home/domain/model/addressmodel.dart';
import 'package:livilon/features/home/presentation/screen/address/add_address.dart';
import 'package:livilon/features/home/presentation/screen/dimension_screen.dart';
import 'package:livilon/features/home/presentation/screen/home_screen.dart';
import 'package:livilon/features/home/presentation/screen/payment_screen.dart';
import 'package:livilon/features/home/presentation/widget/text.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

// ignore: must_be_immutable
class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Map<String, Object>? cartData;
  late AddressModel address;

  CheckoutPage({
    super.key,
    required this.address,
    required this.cartData,
    required this.cartItems,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

Color getScaffoldColor() {
  return Colors.grey.shade200;
}

void openRazorpayWeb({
  required String key,
  required double amount,
  required String name,
  required String description,
  required String prefillEmail,
  required String prefillContact,
  required Function(String) onSuccess,
  required Function(String) onFailure,
}) {
  final options = js.JsObject.jsify({
    'key': key,
    'amount': (amount * 100).toInt(), // Convert to paisa
    'name': name,
    'description': description,
    'prefill': {
      'email': prefillEmail,
      'contact': prefillContact,
    },
    'handler': js.allowInterop((response) {
      onSuccess(response['razorpay_payment_id']);
    }),
    'modal': js.JsObject.jsify({
      'ondismiss': js.allowInterop(() {
        onFailure('Payment dismissed by user');
      }),
    }),
  });

  final razorpay = js.context['Razorpay'];
  if (razorpay != null) {
    final rzp = js.JsObject(razorpay, [options]);
    rzp.callMethod('open');
  } else {
    onFailure('Razorpay is not available on the web');
  }
}

final Razorpay razorpay = Razorpay();

const double shippingCharges = 40.00;

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    return Scaffold(
      backgroundColor: getScaffoldColor(),
      appBar: AppBar(
        title: const Text('My Checkout'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text(
                                'Shipping address',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                widget.address.fullName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "${widget.address.city}, ${widget.address.state} - ${widget.address.pincode}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Mobile: ${widget.address.phoneNo}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Divider(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    'Add a new address',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: getButtonColor()),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddressPage()));
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey.withOpacity(0.3),
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.cartItems.length,
                      itemBuilder: (context, index) {
                        var items = widget.cartItems[index];
                        int quantity = items['count'] ?? 1;
                        int? basePrice = int.tryParse(items['price'] ?? '0');
                        int totalPrice = basePrice! * quantity;

                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Image Section
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      items['image'] ?? "default image url",
                                      filterQuality: FilterQuality.high,
                                      fit: BoxFit.cover,
                                      height: 80,
                                      width: 80,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Center(
                                            child: Text("Image not available"));
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Details Section
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        title('Livilon'),
                                        const SizedBox(height: 5),
                                        productName(items['productName'] ??
                                            'Unnamed Product'),
                                        Text(items['dimensions'].toString()),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Price Section
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      productPrice('₹ $totalPrice'),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'Qty: $quantity',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),

                           
                            if (index != widget.cartItems.length - 1)
                              Divider(
                                color: Colors.grey.withOpacity(0.3),
                                thickness: 1,
                                // height: 20,
                                indent: 12,
                                endIndent: 12,
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          final totalPrice = state is CartLoadedSuccessState
                              ? getTotalSum(state) + shippingCharges
                              : 0.0;
                          return Text(
                            '₹$totalPrice',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      const Text(
                        'Inclusive of all taxes',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (kIsWeb) {
                        openRazorpayWeb(
                          key: 'rzp_test_AAOvWXA6IXusAo',
                          amount:50,
                          name: 'Acme Corp.',
                          description: 'Fine T-Shirt',
                          prefillEmail: 'test@razorpay.com',
                          prefillContact: '8888888888',
                          onSuccess: (paymentId) {
                            // Navigate to payment success screen
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const PaymentSuccess()),
                            );
                            log('Web Payment Success: $paymentId');
                          },
                          onFailure: (errorMessage) {
                            // Handle payment failure
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                              (route) => false,
                            );
                            log('Web Payment Failure: $errorMessage');
                          },
                        );
                      } else {
                         log('hi');
                        var options = {
                          'key': 'rzp_test_AAOvWXA6IXusAo',
                          'amount': 5000,
                          'currency': 'INR',
                          'name': 'Acme Corp.',
                          'description': 'Fine T-Shirt',
                          'prefill': {
                            'contact': '8888888888',
                            'email': 'test@razorpay.com'
                          }
                        };
                        razorpay.open(options);
                      }
                    },

                    

                    style: ElevatedButton.styleFrom(
                      backgroundColor: getButtonColor(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'CONTINUE',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isPaymentProcessed = false;
  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (isPaymentProcessed) return;
    isPaymentProcessed = true;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      double totalAmount = (widget.cartData!['totalAmount'] as num).toDouble();
      Map<String, dynamic> orderData = {
        'userId': user.uid,
        'cartItems': widget.cartItems,
        'totalAmount': totalAmount,
        'address': {
          'name': widget.address.fullName,
          'city': widget.address.city,
          'state': widget.address.state,
          'phoneNo': widget.address.phoneNo,
          'pinNo': widget.address.pincode
        },
        'orderId': '',
        'paymentId': response.paymentId,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'Pending',
      };
      try {
        final orderRef = await FirebaseFirestore.instance
            .collection("user's")
            .doc(user.uid)
            .collection('orders')
            .add(orderData);

        orderData['orderId'] = orderRef.id;
        await orderRef.update(orderData);
        QuerySnapshot cartSnap = await FirebaseFirestore.instance
            .collection("user's")
            .doc(user.uid)
            .collection('cart')
            .get();
        for (var item in cartSnap.docs) {
          await item.reference.delete();
        }
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const PaymentSuccess()));
        log('order added successfully');
      } catch (e) {
        log("Error handling payment success: $e");
      }
    }
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
    log('payment error: ${response.message}');
  }

  double getTotalSum(CartLoadedSuccessState state) {
    // ignore: avoid_types_as_parameter_names
    return state.cartItems.fold(0.0, (sum, item) {
      int quantity = item['count'] ?? 1;
      double price = double.tryParse(item['price'].toString()) ?? 0;
      return sum + (price * quantity);
    });
  }

  int getTotalQuantity(CartLoadedSuccessState state) {
    // ignore: avoid_types_as_parameter_names
    return state.cartItems.fold(0, (sum, item) {
      int quantity = item['count'] ?? 1;
      return sum + quantity;
    });
  }
}
