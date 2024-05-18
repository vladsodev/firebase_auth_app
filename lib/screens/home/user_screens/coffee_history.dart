import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeHistory extends StatelessWidget {
  const CoffeeHistory({super.key});

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>>? history = Provider.of<List<Map<String, dynamic>>?>(context);

    if (history == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your history'),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final product = history[index];
          return ListTile(
            title: Text(product['timestamp'].toString()),
            subtitle: Text(product['name']),
          );
        },
      ),
    );
  }
}