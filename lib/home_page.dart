import 'package:firebase_auth_app/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/firebase_auth_methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signUpUser() async {
    FirebaseAuthMethods(FirebaseAuth.instance).signUpWithEmail(
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
              TextField(
                controller: emailController,
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: passwordController,
              ),
              const SizedBox(height: 20,),
              TextButton(
                onPressed: signUpUser, 
                child: const Text('Sign up')
              ),
              const SizedBox(height: 20,),
              const Text('Or'),
              const SizedBox(height: 20,),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const LoginPage();
                      },
                    )
                  );
                },
                child: const Text('Login'),
              )
            ]
          ),
        ),
      ),
    );
  }
}