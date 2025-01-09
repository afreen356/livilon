import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/cart/presentation/screen/cartpage.dart';
import 'package:livilon/features/home/presentation/bloc/products/homebloc.dart';
import 'package:livilon/features/home/presentation/bloc/products/homeevent.dart';
import 'package:livilon/features/home/presentation/screen/search_screen.dart';
import 'package:livilon/features/wishlist/presentation/screen/wishlist_page.dart';

Widget buildCategory(bool isSelected, String categoryImage) {
  return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
          image: categoryImage.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(categoryImage),
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover)
              : null));
}

Widget customCategoryAppbar(String text, BuildContext context ,{Color bgColor = Colors.transparent}) {
  return AppBar(
    elevation: 0,
    backgroundColor: bgColor,
    title: Padding(
      padding: const EdgeInsets.only(right: 40),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SearchScreen()));
        },
      ),
      IconButton(
        icon: const Icon(Icons.favorite_border), 
        onPressed: () {
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const WishlistPage()));
          context.read<HomeBloc>().add(HomeWishlistButtonNavigateEvent());
        },
      ),
      IconButton(
        icon: const Icon(Icons.shopping_bag_outlined), 
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CartPage()));
          context.read<HomeBloc>().add(HomeCartButtonNavigateEvent());
        },
      ),
    ],
    bottom:  PreferredSize(
      preferredSize: const Size.fromHeight(1), 
      child: Divider(
        color: Colors.grey.shade300 ,
        thickness: 1, 
        height: 1,
       
      ),
    ),
  );
}
