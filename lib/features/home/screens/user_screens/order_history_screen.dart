import 'package:firebase_auth_app/core/common/error_text.dart';
import 'package:firebase_auth_app/core/common/image_urls.dart';
import 'package:firebase_auth_app/core/common/loader.dart';
import 'package:firebase_auth_app/core/common/product_card.dart';
import 'package:firebase_auth_app/core/common/product_detail.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderHistory extends ConsumerStatefulWidget {
  const OrderHistory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends ConsumerState<OrderHistory> {

  @override

  
    Widget build(BuildContext context) {

    final user = ref.watch(userDataProvider);
    
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your order history'),
      ),
      body: user.when(
        data: (user) {
          final drinkList = ref.watch(drinkHistoryProvider(user!.uid));
          return drinkList.when(
            data: (drinkList) {
              return SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 650) {
                            return GridView.builder(
                              itemCount: drinkList.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: constraints.maxWidth.toDouble()/700,
                              ), 
                              itemBuilder: (context, index) {
                                final product = drinkList[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ProductDetailsPage(product: product, user: user);
                                        }
                                      )
                                    );
                                  },
                                  child: ProductCard(
                                    name: product.name, 
                                    description: product.description,
                                    price: product.price, 
                                    image: ImageUrls.coffeeCup,
                                    backgroundColor: index.isEven ? const Color.fromRGBO(216, 240, 253, 1) : const Color.fromRGBO(245, 247, 249, 1),
                                  ),
                                );
                              }
                            );
                          } else {
                            return ListView.builder(
                              itemCount: drinkList.length,
                              itemBuilder: (context, index) {
                                final product = drinkList[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ProductDetailsPage(product: product, user: user);
                                        }
                                      )
                                    );
                                  },
                                  child: ProductCard(
                                    name: product.name, 
                                    description: product.description,
                                    price: product.price, 
                                    image: ImageUrls.coffeeCup,
                                    backgroundColor: index.isEven ? const Color.fromRGBO(216, 240, 253, 1) : const Color.fromRGBO(245, 247, 249, 1),
                                  ),
                                );
                              }
                            );
                          }
                        } 
                      ),
                    ),
                  ],
                ),
              );
            }, 
          error: (error, stackTrace) => ErrorText(error: error.toString()), 
          loading: () => const Loader());
        }, 
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),),
      );
  }
}


