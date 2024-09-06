// import 'package:firebase_auth_app/core/common/loader.dart';

import 'package:firebase_auth_app/core/common/loader.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String confirmPassword = '';

  // Регулярное выражение для проверки требований к паролю
  final RegExp _upperCaseRegex = RegExp(r'[A-Z]'); // Заглавная буква
  final RegExp _lowerCaseRegex = RegExp(r'[a-z]'); // Строчная буква
  final RegExp _digitRegex = RegExp(r'\d'); // Цифра
  final RegExp _specialCharacterRegex = RegExp(r'[!@#\$&*~]'); // Спецсимвол

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up to V-coffee'),
        actions: [
          TextButton.icon(
              icon: const Icon(Icons.person_2),
              label: const Text('Sign In'),
              onPressed: () {
                Routemaster.of(context).push('/');
              }),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a password';
                          } else if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          } else if (!_upperCaseRegex.hasMatch(value)) {
                            return 'Password must contain at least one uppercase letter';
                          } else if (!_lowerCaseRegex.hasMatch(value)) {
                            return 'Password must contain at least one lowercase letter';
                          } else if (!_digitRegex.hasMatch(value)) {
                            return 'Password must contain at least one number';
                          } else if (!_specialCharacterRegex.hasMatch(value)) {
                            return 'Password must contain at least one special character';
                          }
                          return null;
                        },
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Confirm Password'),
                        validator: (value) {
                          if (value != password) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            confirmPassword = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ref.read(authControllerProvider.notifier).signUpWithEmail(email, password, context);
                          }
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}









// import 'package:firebase_auth_app/core/common/sign_in_buttons.dart';
// import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
// import 'package:firebase_auth_app/screens/auth_screens/sign_in_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:routemaster/routemaster.dart';


// class RegisterForm extends ConsumerStatefulWidget {

//   const RegisterForm({
//     super.key,
//   });

//   @override
//   ConsumerState<RegisterForm> createState() => _RegisterFormState();
// }

// class _RegisterFormState extends ConsumerState<RegisterForm> {

//   final _formKey = GlobalKey<FormState>();

//   String email = '';
//   String password = '';

//   @override
//   Widget build(BuildContext context) {
//     final isLoading = ref.watch(authControllerProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign Up to V-coffee'),
//         actions: [
//           TextButton.icon(
//             icon: const Icon(Icons.person_2),
//             label: const Text('Sign In'),
//             onPressed: () {
//               Routemaster.of(context).push('/');
//             }
//           )
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Center(
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         decoration: const InputDecoration(labelText: 'Email'),
//                         validator: (value) => value!.isEmpty ? 'Enter an email' : null,
//                         onChanged: (value) {
//                           setState(() {
//                             email = value;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         decoration: const InputDecoration(labelText: 'Password'),
//                         validator: (value) => value!.length < 8 ? 'Enter a password 8+ chars long' : null,
//                         obscureText: true,
//                         onChanged: (value) {
//                           setState(() {
//                             password = value;
//                           });
//                         },
//                       ),
                      
//                       const SizedBox(height: 20),
//                       SignUpButton(email: email, password: password)
//                     ]
//                   )
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:firebase_auth_app/core/common/loader.dart';
// import 'package:firebase_auth_app/core/common/sign_in_buttons.dart';
// import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
// import 'package:firebase_auth_app/screens/auth_screens/sign_in_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:routemaster/routemaster.dart';

// class RegisterForm extends ConsumerStatefulWidget {
//   const RegisterForm({super.key});

//   @override
//   ConsumerState<RegisterForm> createState() => _RegisterFormState();
// }

// class _RegisterFormState extends ConsumerState<RegisterForm> {
//   final _formKey = GlobalKey<FormState>();

//   String email = '';
//   String password = '';
//   String confirmPassword = '';

//   // Регулярное выражение для проверки наличия специальных символов
//   final RegExp _specialCharacterRegex = RegExp(r'[!@#\$&*~]');

//   @override
//   Widget build(BuildContext context) {
//     final isLoading = ref.watch(authControllerProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign Up to V-coffee'),
//         actions: [
//           TextButton.icon(
//               icon: const Icon(Icons.person_2),
//               label: const Text('Sign In'),
//               onPressed: () {
//                 Routemaster.of(context).push('/');
//               }),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Center(
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         decoration: const InputDecoration(labelText: 'Email'),
//                         validator: (value) => value!.isEmpty ? 'Enter an email' : null,
//                         onChanged: (value) {
//                           setState(() {
//                             email = value;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         decoration: const InputDecoration(labelText: 'Password'),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Enter a password';
//                           } else if (value.length < 8) {
//                             return 'Password must be at least 8 characters long';
//                           } else if (!_specialCharacterRegex.hasMatch(value)) {
//                             return 'Password must contain at least one special character';
//                           }
//                           return null;
//                         },
//                         obscureText: true,
//                         onChanged: (value) {
//                           setState(() {
//                             password = value;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         decoration: const InputDecoration(labelText: 'Confirm Password'),
//                         validator: (value) {
//                           if (value != password) {
//                             return 'Passwords do not match';
//                           }
//                           return null;
//                         },
//                         obscureText: true,
//                         onChanged: (value) {
//                           setState(() {
//                             confirmPassword = value;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       isLoading
//                           ? const Loader()
//                           : ElevatedButton(
//                               onPressed: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   // Здесь можно вызвать метод для регистрации
//                                   ref.read(authControllerProvider.notifier).signUpWithEmail(email, password, context);
//                                 }
//                               },
//                               child: const Text('Sign Up'),
//                             ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
