import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:livilon/features/home/presentation/screen/detail_screen.dart';
import 'package:livilon/features/home/presentation/screen/filter_screen.dart';
import 'package:livilon/features/home/presentation/screen/showproduct_screen.dart';

class SearchScreen extends StatefulWidget {
  
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var searchname = '';
  String? selectedCategory;
  String? selectedPriceRange;
  final TextEditingController _searchController = TextEditingController();
  Color getButtonColor() {
    return const Color.fromRGBO(121, 147, 174, 1);
  }

  Color getScaffoldColor() {
    return const Color.fromARGB(255, 238, 234, 234);
  }

  void openFilterScreen() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (context) => const FilterScreen(),
    );

    if (result != null) {
      setState(() {
        selectedCategory = result['category'];
        selectedPriceRange = result['priceRange'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchname = _searchController.text.trim();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : IconButton(
                    onPressed: () {
                      openFilterScreen();
                    },
                    icon: const Icon(
                      Icons.filter_list,
                      color: Colors.blue,
                    ),
                  ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (searchname.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 10),
                  child: Text(
                    'Popular Searches',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              if (searchname.isEmpty)
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('category')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final categories = snapshot.data!.docs;
                      return Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: categories.map((doc) {
                          final categoryName = doc['name'] ?? '';
                          return GestureDetector(
                            onTap: () {
                              final categoryId = doc.id;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ShowProducts(categoryId: categoryId)));
                            },
                            child: Chip(
                              backgroundColor: Colors.white,
                              shadowColor: Colors.grey.shade300,
                              elevation: 3,
                              label: Text(
                                categoryName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              avatar: const Icon(
                                Icons.local_offer,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              if (searchname.isNotEmpty)
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Products')
                        .where('name', isGreaterThanOrEqualTo: searchname)
                        .where('name', isLessThan: '$searchname\uf8ff')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final products = snapshot.data!.docs;
                      if (products.isEmpty) {
                        return const Center(
                          child: Text(
                            'No results found.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index].data();
                          final productId = products[index].id;
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                             leading: Padding(padding: EdgeInsets.all(
                              8,
                             ),
                             child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: getButtonColor()),
                                shape: BoxShape.circle
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network( product['image'][0],fit: BoxFit.cover,)),
                             ),
                             ),
                                
                              
                              title: Text(
                                product['name'],
                                style: const TextStyle(fontSize: 16),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        DetailScreen(productId: productId)));
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    
  }
}


