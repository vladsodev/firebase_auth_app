import 'package:firebase_auth_app/core/common/error_text.dart';
import 'package:firebase_auth_app/core/common/loader.dart';
import 'package:firebase_auth_app/core/common/order_card.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// возможно придётся учесть то, что новых заказов то и не будет

class CancelledOrdersScreen extends ConsumerStatefulWidget {
  const CancelledOrdersScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CancelledOrdersScreenState();
}

class _CancelledOrdersScreenState extends ConsumerState<CancelledOrdersScreen> {

  @override

  Widget build(BuildContext context) {

    final user = ref.watch(userDataProvider);
    final orderList = ref.watch(cancelledOrdersProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancelled orders'),
      ),
      body: user.when(
        data: (user) {
          return orderList.when(
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
                                return OrderCard(name: order.name, price: order.price, timestamp: order.timestamp, buyer: order.buyer, backgroundColor: const Color.fromARGB(122, 235, 80, 69));
                              }
                            );
                          } else {
                            return ListView.builder(
                              itemCount: orderList.length,
                              itemBuilder: (context, index) {
                                final order = orderList[index];
                                return OrderCard(name: order.name, price: order.price, timestamp: order.timestamp, buyer: order.buyer, backgroundColor: const Color.fromARGB(122, 235, 80, 69));
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

  // Widget build(BuildContext context) {

  //   final user = ref.watch(userProvider);
  //   print(user);
  //   final orderList = ref.watch(cancelledOrdersProvider);
    
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Cancelled orders'),
  //       actions: [
  //         Builder(
  //           builder: (context) {
  //             return IconButton(
  //               icon: const Icon(Icons.person_2), 
  //               onPressed: () {},
  //             );
  //           }
  //         )
  //       ]
  //     ),
  //     body: orderList.when(
  //       data: (orderList) {
  //         return SafeArea(
  //           child: Column(
  //             children: [
  //               Expanded(
  //                 child: LayoutBuilder(
  //                   builder: (context, constraints) {
  //                     if (constraints.maxWidth > 650) {
  //                       return GridView.builder(
  //                         itemCount: orderList.length,
  //                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                           crossAxisCount: 2,
  //                           childAspectRatio: constraints.maxWidth/700,
  //                         ), 
  //                         itemBuilder: (context, index) {
  //                           final order = orderList[index];
  //                           return OrderCard(name: order.name, price: order.price, timestamp: order.timestamp, buyer: order.buyer, backgroundColor: const Color.fromARGB(122, 235, 80, 69));
  //                         }
  //                       );
  //                     } else {
  //                       return ListView.builder(
  //                         itemCount: orderList.length,
  //                         itemBuilder: (context, index) {
  //                           final order = orderList[index];
  //                           return OrderCard(name: order.name, price: order.price, timestamp: order.timestamp, buyer: order.buyer, backgroundColor: const Color.fromARGB(122, 235, 80, 69));
  //                         }
  //                       );
  //                     }
  //                   } 
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       }, 
  //     error: (error, stackTrace) => ErrorText(error: error.toString()), 
  //     loading: () => const Loader()
  //     ),
  //     // floatingActionButton: FloatingActionButton.large(
  //     //   onPressed: () {
  //     //     Routemaster.of(context).push('/addnewdrink');
  //     //   },
  //     //   child: const Icon(Icons.add),
  //     // ),
  //   );
  // }
}