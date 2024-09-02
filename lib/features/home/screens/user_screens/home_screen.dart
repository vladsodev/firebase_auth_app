import 'package:firebase_auth_app/core/common/error_text.dart';
import 'package:firebase_auth_app/core/common/image_urls.dart';
import 'package:firebase_auth_app/core/common/loader.dart';
import 'package:firebase_auth_app/core/common/product_card.dart';
import 'package:firebase_auth_app/core/common/product_detail.dart';
import 'package:firebase_auth_app/core/common/sign_in_buttons.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:firebase_auth_app/features/home/drawers/menu_drawer.dart';
import 'package:firebase_auth_app/features/home/drawers/profile_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';



class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {

    final userData = ref.watch(userDataProvider);
    
    final drinkList = ref.watch(drinkRotationProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => displayDrawer(context),
            );
          }
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.person_2), 
                onPressed: () => displayEndDrawer(context),
              );
            }
          )
        ]
      ),
      body: userData.when(
        data: (userData) {
          print('current user $userData');
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
                                childAspectRatio: constraints.maxWidth/700,
                              ), 
                              itemBuilder: (context, index) {
                                final product = drinkList[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ProductDetailsPage(product: product, user: userData);
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
                                          return ProductDetailsPage(product: product, user: userData);
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
          loading: () => const Loader()
          );
        }, 
        loading: () => const Loader(),
        error: (error, stackTrace) => ErrorText(error: error.toString())),
      
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Routemaster.of(context).push('/findcoffee');
        },
        child: const Icon(Icons.search),
      ),
      drawer: const MenuDrawer(),
      endDrawer: const ProfileDrawer(),
    );
  }
}