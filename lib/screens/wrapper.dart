// import 'package:firebase_auth_app/models/user.dart';
// import 'package:firebase_auth_app/screens/authenticate/auth_screen.dart';
// import 'package:firebase_auth_app/screens/home/user_screen.dart';
// import 'package:firebase_auth_app/screens/home/admin/admin_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth_app/services/database.dart';

// class Wrapper extends StatelessWidget {
//   const Wrapper({super.key});

//   @override
//   Widget build(BuildContext context) {

//     final user = Provider.of<MyUser?>(context);

//     if (user == null) {
//       return const AuthScreen();
//     } else if (user.email == 'admin@goodboy.com') {
//       return const HomeScreen();
//     } else {
//       return const HollowScren();
//     }
//   }
// }