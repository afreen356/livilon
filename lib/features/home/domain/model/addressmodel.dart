import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String id;
  final String fullName;
  final String phoneNo;
  final String pincode;
  final String city;
  final String state;

  AddressModel(
      {required this.id,
      required this.fullName,
      required this.phoneNo,
      required this.pincode,
      required this.city,
      required this.state});

  Map<String, dynamic> toJson() {
    return {
      id: 'id',
      fullName: 'fullName',
      phoneNo: 'phoneNo',
      pincode: 'pincode',
      city: 'city',
      state: 'state'
    };
  }

  factory AddressModel.fromJSon(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return AddressModel(
        id: doc.id,
        fullName: json['fullName'],
        phoneNo: json['phoneNo'],
        pincode: json['pincode'],
        city: json['city'],
        state: json['state']);
  }
  
}
