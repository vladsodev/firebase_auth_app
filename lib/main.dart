import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/core/common/error_text.dart';
import 'package:firebase_auth_app/core/common/loader.dart';
import 'package:firebase_auth_app/core/providers/firebase_providers.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:firebase_auth_app/router.dart';
import 'package:firebase_auth_app/screens/auth_screens/sign_in_screen.dart';
import 'package:firebase_auth_app/screens/home/user_screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth_app/firebase_options.dart';
import 'package:firebase_auth_app/models/user.dart';
import 'package:firebase_auth_app/screens/wrapper.dart';
import 'package:firebase_auth_app/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
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



class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});



  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref.watch(authControllerProvider.notifier).getUserData(data.uid).first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
      data: (data) => MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(208, 19, 54, 1),
          primary: const Color.fromRGBO(208, 19, 54, 1),
        ),
      ),
      title: 'V-Coffee',
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) {
        // if (data != null) {
        //   print('getting data');
        //   getData(ref, data);
        //   if (userModel != null) {
        //     print('logged in');
        //     return loggedInRoute;
        //   }
        // }
        // print('logged out');
        // return loggedOutRoute;
        if (data == null) {
          print('logged out');
          return loggedOutRoute;
        }
        getData(ref, data);
        if (userModel == null) {
          return loggedOutRoute;
        }
        return loggedInRoute;
        }
      ),
      routeInformationParser: const RoutemasterParser(),
    ), 
    error: (error, stackTrace) => ErrorText(error: error.toString()), 
    loading: () => const Loader()
    ); 
  }
}


