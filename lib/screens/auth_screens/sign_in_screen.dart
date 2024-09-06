import 'package:firebase_auth_app/core/common/loader.dart';
import 'package:firebase_auth_app/core/common/sign_in_buttons.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:firebase_auth_app/screens/auth_screens/register_screen.dart';
import 'package:firebase_auth_app/screens/home/user_screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';


class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {

  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';



  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in to V-coffee'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person_2),
            label: const Text('Sign Up'),
            onPressed: () {
              Routemaster.of(context).push('/register');
            }
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Password'),
                        validator: (value) => value!.length < 3 ? 'Enter your password' : null,
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      SigInGigaButton(email: email, password: password),
                      const SizedBox(height: 20),
                      const Text('or'),
                      const SizedBox(height: 20),
                      const SignInAsGuestButton(),
                    ]
                  )
                ),
              ],
            ),
          ),
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
