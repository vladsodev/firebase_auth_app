import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/firebase_auth_methods.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    FirebaseAuthMethods(FirebaseAuth.instance).loginWithEmail(
      email: emailController.text, 
      password: passwordController.text, 
      context: context
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text('Enter email'),
              TextField(
                controller: emailController,
              ),
              const SizedBox(height: 20,),
              const Text('Enter password'),
              TextField(
                controller: passwordController,
              ),
              const SizedBox(height: 20,),
              TextButton(
                onPressed: loginUser, 
                child: const Text('Login')
              )
            ]
          ),
        ),
      ),
    );
  }
}