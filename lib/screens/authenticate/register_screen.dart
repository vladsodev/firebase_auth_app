import 'package:firebase_auth_app/services/auth.dart';
import 'package:firebase_auth_app/utils/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:zxcvbn/zxcvbn.dart';

class RegisterForm extends StatefulWidget {
  final Function toggleView;
  const RegisterForm({
    super.key,
    required this.toggleView
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  final AuthService _auth = AuthService();
  final Zxcvbn _zxcvbn = Zxcvbn();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in to V-coffee'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person_2),
            label: const Text('Sign in'),
            onPressed: () {
              widget.toggleView();
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
                      ElevatedButton (
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final strength = _zxcvbn.evaluate(password);
                            showSnackBar(context, 'Password strength: ${strength.score}');
                            dynamic result = await _auth.registerWithEmailAndPassword(email, password, context);
                          }
                        }, 
                        child: const Text('Sign up'),
                      ),
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