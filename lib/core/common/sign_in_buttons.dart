import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpButton extends ConsumerWidget {
  final String email;
  final String password;
  const SignUpButton({
    required this.email,
    required this.password,
    super.key
  });

  void signUpWithEmailAndPassword(String email, String password, BuildContext context, WidgetRef ref) {

    ref.read(authControllerProvider.notifier).signUpWithEmail(email, password, context);
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(      padding: const EdgeInsets.all(8.0), 
      child: TextButton(
        onPressed: () => signUpWithEmailAndPassword(email, password, context, ref),
        child: const Text('Sign Up')
      ),
    );
  }
}

class SignOutButton extends ConsumerWidget {
  final String email;
  const SignOutButton({
    required this.email,
    super.key
  });



  void signOut(WidgetRef ref, BuildContext context) {

    ref.read(authControllerProvider.notifier).signOut(email, context);
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(      padding: const EdgeInsets.all(8.0), 
      child: TextButton(
        onPressed: () => signOut(ref, context),
        child: const Text('Sign Out')
      ),
    );
  }
}

class SignInButton extends ConsumerWidget {
  final String email;
  final String password;
  const SignInButton({
    required this.email,
    required this.password,
    super.key
  });



  void signInWithEmailAndPassword(String email, String password, BuildContext context, WidgetRef ref) {

    ref.read(authControllerProvider.notifier).signInWithEmail(email, password, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(      padding: const EdgeInsets.all(8.0), 
      child: TextButton(
        onPressed: () => signInWithEmailAndPassword(email, password, context, ref),
        child: const Text('Sign In')
      ),
    );
  }
}