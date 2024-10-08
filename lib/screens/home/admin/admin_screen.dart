// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth_app/models/log.dart';
// import 'package:firebase_auth_app/models/user.dart';
// import 'package:firebase_auth_app/screens/home/admin/menu_management/drink_collection_screen.dart';
// import 'package:firebase_auth_app/screens/home/admin/menu_management/rotation_screen.dart';
// import 'package:firebase_auth_app/screens/home/log_list.dart';
// import 'package:firebase_auth_app/screens/home/log_screens/logparsing.dart';
// import 'package:firebase_auth_app/screens/home/log_screens/password_logs.dart';
// import 'package:firebase_auth_app/screens/home/log_screens/sign_in_logs.dart';
// import 'package:firebase_auth_app/screens/home/parselogs.dart';
// import 'package:firebase_auth_app/services/auth.dart';
// import 'package:firebase_auth_app/services/regexp.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth_app/services/database.dart';

// class AdminScreen extends StatefulWidget {

//   const AdminScreen({super.key});

//   @override
//   State<AdminScreen> createState() => _AdminScreenState();
// }

// class _AdminScreenState extends State<AdminScreen> {
//   final AuthService _auth = AuthService();
  
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<MyUser?>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin Panel'),
//         actions: [
//           TextButton.icon(
//             onPressed: () async {
//               if (user != null) {
//                 await _auth.signOut(user.email!, context);
//               }
//             }, 
//             icon: const Icon(Icons.person_2, color: Colors.white), 
//             label: const Text('Logout')
//           )
//         ],
//       ),
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               const Text(
//                 'Welcome to Admin Panel',
//                 style: TextStyle(fontSize: 20),
//               ),
//               const SizedBox(height: 20),
//               const Icon(Icons.admin_panel_settings_sharp, size: 100),
//               const SizedBox(height: 20),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => StreamProvider.value(
//                         initialData: null,
//                         catchError: (context, error) => null,
//                         value: DatabaseService().logList,
//                         child: const SignInLogs(),
//                       ),
//                     )
//                   );
//                 },
//                 style: const ButtonStyle(
//                   fixedSize: MaterialStatePropertyAll(
//                     Size(200, 50),
//                   ),
//                 ),
//                 child: const Text('View logs'),
//               ),
//               const SizedBox(height: 20),
//               // TextButton(
//               //   onPressed: () {
//               //     Navigator.of(context).push(
//               //       MaterialPageRoute(
//               //         builder: (context) => StreamProvider.value(
//               //           initialData: null,
//               //           catchError: (context, error) => null,
//               //           value: DatabaseService().signInLogsList,
//               //           child: const SignInLogs(),
//               //         ),
//               //       )
//               //     );
//               //   },
//               //   style: const ButtonStyle(
//               //     fixedSize: MaterialStatePropertyAll(
//               //       Size(200, 50),
//               //     ),
//               //   ),
//               //   child: const Text('Sign in logs'),
//               // ),
//               // const SizedBox(height: 20),
//               // TextButton(
//               //   onPressed: () {
//               //     Navigator.of(context).push(
//               //       MaterialPageRoute(
//               //         builder: (context) => StreamProvider.value(
//               //           initialData: null,
//               //           catchError: (context, error) => null,
//               //           value: DatabaseService().passwordLogList,
//               //           child: const PasswordLogs(),
//               //         ),
//               //       )
//               //     );
//               //   },
//               //   style: const ButtonStyle(
//               //     fixedSize: MaterialStatePropertyAll(
//               //       Size(200, 50),
//               //     ),
//               //   ),
//               //   child: const Text('Password logs'),
//               // ),
//               // const SizedBox(height: 20),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => const RegexApp(),
//                     )
//                   );
//                 },
//                 style: const ButtonStyle(
//                   fixedSize: MaterialStatePropertyAll(
//                     Size(200, 50),
//                   ),
//                 ),
//                 child: const Text('Parse text'),
//               ),
//               const SizedBox(height: 20),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => StreamProvider.value(
//                         initialData: null,
//                         catchError: (context, error) => null,
//                         value: DatabaseService().logList,
//                         child: const LogParser(),
//                       ),
//                     )
//                   );
//                 },
//                 style: const ButtonStyle(
//                   fixedSize: MaterialStatePropertyAll(
//                     Size(200, 50),
//                   ),
//                 ),
//                 child: const Text('Parse logs'),
//               ),
//               const SizedBox(height: 20),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => StreamProvider<List<Map<String, dynamic>>?>.value(
//                         initialData: null,
//                         catchError: (context, error) => null,
//                         value: DatabaseService().drinksList,
//                         child: const DrinkScreen(),
//                       ),
//                     )
//                   );
//                 },
//                 style: const ButtonStyle(
//                   fixedSize: MaterialStatePropertyAll(
//                     Size(200, 50),
//                   ),
//                 ),
//                 child: const Text('Menu'),
//               ),
//               const SizedBox(height: 20),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => StreamProvider.value(
//                         initialData: null,
//                         catchError: (context, error) => null,
//                         value: DatabaseService().rotationList,
//                         child: const RotationScreen(),
//                       ),
//                     )
//                   );
//                 },
//                 style: const ButtonStyle(
//                   fixedSize: MaterialStatePropertyAll(
//                     Size(200, 50),
//                   ),
//                 ),
//                 child: const Text('Rotation'),
//               ),
//             ]
//           ),
//         ),
//       ),
//     );
//   }
// }

