// import 'package:firebase_auth_app/models/user.dart';
// import 'package:firebase_auth_app/screens/home/user_screens/coffee_history.dart';
// import 'package:firebase_auth_app/screens/home/user_screens/coffee_screen.dart';
// import 'package:firebase_auth_app/services/auth.dart';
// import 'package:firebase_auth_app/services/database.dart';
// import 'package:firebase_auth_app/services/firebase_auth_methods.dart';
// import 'package:firebase_auth_app/utils/product_list.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// class HomeScreen extends StatefulWidget {

//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final AuthService _auth = AuthService();

//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<MyUser?>(context);
//     return Scaffold(
//       appBar: AppBar(
//           title: const Text('Welcome!'),
//           actions: [
//             TextButton.icon(
//               onPressed: () {
//                 Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => StreamProvider<List<Map<String, dynamic>>?>.value(
//                         initialData: null,
//                         catchError: (context, error) => null,
//                         value: DatabaseService().drinkHistory(user!.uid),
//                         child: const CoffeeHistory(),
//                       ),
//                     )
//                   );
//               }, 
//               label: const Text('View History'),
//               icon: const Icon(Icons.history),
//             ),
//             TextButton.icon(
//               onPressed: () async {
//                 if (user != null) {
//                   user.email == '' ? await _auth.signOut('Anonymous user ${user.uid}', context) : await _auth.signOut(user.email!, context);
//                 }
//               }, 
//               icon: const Icon(Icons.person_2), 
//               label: const Text('Logout')
//             )
//           ],
//         ),
//       body: StreamProvider.value(
//         value: DatabaseService().rotationList, 
//         initialData: products,
//         child: const ProductFilterPage(),
//         catchError: (context, error) => null,
//       ),
//     );
//   }
// }