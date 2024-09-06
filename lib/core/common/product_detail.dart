import 'package:firebase_auth_app/core/common/image_urls.dart';
import 'package:firebase_auth_app/core/common/sign_in_buttons.dart';
import 'package:firebase_auth_app/models/drink.dart';
import 'package:firebase_auth_app/models/user.dart';
import 'package:flutter/material.dart';


class ProductDetailsPage extends StatefulWidget {
  final Drink product;
  final UserModel? user;
  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.user,
    });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Details',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              widget.product.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    ImageUrls.coffeeCup,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              widget.product.description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(245, 247, 249, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.product.price} VP',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: OrderButtonBig(user: widget.user!, drink: widget.product)
                  ),
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}