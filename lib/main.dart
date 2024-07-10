import 'dart:io';
import 'package:firebase_auth_app/firebase_options.dart';
import 'package:firebase_auth_app/models/user.dart';
import 'package:firebase_auth_app/screens/wrapper.dart';
import 'package:firebase_auth_app/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:http/http.dart' as http;

// Future sendAccessLog() async {
//     await http.post(Uri.parse('http://127.0.0.1/access_to_app/'));
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //   await windowManager.ensureInitialized();
  //   WindowManager.instance.setMinimumSize(const Size(400, 670));
  //   WindowManager.instance.setMaximumSize(const Size(400, 670));
  //   WindowManager.instance.setTitle('V-Coffee');
  // }

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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(208, 19, 54, 1),
            primary: const Color.fromRGBO(208, 19, 54, 1),
          ),
        ),
        title: 'V-Coffee',
        home: const Wrapper(),
      ),
    );
  }
}