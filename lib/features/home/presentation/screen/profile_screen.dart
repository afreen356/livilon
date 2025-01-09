// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   Color btnClr = const Color.fromRGBO(121, 147, 174, 1);
//   String? username;
//   String? email;
//   String? password;
//   bool isLoading = true; 

//   Future<Map<String, dynamic>?> fetchUserData() async {
//     User? currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser != null) {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection("user's")
//           .doc(currentUser.uid)
//           .get();
//       if (userDoc.exists) {
//         setState(() {
//           username = userDoc.get('username');
//           email = userDoc.get('email');
//           password = userDoc.get('password');
//           isLoading = false; 
//         });
//       }
//     }
//     return null;
//   }

//   @override
//   void initState() {
//     fetchUserData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: btnClr,
//           title: const Text(
//             'User Profile',
//             style: TextStyle(
//                 fontSize: 23, fontWeight: FontWeight.w500, color: Colors.white),
//           ),
//         ),
//         body: Stack(
//           children: [
//             Container(
//                 height: double.infinity,
//                 width: double.infinity,
//                 color: btnClr,
//                 child: Stack(
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.only(left: 130, top: 130),
//                       child: CircleAvatar(
//                         backgroundColor:
//                             Color.fromARGB(255, 227, 221, 221),
//                         radius: 70,
//                         child: Icon(
//                           Icons.person,
//                           size: 120,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                     Stack(children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 250),
//                         child: Container(
//                           decoration: const BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(50),
//                                   topRight: Radius.circular(50))),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 300, left: 30),
//                         child: Column(
//                                 children: [
//                                   if (username != null &&
//                                       email != null &&
//                                       password != null) ...[
//                                     ProfileDetailTile(
//                                       icon: Icons.person,
//                                       title: "Username",
//                                       subtitle: username!,
//                                     ),
//                                     ProfileDetailTile(
//                                       icon: Icons.email,
//                                       title: "Email Address",
//                                       subtitle: email!
//                                     ),
//                                     ProfileDetailTile(
//                                       icon: Icons.lock,
//                                       title: "Password",
//                                       subtitle: '*******'
//                                     ),                                   
//                                   ]
//                                 ],                   
//                         )                   
//                         )                       
//                   ]
//                     )
//                   ]
//                 )
//             )
//           ]
//         )
//     );
//   }
// }

// class ProfileDetailTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;

//   ProfileDetailTile({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.blue),
//       title: Text(title),
//       subtitle: Text(subtitle),
//     );
//   }
// }

