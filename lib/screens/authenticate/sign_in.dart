import 'package:firebase_auth_app/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  
  const SignIn({
    super.key,
    required this.toggleView
  });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // textfield state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in to V-points'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person_2, color: Colors.white),
            label: const Text('Register', style: TextStyle(color: Colors.white)),
            onPressed: () {
              widget.toggleView();
            }
          )
        ]
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
                        validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (value) => value!.length < 6 ? 'Enter a password 6+ chars long' : null,
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
                            dynamic result = await _auth.signInWithEmailAndPassword(email, password, context);
                          }
                        }, 
                        child: const Text('Sign in'),
                      ),
                    ]
                  )
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('or'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _auth.signinAnon(context);
                  }, 
                  child: const Text('Sign in anonymously'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}