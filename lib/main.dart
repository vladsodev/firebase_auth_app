import 'package:firebase_auth_app/firebase_options.dart';
import 'package:firebase_auth_app/models/user.dart';
import 'package:firebase_auth_app/screens/wrapper.dart';
import 'package:firebase_auth_app/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      catchError: (context, error) => null,
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData.dark(),
        title: 'auth_app',
        home: const Wrapper(),
      ),
    );
  }
}