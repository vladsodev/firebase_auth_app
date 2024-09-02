import 'package:firebase_auth_app/core/common/error_text.dart';
import 'package:firebase_auth_app/core/common/loader.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:firebase_auth_app/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
//import 'package:flutter/foundation.dart' show defaultTargetPlatform;



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}



// class Wrapper extends StatelessWidget {
//   const Wrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return defaultTargetPlatform == TargetPlatform.windows
//         ? const MaterialApp(home: MyApp())
//         : const MyApp();
//   }
// }


class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
      data: (data) {
        final userData = ref.watch(userDataProvider);
        
        return userData.when(
          data: (userModel) {
            return MaterialApp.router(
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
                  if (data != null && userModel != null) {
                    if (userModel.isOperator != null && userModel.isOperator!) {
                      return operatorRoute;
                    } else 
                    if (userModel.isAdmin != null && userModel.isAdmin!) {
                      return adminRoute;
                    } else
                    {
                      return loggedInRoute;
                    }
                  } else {
                    return loggedOutRoute;
                  }
                },
              ),
              routeInformationParser: const RoutemasterParser(),
            );
          },
          loading: () => const Loader(),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
        );
      },
      loading: () => const Loader(),
      error: (error, stackTrace) => ErrorText(error: error.toString()),
    );
  }
}

// class MyApp extends ConsumerStatefulWidget {
//   const MyApp({super.key});



//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
// }

// class _MyAppState extends ConsumerState<MyApp> {

//   UserModel? userModel;

//   void getData(WidgetRef ref, User data) async {
//     userModel = await ref.watch(authControllerProvider.notifier).getUserData(data.uid).first;
//     print('got data user $userModel');
//     ref.read(userProvider.notifier).update((state) => userModel);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ref.watch(authStateChangeProvider).when(
//       data: (data) => MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color.fromRGBO(208, 19, 54, 1),
//           primary: const Color.fromRGBO(208, 19, 54, 1),
//         ),
//       ),
//       title: 'V-Coffee',
//       routerDelegate: RoutemasterDelegate(
//         routesBuilder: (context) {
//         if (data != null) {
//           print('getting data');
//           getData(ref, data);
//           print(userModel);
//           if (userModel != null) {
//             print('logged in');
//             return loggedInRoute;
//           }
//         }
//         print('logged out');
//         return loggedOutRoute;
//         }
//       ),
//       routeInformationParser: const RoutemasterParser(),
//     ), 
//     error: (error, stackTrace) => ErrorText(error: error.toString()), 
//     loading: () => const Loader()
//     ); 
//   }
// }


