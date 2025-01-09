import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:livilon/features/cart/presentation/bloc/cart_state.dart';
import 'package:livilon/features/home/data/address_service.dart';
import 'package:livilon/features/home/domain/model/addressmodel.dart';
import 'package:livilon/features/home/presentation/bloc/address/address_bloc.dart';
import 'package:livilon/features/home/presentation/bloc/address/address_event.dart';
import 'package:livilon/features/home/presentation/bloc/address/address_state.dart';
import 'package:livilon/features/home/presentation/screen/address/add_address.dart';
import 'package:livilon/features/home/presentation/screen/address/edit_address.dart';
import 'package:livilon/features/home/presentation/screen/checkout_screen.dart';
import 'package:livilon/features/home/presentation/screen/dimension_screen.dart';
import 'package:livilon/features/home/presentation/widget/appbar.dart';
import 'package:livilon/features/home/presentation/widget/snackbar.dart';
import 'package:livilon/features/home/presentation/widget/text.dart';

// ignore: must_be_immutable
class Viewaddress extends StatelessWidget {
  final String userId;
  late AddressModel address;
  Map<String, Object>? cartData;
  Viewaddress({super.key, required this.userId, this.cartData});

  List<dynamic> addressDocs = [];

  @override
  Widget build(BuildContext context) {
    final addressRepo = ShippingAddressImplement();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: customAddressAppbar('Address Book', context),
      ),
      body: Column(
        children: [
          _buildAddAddressRow(context),
          Divider(color: Colors.grey.withOpacity(0.2)),
          _buildAddressList(context, addressRepo),
          _buildShipToAddressButton(context),
        ],
      ),
    );
  }

  /// Add a new address .
  Widget _buildAddAddressRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Add a new address',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: getButtonColor(),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddressPage()),
            );
          },
          icon: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey.withOpacity(0.5),
            size: 20,
          ),
        ),
      ],
    );
  }

  /// list of addresses.
  Widget _buildAddressList(BuildContext context, ShippingAddressImplement addressRepo) {
    return Expanded(
      child: StreamBuilder(
        stream: addressRepo.fetchAddress(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No Address found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching address"));
          }

          addressDocs = snapshot.data!.docs;

          return BlocBuilder<AddressCheckBoxBloc, AddressChekBoxState>(
            builder: (context, addressstate) {
              return ListView.builder(
                itemCount: addressDocs.length,
                itemBuilder: (context, index) {
                  final addressDoc = addressDocs[index];
                  final address = AddressModel.fromJSon(addressDoc);
                  final isSelected = addressstate.selectedDocID == addressDoc.id;

                  return _buildAddressCard(context, address, isSelected, addressDoc.id);
                },
              );
            },
          );
        },
      ),
    );
  }

  ///  single address card.
  Widget _buildAddressCard(BuildContext context, AddressModel address, bool isSelected, String docId) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddressDetails(address),
            Divider(color: Colors.grey.withOpacity(0.2)),
            _buildAddressActions(context, address, isSelected, docId),
          ],
        ),
      ),
    );
  }

  /// Displays address details such as name, city, state, and phone number.
  Widget _buildAddressDetails(AddressModel address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            address.fullName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 7),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "${address.city}, ${address.state} - ${address.pincode}",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Mobile: ${address.phoneNo}",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  /// Displays action buttons (Edit, Delete, Set as Default) for an address.
  Widget _buildAddressActions(BuildContext context, AddressModel address, bool isSelected, String docId) {
    return Row(
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditAddress(address: address)),
              );
            },
            icon: const Icon(Icons.edit_outlined, size: 14, color: Colors.black54),
            label: const Text('Edit', style: TextStyle(fontSize: 12, color: Colors.black54)),
          ),
        ),
        const VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
        Expanded(
          child: TextButton.icon(
            onPressed: () {
              
            },
            icon: const Icon(Icons.delete, size: 14, color: Colors.black54),
            label: const Text('Delete', style: TextStyle(fontSize: 12, color: Colors.black54)),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () {
              context.read<AddressCheckBoxBloc>().add(SelectedAddressBox(docId: docId));
            },
            icon: Icon(
              Icons.check_circle,
              color: isSelected ? Colors.blue : Colors.black54,
              size: 14,
            ),
            label: const Text('Set as default', style: TextStyle(color: Colors.black54, fontSize: 12)),
          ),
        ),
      ],
    );
  }

  /// Builds the "Ship to this address" button.
  Widget _buildShipToAddressButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: GestureDetector(
        onTap: () {
          final selectedAddressID = context.read<AddressCheckBoxBloc>().state.selectedDocID;
          if (selectedAddressID == null) {
            showCustomSnackbar(context, 'Please select a delivery address', Colors.red);
          } else {
            final selectedAddressDoc = addressDocs.firstWhere((doc) => doc.id == selectedAddressID);
            final selectedAddress = AddressModel.fromJSon(selectedAddressDoc);
            final cartItems =
                (context.read<CartBloc>().state as CartLoadedSuccessState).cartItems;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CheckoutPage(
                  address: selectedAddress,
                  cartData: cartData,
                  cartItems: cartItems,
                ),
              ),
            );
          }
        },
        child: addButton('Ship to this address'),
      ),
    );
  }
}
