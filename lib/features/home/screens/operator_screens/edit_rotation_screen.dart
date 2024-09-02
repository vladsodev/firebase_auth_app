import 'package:firebase_auth_app/core/common/error_text.dart';
import 'package:firebase_auth_app/core/common/image_urls.dart';
import 'package:firebase_auth_app/core/common/loader.dart';
import 'package:firebase_auth_app/core/common/product_card.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class EditRotationScreen extends ConsumerStatefulWidget {
  const EditRotationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditRotationScreenState();
}



class _EditRotationScreenState extends ConsumerState<EditRotationScreen> {

  @override
  Widget build(BuildContext context) {

    final user = ref.watch(userProvider);
    print(user);
    final drinkList = ref.watch(drinkRotationProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotation'),
        // leading: Builder(
        //   builder: (context) {
        //     return IconButton(
        //       icon: const Icon(Icons.menu),
        //       onPressed: () {
        //         Routemaster.of(context).pop();
        //       },
        //     );
        //   }
        // ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.person_2), 
                onPressed: () {},
              );
            }
          )
        ]
      ),
      body: drinkList.when(
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
                                showDialog(context: context, builder: (context) {
                                  return AlertDialog(
                                    content: Column(
                                      children: [
                                        Image.asset(
                                          ImageUrls.coffeeCup,
                                          height: 30,
                                        ),
                                        Text(product.name),
                                        Text(product.description),
                                        Text(product.price.toString()),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context).textTheme.labelLarge,
                                        ),
                                        child: const Text('Remove from rotation'),
                                        onPressed: () {
                                          ref.read(authControllerProvider.notifier).removeDrinkFromRotation(product);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context).textTheme.labelLarge,
                                        ),
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
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
                                showDialog(context: context, builder: (context) {
                                  return AlertDialog(
                                    content: Column(
                                      children: [
                                        Image.asset(
                                          ImageUrls.coffeeCup,
                                          height: 30,
                                        ),
                                        Text(product.name),
                                        Text(product.description),
                                        Text(product.price.toString()),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context).textTheme.labelLarge,
                                        ),
                                        child: const Text('Remove from rotation'),
                                        onPressed: () {
                                          ref.read(authControllerProvider.notifier).removeDrinkFromRotation(product);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context).textTheme.labelLarge,
                                        ),
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
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
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Routemaster.of(context).push('/findcoffee');
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}