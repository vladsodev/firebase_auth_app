import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:firebase_auth_app/screens/home/user_screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  void signUpWithEmailAndPassword(String email, String password, BuildContext context, WidgetRef ref) {

    ref.read(authControllerProvider).signUpWithEmail(email, password, context);
  }


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text;
                final password = _passwordController.text;

                widget.signUpWithEmailAndPassword(email, password, context, ref);
              },
              child: Text('Sign In'),
            ),
            TextButton(
              onPressed: () async {
                final authController = ref.read(authControllerProvider);
                final user = await authController.signInAnonymously();

                if (user != null) {
                  // Переход на следующий экран при успешной авторизации
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  // Показать ошибку
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login as guest failed')),
                  );
                }
              },
              child: Text('Continue as Guest'),
            ),
          ],
        ),
      ),
    );
  }
}


// class SignInScreen extends ConsumerStatefulWidget {
//   const SignInScreen({super.key});

//   @override
//   _SignInScreenState createState() => _SignInScreenState();
// }

// class _SignInScreenState extends ConsumerState<SignInScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sign In')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final email = _emailController.text;
//                 final password = _passwordController.text;

//                 final authController = ref.read(authControllerProvider);
//                 final user = await authController.signInWithEmail(email, password);

//                 if (user != null) {
//                   // Переход на следующий экран при успешной авторизации
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => HomePage()),
//                   );
//                 } else {
//                   // Показать ошибку
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Login failed')),
//                   );
//                 }
//               },
//               child: Text('Sign In'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 final authController = ref.read(authControllerProvider);
//                 final user = await authController.signInAnonymously();

//                 if (user != null) {
//                   // Переход на следующий экран при успешной авторизации
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => HomePage()),
//                   );
//                 } else {
//                   // Показать ошибку
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Login as guest failed')),
//                   );
//                 }
//               },
//               child: Text('Continue as Guest'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
