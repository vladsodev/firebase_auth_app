import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_app/models/log.dart';
import 'package:firebase_auth_app/screens/home/log_list.dart';
import 'package:firebase_auth_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth_app/services/database.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Log>?>.value(
      initialData: null,
      value: DatabaseService().logs,
      catchError: (context, error) {
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
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
        body: const LogList(),
      ),
    );
  }
}