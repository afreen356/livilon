import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livilon/components/addressbook.dart';
import 'package:livilon/features/auth/presentation/widgets/text.dart';
import 'package:livilon/features/home/data/address_service.dart';
import 'package:livilon/features/home/domain/model/addressmodel.dart';
import 'package:livilon/features/home/presentation/screen/address/view_address.dart';
import 'package:livilon/features/home/presentation/widget/appbar.dart';
import 'package:livilon/features/home/presentation/widget/snackbar.dart';
import 'package:livilon/features/home/presentation/widget/text.dart';

class AddressPage extends StatelessWidget {
  AddressPage({super.key});

  final nameController = TextEditingController();

  final phonController = TextEditingController();

  final pinController = TextEditingController();

  final cityController = TextEditingController();

  final stateController = TextEditingController();
  final ShippingAddressImplement addressRepo = ShippingAddressImplement();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: customAddressAppbar('Address Book', context)),
      body: Form(
        key: formkey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  left: 30,
                ),
                child: Text(
                  'Add Your Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: customAddressText('Full Name'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: CustomAddressForm(
                    validator: (value) => validateFullName(value),
                    controller: nameController,
                    hintText: 'Enter your Full Name'),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: customAddressText('Phone Number'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: CustomAddressForm(
                  keyboardType: TextInputType.phone,
                    validator: (value) => validatePhoneNumber(value),
                    controller: phonController,
                    hintText: '8129462164'),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: customAddressText('Pincode'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: CustomAddressForm(
                  keyboardType: TextInputType.number,
                    validator: (value) => validatePincode(value),
                    controller: pinController,
                    hintText: 'Enter pincode'),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: customAddressText('City'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 150),
                    child: customAddressText('State'),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: CustomAddressForm(
                          validator: (value) => validateLocation(value, 'city'),
                          controller: cityController,
                          hintText: 'Enter your city'),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: CustomAddressForm(
                          validator: (value) => validateLocation(value, 'state'),
                          controller: stateController,
                          hintText: 'Enter your state'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                  child: GestureDetector(
                      onTap: () async {
                        if (formkey.currentState!.validate()) {
                          final data = AddressModel(
                              id: userId,
                              fullName: nameController.text,
                              phoneNo: phonController.text,
                              pincode: pinController.text,
                              city: cityController.text,
                              state: stateController.text);
                          await addressRepo.saveAddress(data);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>  Viewaddress(userId: userId,)));
                           showCustomSnackbar(context, 'Address succesfully added', Colors.green);
                          return;
                        }
                      },
                      child: addButton("Add New Address")))
            ],
          ),
        ),
      ),
    );
  }
}
