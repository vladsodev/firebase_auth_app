import 'package:firebase_auth_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CoffeeHistory extends StatelessWidget {
  const CoffeeHistory({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<MyUser?>(context);
    List<Map<String, dynamic>>? history = Provider.of<List<Map<String, dynamic>>?>(context);

    if (history == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your history'),
      ),
      body: Column(
        children: [
          Text('${user!.email} history:'),
          Expanded(
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final product = history[index];
                return ListTile(
                  title: Text(product['timestamp'].toString()),
                  subtitle: Text(product['name']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}