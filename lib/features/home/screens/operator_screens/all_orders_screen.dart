import 'package:firebase_auth_app/core/common/error_text.dart';
import 'package:firebase_auth_app/core/common/loader.dart';
import 'package:firebase_auth_app/core/common/order_card.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// возможно придётся учесть то, что новых заказов то и не будет

class AllOrdersScreen extends ConsumerStatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends ConsumerState<AllOrdersScreen> {

  @override
  Widget build(BuildContext context) {

    final user = ref.watch(userProvider);
    print(user);
    final orderList = ref.watch(allOrdersProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('All orders history'),
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
                            return OrderCard(name: order.name, price: order.price, timestamp: order.timestamp, buyer: order.buyer, backgroundColor: Colors.blueGrey);
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