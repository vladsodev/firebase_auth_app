import 'package:firebase_auth_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrinkList extends StatefulWidget {
  const DrinkList({super.key});

  @override
  State<DrinkList> createState() => _DrinkListState();
}

class _DrinkListState extends State<DrinkList> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>>? rotationList = Provider.of<List<Map<String, dynamic>>?>(context);

    if (rotationList == null) {
      return const Center(child: CircularProgressIndicator());
    }
    rotationList.sort((a, b) => a['id'].compareTo(b['id']));
    return Column(
      children: [

        Expanded(child: ListView.builder(
          itemCount: rotationList.length,
          itemBuilder: (context, index) {
            final product = rotationList[index];
            return ListTile(
              title: Text(product['name']),
              subtitle: Text('id: ${product['id'].toString()}'),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  DatabaseService().addDrinkToRotation(product);
                },
              ),
            );
          },
        )),
      ],
    );
  }
}