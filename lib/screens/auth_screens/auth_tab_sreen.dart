import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              const Text('Welcome! To continue, please log in'),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Routemaster.of(context).push('/signin');
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Routemaster.of(context).push('/register');
                },
                child: const Text('Register'),
              ),
            ],
          )
        ),
      ),
    );
  }
}