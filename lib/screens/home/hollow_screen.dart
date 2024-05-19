import 'package:firebase_auth_app/models/user.dart';
import 'package:firebase_auth_app/screens/home/user_screens/coffee_history.dart';
import 'package:firebase_auth_app/screens/home/user_screens/coffee_screen.dart';
import 'package:firebase_auth_app/services/auth.dart';
import 'package:firebase_auth_app/services/database.dart';
import 'package:firebase_auth_app/services/firebase_auth_methods.dart';
import 'package:firebase_auth_app/utils/product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HollowScren extends StatefulWidget {

  const HollowScren({super.key});

  @override
  State<HollowScren> createState() => _HollowScrenState();
}

class _HollowScrenState extends State<HollowScren> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Welcome!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StreamProvider<List<Map<String, dynamic>>?>.value(
                        initialData: null,
                        catchError: (context, error) => null,
                        value: DatabaseService().drinkHistory(user!.uid),
                        child: const CoffeeHistory(),
                      ),
                    )
                  );
              }, 
              child: const Text('View History')
            ),
            TextButton.icon(
              onPressed: () async {
                if (user != null) {
                  user.email == '' ? await _auth.signOut('Anonymous user ${user.uid}', context) : await _auth.signOut(user.email!, context);
                }
              }, 
              icon: const Icon(Icons.person_2, color: Colors.white), 
              label: const Text('Logout')
            )
          ],
        ),
      body: StreamProvider.value(
        value: DatabaseService().drinksList, 
        initialData: products,
        child: const ProductFilterPage(),
        catchError: (context, error) => null,
      ),
    );
  }
}