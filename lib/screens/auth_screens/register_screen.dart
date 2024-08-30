import 'package:firebase_auth_app/core/common/loader.dart';
import 'package:firebase_auth_app/core/common/sign_in_buttons.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:firebase_auth_app/screens/auth_screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';


class RegisterForm extends ConsumerStatefulWidget {

  const RegisterForm({
    super.key,
  });

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {

  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up to V-coffee'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person_2),
            label: const Text('Sign In'),
            onPressed: () {
              Routemaster.of(context).pop('/');
            }
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Password'),
                        validator: (value) => value!.length < 8 ? 'Enter a password 8+ chars long' : null,
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      SignUpButton(email: email, password: password)
                    ]
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}