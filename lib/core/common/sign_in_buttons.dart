import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:firebase_auth_app/models/drink.dart';
import 'package:firebase_auth_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

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
  final UserModel user;
  const SignOutButton({
    required this.user,
    super.key
  });



  void signOut(WidgetRef ref, BuildContext context) {

    ref.read(authControllerProvider.notifier).signOut(user, context);
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
        onPressed: () {
          signInWithEmailAndPassword(email, password, context, ref);
          
        },
        child: const Text('Sign In')
      ),
    );
  }
}

class SigInGigaButton extends ConsumerStatefulWidget {
  final String email;
  final String password;
  const SigInGigaButton({
    required this.email,
    required this.password,
    super.key
  });


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SigInGigaButtonState();
}

class _SigInGigaButtonState extends ConsumerState<SigInGigaButton> {

  void signInWithEmailAndPassword(String email, String password, BuildContext context, WidgetRef ref) {

    ref.read(authControllerProvider.notifier).signInWithEmail(email, password, context);
    setState(() {print('set');});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(      
      padding: const EdgeInsets.all(8.0), 
      child: TextButton(
        onPressed: () {
          signInWithEmailAndPassword(widget.email, widget.password, context, ref);
        },
        child: const Text('Sign In')
      ),
    );
  }
}


class SignInAsGuestButton extends ConsumerStatefulWidget {
  const SignInAsGuestButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInAsGuestButtonState();
}

class _SignInAsGuestButtonState extends ConsumerState<SignInAsGuestButton> {

  void signInAsGuest(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
    setState(() {
      print('guest setstate');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(      
      padding: const EdgeInsets.all(8.0), 
      child: TextButton(
        onPressed: () {
          signInAsGuest(ref, context);
        },
        child: const Text('Sign in as guest')
      ),
    );
  }
}



class SignInAnonButton extends ConsumerWidget {

  const SignInAnonButton({
    super.key
  });


  void signInAnonymously(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInAnonymously(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(      padding: const EdgeInsets.all(8.0), 
      child: TextButton(
        onPressed: () => signInAnonymously(context, ref),
        child: const Text('Sign In as Guest')
      ),
    );
  }
}

class OrderButtonBig extends ConsumerWidget {
  final UserModel user;
  final Drink? drink;
  const OrderButtonBig({
    required this.user,
    this.drink,
    super.key
  });


  void orderDrink(BuildContext context, WidgetRef ref, Drink? drink) {
    ref.read(authControllerProvider.notifier).orderDrink(user, drink, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        fixedSize: const Size(350, 50)
      ),
      onPressed: () => orderDrink(context, ref, drink), 
      label: Text(
        'Buy',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      icon: const Icon(
        Icons.shopping_bag,
        color: Colors.black,
      ),
    );
  }
}

class OrderButtonSmall extends ConsumerWidget {
  final UserModel user;
  final Drink? drink;
  const OrderButtonSmall({
    required this.user,
    this.drink,
    super.key
  });


  void orderDrink(BuildContext context, WidgetRef ref, Drink? drink) {
    ref.read(authControllerProvider.notifier).orderDrink(user, drink, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      onPressed: () => orderDrink(context, ref, drink), 
      label: Text(
        'Buy',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      icon: const Icon(
        Icons.shopping_bag,
        color: Colors.black,
      ),
    );
  }
}