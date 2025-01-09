// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:livilon/components/addressbook.dart';
import 'package:livilon/features/auth/presentation/widgets/text.dart';
import 'package:livilon/features/home/data/address_service.dart';
import 'package:livilon/features/home/domain/model/addressmodel.dart';
import 'package:livilon/features/home/presentation/screen/address/view_address.dart';
import 'package:livilon/features/home/presentation/widget/appbar.dart';
import 'package:livilon/features/home/presentation/widget/snackbar.dart';
import 'package:livilon/features/home/presentation/widget/text.dart';

class EditAddress extends StatefulWidget {
  final AddressModel address;

  const EditAddress({super.key, required this.address});

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _pinController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address.fullName);
    _phoneController = TextEditingController(text: widget.address.phoneNo);
    _pinController = TextEditingController(text: widget.address.pincode);
    _cityController = TextEditingController(text: widget.address.city);
    _stateController = TextEditingController(text: widget.address.state);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _updateAddress() async {
    if (_formKey.currentState!.validate()) {
      ShippingAddressImplement addressRepo = ShippingAddressImplement();

      try {
        await addressRepo.updateAddress(
          AddressModel(
            id: widget.address.id,
            fullName: _nameController.text,
            phoneNo: _phoneController.text,
            pincode: _pinController.text,
            city: _cityController.text,
            state: _stateController.text,
          ),
        );

        showCustomSnackbar(context, 'Address successfully updated', Colors.green);

        
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => Viewaddress(userId: widget.address.id),
            ),
            (route) => false,
          );
        }
      } catch (e) {
        
        showCustomSnackbar(context, "Failed to edit address: $e", Colors.red);
      }
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: customAddressText(label),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: CustomAddressForm(
            controller: controller,
            hintText: hintText,
            validator: validator,
            keyboardType: keyboardType,
          ),
        ),
      ],
    );
  }

  Widget _buildRowFields() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: CustomAddressForm(
              controller: _cityController,
              hintText: 'Enter your city',
              validator: (value) => validateLocation(value, 'city'),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CustomAddressForm(
              controller: _stateController,
              hintText: 'Enter your state',
              validator: (value) => validateLocation(value, 'state'),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: customAddressAppbar('Address Book', context),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  'Edit Your Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Full Name',
                controller: _nameController,
                hintText: 'Enter your Full Name',
                validator: validateFullName,
              ),
              _buildTextField(
                label: 'Phone Number',
                controller: _phoneController,
                hintText: '8129462164',
                validator: validatePhoneNumber,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                label: 'Pincode',
                controller: _pinController,
                hintText: 'Enter pincode',
                validator: validatePincode,
                keyboardType: TextInputType.number,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: customAddressText('City'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 150),
                    child: customAddressText('State'),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              _buildRowFields(),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _updateAddress,
                  child: addButton("Update Your Address"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
