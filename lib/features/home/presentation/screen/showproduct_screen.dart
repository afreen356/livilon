import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/components/categorybox.dart';
import 'package:livilon/features/cart/presentation/screen/cartpage.dart';
import 'package:livilon/features/home/presentation/bloc/products/homebloc.dart';
import 'package:livilon/features/home/presentation/bloc/products/homestate.dart';
import 'package:livilon/features/home/presentation/screen/detail_screen.dart';
import 'package:livilon/features/wishlist/presentation/screen/wishlist_page.dart';

// ignore: must_be_immutable
class ShowProducts extends StatefulWidget {
  String? categoryId;
  ShowProducts({super.key, required this.categoryId});

  @override
  State<ShowProducts> createState() => _ShowProductsState();
}

class _ShowProductsState extends State<ShowProducts> {
  String? categoryName;
  @override
  void initState() {
    fetchCategoryName();
    super.initState();
  }

  void fetchCategoryName() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('category')
        .doc(widget.categoryId)
        .get();
    if (docSnapshot.exists) {
      setState(() {
        categoryName = docSnapshot.data()?['name']; // Access the 'name' field
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, Homestate>(
      listener: (context, state) {
        if (state is HomeNavigateTowishlistPageActionstate) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const WishlistPage()));
        } else if (state is HomeNavigateToCartPageActionstate) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  CartPage()));
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: customCategoryAppbar(
                    categoryName ?? 'Loading...', context)),
            body: Column(children: [
             

              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Products')
                        .where('category', isEqualTo: widget.categoryId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return GridView.builder(
                            itemCount: snapshot.data!.docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 3,
                              mainAxisSpacing: 3,
                              childAspectRatio: 0.7,
                            ),
                            itemBuilder: (context, index) {
                              final product = snapshot.data!.docs[index];
                              final List<dynamic> productImage =
                                  product['image'];
                              final String name = product['name'];
                              final price = product['price'];
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailScreen(
                                                      productId: product.id,
                                                    )));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Image.network(
                                            productImage[0],
                                            fit: BoxFit.cover,
                                            filterQuality: FilterQuality.high,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            8), 
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    
                                    Text(
                                      '\$${price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }
                    }),
              ),
            ]));
      },
    );
  }
}
