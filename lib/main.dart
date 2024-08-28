import 'package:firebase_auth_app/core/providers/firebase_providers.dart';
import 'package:firebase_auth_app/screens/home/user_screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth_app/firebase_options.dart';
import 'package:firebase_auth_app/models/user.dart';
import 'package:firebase_auth_app/screens/wrapper.dart';
import 'package:firebase_auth_app/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';




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

  runApp(const ProviderScope(child: MyApp()));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<MyUser?>.value(
//       catchError: (context, error) => null,
//       initialData: null,
//       value: AuthService().user,
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: const Color.fromRGBO(208, 19, 54, 1),
//             primary: const Color.fromRGBO(208, 19, 54, 1),
//           ),
//         ),
//         title: 'V-Coffee',
//         home: const Wrapper(),
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer(
        builder: (context, ref, _) {
          final authState = ref.watch(authStateProvider);

          return authState.when(
            data: (user) {
              if (user != null) {
                return const HomeScreen();  // Экран основного приложения
              } else {
                return SignInScreen();  // Экран входа
              }
            },
            loading: () => const CircularProgressIndicator(),
            error: (e, stack) => Text('Error: $e'),
          );
        },
      ),
    );
  }
}