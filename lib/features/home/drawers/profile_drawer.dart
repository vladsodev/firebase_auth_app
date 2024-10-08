import 'package:firebase_auth_app/core/common/error_text.dart';
import 'package:firebase_auth_app/core/common/loader.dart';
import 'package:firebase_auth_app/core/common/sign_in_buttons.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override

  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);
    return user.when(
      data: (user) {
        final isGuest = user!.isAnonymous;
        return Drawer(
        child: SafeArea(
          child: Column(
            children: [
              if (isGuest) 
                ...[SignOutButton(user: user)],
              if (!isGuest) ...[
                const Icon(Icons.person, size: 100),
                user.firstName != null ? Text(user.firstName!) : const Text(''),
                ListTile(
                  onTap: () => Routemaster.of(context).push('/userinfo'),
                  title: const Text('User Info'),
                ),
                const SizedBox(height: 20),
                SignOutButton(user: user)
              ],
            ],
          ),
        ),
      );
      }, 
      loading: () => const Loader(),
      error: (error, stackTrace) => ErrorText(error: error.toString())
      );
    
  }
}