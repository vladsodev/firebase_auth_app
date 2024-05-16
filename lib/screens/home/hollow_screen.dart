import 'package:firebase_auth_app/models/user.dart';
import 'package:firebase_auth_app/services/auth.dart';
import 'package:firebase_auth_app/services/firebase_auth_methods.dart';
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
          title: const Text('User screen'),
          actions: [
            TextButton.icon(
              onPressed: () async {
                if (user != null) {
                  user.email == '' ? await _auth.signOut('Anonynous user ${user.uid}', context) : await _auth.signOut(user.email!, context);
                }
              }, 
              icon: const Icon(Icons.person_2, color: Colors.white), 
              label: const Text('Logout')
            )
          ],
        ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sorry, but you're not an admin"),
            SizedBox(height: 20),
            Icon(Icons.mood_bad, size: 100),
          ]
        ),
      ),
    );
  }
}