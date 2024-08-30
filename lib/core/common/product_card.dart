import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final String image;
  final Color backgroundColor;
  const ProductCard({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
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
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),            
              child: Image(
                image: AssetImage(image),
                height: 150,
                isAntiAlias: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}