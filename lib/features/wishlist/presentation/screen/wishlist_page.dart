// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/cart/data/cart_service.dart';
import 'package:livilon/features/cart/domain/model/cart_model.dart';
import 'package:livilon/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:livilon/features/cart/presentation/bloc/cart_event.dart';
import 'package:livilon/features/home/domain/model/dimensionmodel.dart';
import 'package:livilon/features/home/presentation/bloc/dimensions/dimension_bloc.dart';
import 'package:livilon/features/home/presentation/bloc/dimensions/dimension_state.dart';
import 'package:livilon/features/home/presentation/screen/detail_screen.dart';
import 'package:livilon/features/home/presentation/screen/home_screen.dart';
import 'package:livilon/features/home/presentation/widget/snackbar.dart';
import 'package:livilon/features/wishlist/domain/model/wishlist_model.dart';
import 'package:livilon/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:livilon/features/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:livilon/features/wishlist/presentation/bloc/wishlist_state.dart';
import 'package:livilon/features/wishlist/presentation/widget/text.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  Color getButtonColor() {
    return const Color.fromRGBO(121, 147, 174, 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouriteBloc, FavouriteState>(
      builder: (context, state) {
        if (state is FavouriteLoading) {
          return _buildLoadingState();
        } else if (state is FavouriteSuccess) {
          final favourites = state.favourites;
          return favourites.isEmpty
              ? _buildEmptyState()
              : _buildFavouritesGrid(favourites, context);
        }

        return _buildErrorState();
      },
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Wishlist',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favourites',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_outline,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              "Hmmm... No favourites as yet.",
              style: TextStyle(
                  fontSize: 16, color: Color.fromRGBO(121, 147, 174, 1)),
            ),
            const SizedBox(height: 5),
            const Text(
              "Favourite the products you love and buy them ",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            const Text('whenever you like!',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Container(
              width: 200,
              decoration: BoxDecoration(
                  color: getButtonColor(),
                  borderRadius: BorderRadius.circular(2)),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomePage()));
                },
                child: const Text(
                  "Start Shopping",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavouritesGrid(
      List<FavouriteModel> favourites, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 4 : 2;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Center(
          child: Text(
            'Wishlist',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: favourites.length,
        itemBuilder: (context, index) {
          final favItems = favourites[index];
          return _buildFavouriteItem(favItems, context);
        },
      ),
    );
  }

  Widget _buildFavouriteItem(FavouriteModel favItems, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailScreen(productId: favItems.productId),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: favItems.imageUrl != null
                  ? Image.network(
                      favItems.imageUrl!,
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text("Image not available"),
                        );
                      },
                    )
                  : const Center(child: Text("No Image")),
            ),
            const SizedBox(height: 8),
            productTitle(favItems.name ?? 'Unknown Product'),
            const SizedBox(height: 4),
            favProductPrice('₹ ${favItems.price}'),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 16,
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    context
                        .read<FavouriteBloc>()
                        .add(RemoveFavouriteEvent(favItems.favouriteid));
                  },
                  child: const Text(
                    "Remove",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    handleAddtoCart(
                      context,
                      favItems.productId,
                      favItems.name ?? '',
                      favItems.price ?? '',
                      favItems.imageUrl ?? '',
                    );
                  },
                  child: Text(
                    "Add to Bag",
                    style: TextStyle(
                      color: getButtonColor(),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favourites',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: const Center(
        child: Text("Something went wrong."),
      ),
    );
  }

  Future<void> handleAddtoCart(
    BuildContext ctx,
    String productID,
    String name,
    String price,
    String image,
  ) async {
    final dimnsionBloc = context.read<DimensionBloc>();
    final dimensionState = dimnsionBloc.state;
    Dimensions? dimensions;
    if (dimensionState is DimensionAddedState) {
      dimensions = dimensionState.dimensions;
    } else {
      showCustomSnackbar(
        context,
        'Please add dimensions first!',
        Colors.red,
      );
      return;
    }
    final CartRepositoryImplementation cartRepoImplement =
        CartRepositoryImplementation();

    bool isProductInCart = await cartRepoImplement.isProductInCart(productID);

    if (isProductInCart) {
      showCustomSnackbar(context, 'Product is already in the cart', Colors.red);
      return;
    }

    final cartItem = CartModel(
        productid: productID,
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
    log('5');

    context.read<CartBloc>().add(AddtoCartEvent(
        productId: productID,
        productName: cartItem.name ?? '',
        productPrice: cartItem.price ?? '',
        productQuantity: cartItem.count ?? 0,
        image: image,
        dimensions: cartItem.dimensions));
    log('6');

    showCustomSnackbar(context, "$name added to cart.", Colors.green);
  }
}
