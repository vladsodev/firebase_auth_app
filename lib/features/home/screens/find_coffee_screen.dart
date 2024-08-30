import 'dart:math';

import 'package:firebase_auth_app/core/common/image_urls.dart';
import 'package:firebase_auth_app/core/common/loader.dart';
import 'package:firebase_auth_app/core/common/product_card.dart';
import 'package:firebase_auth_app/core/common/sign_in_buttons.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:firebase_auth_app/models/drink.dart';
import 'package:firebase_auth_app/utils/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FindCoffee extends ConsumerStatefulWidget {
  const FindCoffee({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FindCoffeeState();
}

class _FindCoffeeState extends ConsumerState<FindCoffee> {

  double maxPrice = 200;
  bool isMilky = false;
  bool isCold = false;
  bool isSweet = false;
  bool isSour = false;
  double maxStrength = 4;
  late List<Map<String, dynamic>> products;
  late AsyncValue<List<Drink>> rotationDrinks;
  List<Map<String, dynamic>> filteredProducts = [];
  Map<String, dynamic> selectedProductMap = {};
  Drink? selectedProduct;





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

  void findRandomProduct() async {
    filterProducts();
    if (filteredProducts.isNotEmpty) {
      final random = Random();
      setState(() {
        selectedProductMap = filteredProducts[random.nextInt(filteredProducts.length)];
        selectedProduct = Drink.fromMap(selectedProductMap);
      });
    } else {
      setState(() {
        selectedProduct = null;
      });
    }
    }

  

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    rotationDrinks = ref.watch(drinkRotationProvider);
    rotationDrinks.when(
      data: (List<Drink> drinks) {
        products = drinks.map((Drink drink) => drink.toMap()).toList();
      }, 
      error: (error, stackTrace) => showSnackBar(context, error.toString()), 
      loading: () => const Loader(),
    );
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find your coffee'),
      ),
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
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
            ProductCard(name: selectedProduct!.name, description: selectedProduct!.description, price: selectedProduct!.price, image: ImageUrls.coffeeCup, backgroundColor: Colors.white)
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
              OrderButtonSmall(user: user, drink: selectedProduct)
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
          ]
        )
      )
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
          final selectedProduct = Drink.fromMap(filteredProducts[index]);
          return ProductCard(name: selectedProduct.name, description: selectedProduct.description, price: selectedProduct.price, image: ImageUrls.coffeeCup, backgroundColor: Colors.white);
        },
      ),
    );
  }
}