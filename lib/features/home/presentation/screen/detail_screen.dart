// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:livilon/components/categorybox.dart';
import 'package:livilon/features/cart/data/cart_service.dart';
import 'package:livilon/features/cart/domain/model/cart_model.dart';
import 'package:livilon/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:livilon/features/cart/presentation/bloc/cart_event.dart';
import 'package:livilon/features/home/domain/model/dimensionmodel.dart';
import 'package:livilon/features/home/presentation/bloc/dimensions/dimension_bloc.dart';
import 'package:livilon/features/home/presentation/bloc/dimensions/dimension_state.dart';
import 'package:livilon/features/home/presentation/screen/dimension_screen.dart';
import 'package:livilon/features/home/presentation/widget/snackbar.dart';
import 'package:livilon/features/wishlist/domain/model/wishlist_model.dart';
import 'package:livilon/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:livilon/features/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:livilon/features/wishlist/presentation/bloc/wishlist_state.dart';

class DetailScreen extends StatefulWidget {
  final String productId;
  const DetailScreen({super.key, required this.productId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int currentIdx = 0;
 

  @override
  Widget build(BuildContext context) {
    final wishlistBloc = context.read<FavouriteBloc>();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: customCategoryAppbar('Product Details', context)),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Products')
              .doc(widget.productId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final productData = snapshot.data;
              final List<dynamic> images = productData!['image'] ?? [];
              final image = productData['image'][0];
              final name = productData['name'] ?? '';
              final description = productData['description'] ?? 'unknown';
              final price = productData['price']?.toString() ?? "0.00";
              return SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 350,
                          width: double.infinity,
                          child: PageView.builder(
                            itemCount: images.length,
                            onPageChanged: (index) {
                              setState(() {
                                currentIdx = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Image.network(
                                images[index],
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              images.length,
                              (index) => Container(
                                margin: const EdgeInsets.all(4.0),
                                width: currentIdx == index ? 12.0 : 8.0,
                                height: currentIdx == index ? 12.0 : 8.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentIdx == index
                                      ? const Color.fromRGBO(121, 147, 174, 1)
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(2, 2))
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child:
                                    BlocConsumer<FavouriteBloc, FavouriteState>(
                                  listener: (context, state) {},
                                  builder: (context, state) {
                                    bool isfavourite = false;
                                    if (state is FavouriteSuccess) {
                                      isfavourite = state.favourites.any(
                                          (favourite) =>
                                              favourite.productId ==
                                              widget.productId);
                                    }
                                    return IconButton(
                                      icon: Icon(
                                        isfavourite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isfavourite
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                      onPressed: () {
                                        String favid = widget.productId;
                                        if (isfavourite) {
                                          wishlistBloc
                                              .add(RemoveFavouriteEvent(favid));
                                        } else {
                                          final favourites = FavouriteModel(
                                              productId: widget.productId,
                                              name: name,
                                              favouriteid: favid,
                                              price: price,
                                              imageUrl: image);
                                          wishlistBloc.add(
                                              AddFavouriteEvent(favourites));
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: customProductName(name),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: customProductDescription(description),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: customProductPrice(
                        '₹ $price',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration:
                            const BoxDecoration(color: Color(0xFFF0F4FF)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Dimensions',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return Padding(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: DimensionsBottomSheet(),
                                        );
                                      });
                                },
                                icon: const Icon(Icons.arrow_forward_ios))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFF0F4FF),
                            )),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.headset_mic,
                              size: 36,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Talk to our furniture experts',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Consult our in-store associates for any queries regarding furniture',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: IconButton(
                                onPressed: () {
                                  FlutterPhoneDirectCaller.callNumber(
                                      '+919243337022');
                                },
                                icon: const Icon(Icons.phone, size: 24),
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 60,
                          width: 150,
                          decoration: BoxDecoration(
                            color: getButtonColor(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                            child: Text(
                              'Buy Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final dimnsionBloc = context.read<DimensionBloc>();
                            final dimensionState = dimnsionBloc.state;
                            Dimensions? dimensions;
                            if (dimensionState is DimensionAddedState) {
                              dimensions = dimensionState.dimensions;
                             }
                            else {
                              showCustomSnackbar(
                                context,
                                'Please add dimensions first!',
                                 Colors.black38
                              );
                              return;
                            }

                            final CartRepositoryImplementation
                                cartRepoImplement =
                                CartRepositoryImplementation();

                            bool isProductIncart = await cartRepoImplement
                                .isProductInCart(widget.productId);

                            if (isProductIncart) {
                             
                              showCustomSnackbar(context,
                                  'Product is already in the cart', Colors.black87);
                              return;
                            }

                            final cartItem = CartModel(
                                productid: widget.productId,
                                cartid: 'cartId',
                                count: 1,
                                imageUrl: image,
                                name: name,
                                price: price,
                                dimensions: [
                                  'Height: ${dimensions.height.toString()}',
                                  'Width: ${dimensions.width.toString()}',
                                  'Depth: ${dimensions.depth.toString()}'
                                ]);
                                log('heloooo>>>>>>>>>>>>>${dimensions.toString()}');
                            log('5');

                            context.read<CartBloc>().add(AddtoCartEvent(
                                productId: widget.productId,
                                productName: cartItem.name ?? '',
                                productPrice: cartItem.price ?? '',
                                productQuantity: cartItem.count ?? 0,
                                dimensions: cartItem.dimensions,
                                image: image ?? ''));
                            log('6');
                            
                            showCustomSnackbar(
                                context, "$name added to cart.", Colors.green);
                          },
                          child: Container(
                            height: 60,
                            width: 150,
                            decoration: BoxDecoration(
                              color: getButtonColor(),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Center(
                              child: Text(
                                'Add to Bag',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ]));
            }
          }),
    );
  }
}

Widget customProductName(String productName) {
  return Text(
    productName,
    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );
}

Widget customProductDescription(String productDescription) {
  return Text(
    productDescription,
    style: const TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
  );
}

Widget customProductPrice(String price) {
  return Text(
    price,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );
}
