import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
    final String name;
    final double price;
    final String timestamp;
    final String buyer;
    final Color backgroundColor;
  const OrderCard({
    super.key,
    required this.name,
    required this.price,
    required this.timestamp,
    required this.buyer,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 5,),
          Text(
            '$price VP',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 5,),
          Text(
            timestamp,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 5,),
          Text(
            buyer,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}