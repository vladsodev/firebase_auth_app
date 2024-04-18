import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_app/models/log.dart';
import 'package:firebase_auth_app/screens/home/log_list.dart';
import 'package:firebase_auth_app/screens/home/log_screens/password_logs.dart';
import 'package:firebase_auth_app/screens/home/log_screens/sign_in_logs.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
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
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Welcome to Admin Panel',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.admin_panel_settings_sharp, size: 100),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StreamProvider.value(
                        initialData: null,
                        catchError: (context, error) => null,
                        value: DatabaseService().signInLogsList,
                        child: const SignInLogs(),
                      ),
                    )
                  );
                },
                style: const ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(
                    Size(200, 50),
                  ),
                ),
                child: const Text('Sign in logs'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StreamProvider.value(
                        initialData: null,
                        catchError: (context, error) => null,
                        value: DatabaseService().passwordLogList,
                        child: const PasswordLogs(),
                      ),
                    )
                  );
                },
                style: const ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(
                    Size(200, 50),
                  ),
                ),
                child: const Text('Password logs'),
              ),
              const SizedBox(height: 20),
            ]
          ),
        ),
      ),
    );
  }
}

