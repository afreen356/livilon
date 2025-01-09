import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/components/searchbox.dart';
import 'package:livilon/features/cart/presentation/screen/cartpage.dart';
import 'package:livilon/features/home/presentation/screen/detail_screen.dart';
import 'package:livilon/features/home/presentation/screen/search_screen.dart';
import 'package:livilon/features/home/presentation/screen/showproduct_screen.dart';
import 'package:livilon/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:livilon/features/home/presentation/screen/accounts_screen.dart';
import 'package:livilon/features/wishlist/domain/model/wishlist_model.dart';
import 'package:livilon/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:livilon/features/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:livilon/features/wishlist/presentation/bloc/wishlist_state.dart';
import 'package:livilon/features/wishlist/presentation/screen/wishlist_page.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color btnClr = const Color.fromRGBO(121, 147, 174, 1);

  int currentSelectedIdx = 0;

  final pages = [
    const HomeScreen(),
    const WishlistPage(),
    CartPage(),
    const AccountsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentSelectedIdx],
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: btnClr,
          currentIndex: currentSelectedIdx,
          onTap: (newidx) {
            setState(() {
              currentSelectedIdx = newidx;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline), label: 'Favourite'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_bag_outlined,
                ),
                label: 'Bag'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "Account"),
          ]),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color getButtonColor() {
    return const Color.fromRGBO(121, 147, 174, 1);
  }

  Color getScaffoldColor() {
    return const Color.fromARGB(255, 244, 254, 255);
  }

  final TextEditingController _searchController = TextEditingController();
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    final wishlistBloc = context.read<FavouriteBloc>();
    final CollectionReference productCategory =
        FirebaseFirestore.instance.collection('category');
    return SafeArea(
      child: Scaffold(
        // backgroundColor: getScaffoldColor(),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SearchScreen()));
                },
                child: SearchBox(
                  controller: _searchController,
                )),
          ),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: StreamBuilder(
                stream: productCategory.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.grey,
                      ),
                    );
                  } else {
                    final categories = snapshot.data!.docs;
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final image = category['image'];
                          final decodedImage = base64Decode(image);
                          final categoryName = category['name'];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => ShowProducts(
                                                  categoryId: category.id,
                                                )));
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(color: getButtonColor()),
                                        image: decodedImage.isNotEmpty
                                            ? DecorationImage(
                                                image: MemoryImage(
                                                  decodedImage,
                                                ),
                                                filterQuality:
                                                    FilterQuality.high,
                                                fit: BoxFit.cover)
                                            : null),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text(
                                  categoryName,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          );
                        });
                  }
                }),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Products')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade300,
                            ),
                            child: const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                ),
                              ),
                            )),
                      );
                    } else {
                      return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: GridView.builder(
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
                                final String productId = product.id;
                                final String name = product['name'];
                                final price = product['price']?.toString();
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.network(
                                              productImage[0],
                                              fit: BoxFit.cover,
                                              filterQuality: FilterQuality.high,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child; 
                                                } else {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              (loadingProgress
                                                                      .expectedTotalBytes ??
                                                                  1)
                                                          : null,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '\$$price',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          BlocConsumer<FavouriteBloc,
                                              FavouriteState>(
                                            listener: (context, state) {},
                                            builder: (context, state) {
                                              bool isfavourite = false;
                                              if (state is FavouriteSuccess) {
                                                isfavourite = state.favourites
                                                    .any((favourite) =>
                                                        favourite.productId ==
                                                        productId);
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
                                                  String favid = productId;
                                                  if (isfavourite) {
                                                    wishlistBloc.add(
                                                        RemoveFavouriteEvent(
                                                            favid));
                                                  } else {
                                                    final favourites =
                                                        FavouriteModel(
                                                            productId:
                                                                productId,
                                                            name: name,
                                                            favouriteid: favid,
                                                            price: price,
                                                            imageUrl:
                                                                productImage[
                                                                    0]);
                                                    wishlistBloc.add(
                                                        AddFavouriteEvent(
                                                            favourites));
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }));
                    }
                  }))
        ]),
      ),
    );
  }
}
