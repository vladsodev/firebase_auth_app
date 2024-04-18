import 'package:firebase_auth_app/services/auth.dart';
import 'package:firebase_auth_app/services/firebase_auth_methods.dart';
import 'package:flutter/material.dart';
class HollowScren extends StatefulWidget {

  const HollowScren({super.key});

  @override
  State<HollowScren> createState() => _HollowScrenState();
}

class _HollowScrenState extends State<HollowScren> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('User screen'),
          actions: [
            TextButton.icon(
              onPressed: () async {
                await _auth.signOut(context);
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