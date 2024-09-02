import 'package:firebase_auth_app/core/common/error_text.dart';
import 'package:firebase_auth_app/core/common/loader.dart';
import 'package:firebase_auth_app/core/common/order_card.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// возможно придётся учесть то, что новых заказов то и не будет

class OrdersInProgressScreen extends ConsumerStatefulWidget {
  const OrdersInProgressScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrdersInProgressScreenState();
}

class _OrdersInProgressScreenState extends ConsumerState<OrdersInProgressScreen> {

  @override
  Widget build(BuildContext context) {

    final user = ref.watch(userProvider);
    print(user);
    final orderList = ref.watch(ordersInProgressProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders in progress'),
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
      body: orderList.when(
        data: (orderList) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 650) {
                        return GridView.builder(
                          itemCount: orderList.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: constraints.maxWidth/700,
                          ), 
                          itemBuilder: (context, index) {
                            final order = orderList[index];
                            return GestureDetector(
                              onTap: () {
                                showDialog(context: context, builder: (context) {
                                  return AlertDialog(
                                    content: Column(
                                      children: [
                                        Text(order.timestamp),
                                        Text(order.name),
                                        Text(order.buyer),
                                        Text(order.price.toString()),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context).textTheme.labelLarge,
                                        ),
                                        child: const Text('Accept'),
                                        onPressed: () {
                                          ref.read(authControllerProvider.notifier).finishOrder(order);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context).textTheme.labelLarge,
                                        ),
                                        child: const Text('Decline'),
                                        onPressed: () {
                                          ref.read(authControllerProvider.notifier).cancelOrder(order);
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
                              child: OrderCard(name: order.name, price: order.price, timestamp: order.timestamp, buyer: order.buyer, backgroundColor: Colors.lightGreen),
                            );
                          }
                        );
                      } else {
                        return ListView.builder(
                          itemCount: orderList.length,
                          itemBuilder: (context, index) {
                            final order = orderList[index];
                            return GestureDetector(
                              onTap: () {
                                showDialog(context: context, builder: (context) {
                                  return AlertDialog(
                                    content: Column(
                                      children: [
                                        Text(order.timestamp),
                                        Text(order.name),
                                        Text(order.buyer),
                                        Text(order.price.toString()),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context).textTheme.labelLarge,
                                        ),
                                        child: const Text('Finish'),
                                        onPressed: () {
                                          ref.read(authControllerProvider.notifier).finishOrder(order);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context).textTheme.labelLarge,
                                        ),
                                        child: const Text('Decline'),
                                        onPressed: () {
                                          ref.read(authControllerProvider.notifier).cancelOrder(order);
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
                              child: OrderCard(name: order.name, price: order.price, timestamp: order.timestamp, buyer: order.buyer, backgroundColor: Colors.lightGreen),
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
      // floatingActionButton: FloatingActionButton.large(
      //   onPressed: () {
      //     Routemaster.of(context).push('/addnewdrink');
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}