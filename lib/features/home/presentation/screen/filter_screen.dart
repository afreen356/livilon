import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livilon/features/home/presentation/screen/detail_screen.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({
    super.key,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  ValueNotifier<List<DocumentSnapshot>> filteredProductsNotifier =
      ValueNotifier<List<DocumentSnapshot>>([]);
  String? selectedCategory;
  String? selectedPriceRange;
  List<String> categories = [];
  bool isLoading = true;

  final List<Map<String, dynamic>> priceRanges = [
    {'label': '1,000 - 10,000', 'min': 1000, 'max': 10000},
    {'label': '10,000 - 50,000', 'min': 10000, 'max': 50000},
    {'label': '50,000 - 1,00,000', 'min': 50000, 'max': 100000},
  ];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  // Fetch Categories from Firestore
  Future<void> fetchCategories() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('category').get();
      final List<String> fetchedCategories =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (error) {
      log('Error fetching categories: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> applyFilters() async {
    if (selectedCategory == null) {
      log('Please select a category');
      return;
    }
    log("cat: $selectedCategory, Price: $selectedPriceRange");
    final selectedRange = priceRanges.firstWhere(
      (range) => range['label'] == selectedPriceRange,
      orElse: () => {'min': 0, 'max': 100000},
    );

    try {
      final categorySnapshot = await FirebaseFirestore.instance
          .collection('category')
          .where('name', isEqualTo: selectedCategory)
          .get();

      if (categorySnapshot.docs.isEmpty) {
        log('No matching category found');
        return;
      }

      final categoryId = categorySnapshot.docs.first.id;

      Query query = FirebaseFirestore.instance.collection('Products');

      query = query.where('category', isEqualTo: categoryId);
      query =
          query.where('price', isGreaterThanOrEqualTo: selectedRange['min']);
      query = query.where('price', isLessThanOrEqualTo: selectedRange['max']);

      final QuerySnapshot snapshot = await query.get();

      if (snapshot.docs.isEmpty) {}

      filteredProductsNotifier.value = snapshot.docs.toList();
    } catch (error) {
      log('Error applying filters: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Filter
                  const Text(
                    'Select Category',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    hint: const Text('Select a category'),
                    value: selectedCategory,
                    items: categories
                        .map((category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedCategory = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Price Range Filter
                  const Text(
                    'Select Price Range',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: priceRanges.map((range) {
                      return ChoiceChip(
                        label: Text(range['label']),
                        selected: selectedPriceRange == range['label'],
                        avatar: selectedPriceRange == range['label']
                            ? const Icon(Icons.check,
                                size: 18, color: Colors.white)
                            : null,
                        onSelected: (selected) {
                          setState(() {
                            selectedPriceRange =
                                selected ? range['label'] : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: applyFilters,
                    child: const Text('Apply Filters'),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: ValueListenableBuilder<List<DocumentSnapshot>>(
                      valueListenable: filteredProductsNotifier,
                      builder: (context, filteredProducts, child) {
                        if (filteredProducts.isEmpty) {
                          return const Center(
                              child: Text('No products found.'));
                        }
                        return ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            var product = filteredProducts[index];
                            var productName = product['name'];
                            var productPrice = product['price'];
                            return GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DetailScreen(productId: product.id)));
                              },
                              child: Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(productName),
                                  trailing: Text('\$${productPrice.toString()}'),
                                ),
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
    );
  }
}
