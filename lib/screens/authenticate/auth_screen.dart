// import 'package:firebase_auth_app/screens/authenticate/register_screen.dart';
// import 'package:firebase_auth_app/screens/authenticate/sign_in.dart';
// import 'package:flutter/material.dart';

// class AuthScreen extends StatefulWidget {
  
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {

//   bool showSignIn = true;

//   void toggleView() {
//     setState(() => showSignIn = !showSignIn);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return showSignIn ? SignIn(toggleView: toggleView) : RegisterForm(toggleView: toggleView);
//   }
// }