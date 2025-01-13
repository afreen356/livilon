import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:livilon/features/home/data/address_service.dart';
import 'package:livilon/features/home/presentation/screen/address/add_address.dart';
import 'package:livilon/features/home/presentation/screen/address/view_address.dart';
import 'package:livilon/features/home/presentation/screen/chat/chat_screen.dart';
import 'package:livilon/features/home/presentation/screen/dimension_screen.dart';
import 'package:livilon/features/auth/presentation/screen/user_login.dart';
import 'package:livilon/features/auth/presentation/widgets/text.dart';
import 'package:livilon/features/home/presentation/screen/myorders_screen.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final addressREpo = ShippingAddressImplement();
  String? username;
  String? email;

  Future<Map<String, dynamic>?> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("user's")
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          username = userDoc.get('username');
          email = userDoc.get('email');
        });
      }
    }
    return {'name': 'Guest', 'email': ''};
  }

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 200),
              child: Text(
                'Accounts',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
            Divider(
              color: Colors.grey.withOpacity(0.2),
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: getButtonColor(),
                child: Text(
                  email != null && email!.isNotEmpty
                      ? email![0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                username.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(
                email.toString(),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () async {
                final userId = FirebaseAuth.instance.currentUser!.uid;
                final snapshot = await addressREpo.fetchAddress(userId).first;
                final hasAddress = snapshot.docs.isNotEmpty;
                if (hasAddress) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Viewaddress(userId: userId)));
                } else {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => AddressPage()));
                }
              },
              child: ListTile(
                leading: const Icon(
                  Icons.list_alt_outlined,
                  color: Colors.black,
                ),
                title: customText('Address Book'),
              ),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const OrdersScreen()));
              },
              leading: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black,
              ),
              title: customText('My orders'),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChatScreen()));
              },
              leading: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.black,
              ),
              title: customText('Communication'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.payment,
                color: Colors.black,
              ),
              title: customText('Payment'),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text('Are you sure you want to login'),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      backgroundColor: getButtonColor()),
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    googleSignIn.signOut();

                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UserLoginScreen()),(Route route)=>false);
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      backgroundColor: getButtonColor()),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          ),
                        ],
                      );
                    });
              },
              child: ListTile(
                leading: const Icon(
                  Icons.logout_outlined,
                  color: Colors.black,
                ),
                title: customText('Signout'),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
