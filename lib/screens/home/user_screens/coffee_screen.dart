//import 'package:firebase_auth_app/utils/product_list.dart';
//import 'package:firebase_auth_app/utils/product_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_app/models/user.dart';
import 'package:firebase_auth_app/services/database.dart';
import 'package:firebase_auth_app/utils/showSnackBar.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:provider/provider.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Coffee Shop',
//       home: ProductFilterPage(),
//     );
//   }
// }

class ProductFilterPage extends StatefulWidget {

  

  const ProductFilterPage({super.key});

  @override

  State<ProductFilterPage> createState() => _ProductFilterPageState();
}

class _ProductFilterPageState extends State<ProductFilterPage> {

  //List<Map<String, dynamic>> productsList = products;

  double maxPrice = 200;
  bool isMilky = false;
  bool isCold = false;
  bool isSweet = false;
  bool isSour = false;
  double maxStrength = 4;
  late List<Map<String, dynamic>> products;
  List<Map<String, dynamic>> filteredProducts = [];
  Map<String, dynamic>? selectedProduct;

  @override
  void initState() {
    super.initState();
    products = Provider.of<List<Map<String, dynamic>>>(context, listen: false);
  }


  void filterProducts() {
    setState(() {
      filteredProducts = products.where((product) {
        return product['price'] <= maxPrice &&
            (isMilky ? product['milky'] == true : true) &&
            (isCold ? product['cold'] == true : true) &&
            (isSweet ? product['sweet'] == true : true) &&
            (isSour ? product['sour'] == true : true) &&
            product['strength'] <= maxStrength;
      }).toList();
    });
  }

  

  

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    void findRandomProduct() async {
    filterProducts();
    if (filteredProducts.isNotEmpty) {
      final random = Random();
      setState(() {
        selectedProduct = filteredProducts[random.nextInt(filteredProducts.length)];
      });
    } else {
      setState(() {
        selectedProduct = null;
      });
    }
    }
    void like() async {
      if (selectedProduct == null || user == null || user.email == '') {
        showSnackBar(context, 'First you need to find your drink!');
        return;
      }
      DatabaseService().addDrinkToHistory(user.uid, selectedProduct!);
      showSnackBar(context, 'Added to history!');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find your coffee'),
      ),
      body: Column(
        children: [
          // Price slider
          Text('Max Price: \$${maxPrice.toStringAsFixed(0)}'),
          Slider(
            value: maxPrice,
            min: 0,
            max: 200,
            divisions: 20,
            label: maxPrice.round().toString(),
            onChanged: (value) {
              setState(() {
                maxPrice = value;
              });
            },
          ),
          // Milky filter
          CheckboxListTile(
            title: const Text('Milky'),
            value: isMilky,
            onChanged: (value) {
              setState(() {
                isMilky = value!;
              });
            },
          ),
          // Cold filter
          CheckboxListTile(
            title: const Text('Cold'),
            value: isCold,
            onChanged: (value) {
              setState(() {
                isCold = value!;
              });
            },
          ),
          // Sweet filter
          CheckboxListTile(
            title: const Text('Sweet'),
            value: isSweet,
            onChanged: (value) {
              setState(() {
                isSweet = value!;
              });
            },
          ),
          // Sour filter
          CheckboxListTile(
            title: const Text('Sour'),
            value: isSour,
            onChanged: (value) {
              setState(() {
                isSour = value!;
              });
            },
          ),
          // Strength slider
          Text('Max Strength: ${maxStrength.toStringAsFixed(0)}'),
          Slider(
            value: maxStrength,
            min: 0,
            max: 5,
            divisions: 5,
            label: maxStrength.round().toString(),
            onChanged: (value) {
              setState(() {
                maxStrength = value;
              });
            },
          ),
          // Find my coffee button
          ElevatedButton(
            onPressed: findRandomProduct,
            child: const Text('Find my coffee'),
          ),
          // Display selected product or message
          if (selectedProduct != null)
            ListTile(
              title: Text(selectedProduct!['name']),
              subtitle: Text(selectedProduct!['description']),
              trailing: Text('\$${selectedProduct!['price']}'),
            )
          else
            const Text('No products found'),
          // Show all filtered products button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  filterProducts();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilteredProductsPage(filteredProducts: filteredProducts),
                    ),
                  );
                },
                child: const Text('Show all matching products'),
              ),
              ElevatedButton.icon(
                onPressed: like, 
                icon: const Icon(Icons.favorite), 
                label: const Text('Like'))
            ],
          ),
        ],
      ),
    );
  }
}

class FilteredProductsPage extends StatelessWidget {
  final List<Map<String, dynamic>> filteredProducts;

  const FilteredProductsPage({
    super.key,
    required this.filteredProducts
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('You also might like'),
      ),
      body: ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return ListTile(
            title: Text(product['name']),
            subtitle: Text(product['description']),
            trailing: Text('\$${product['price']}'),
          );
        },
      ),
    );
  }
}
