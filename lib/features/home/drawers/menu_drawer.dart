import 'package:firebase_auth_app/core/common/sign_in_buttons.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class MenuDrawer extends ConsumerWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = user.isAnonymous;
    return Drawer(
      child: SafeArea(
        child: isGuest
        ? SignOutButton(user: user,) 
        : Column(
          children: [
            ListTile(
              onTap: () => Routemaster.of(context).push('/orderhistory'),
              title: const Text('Order History'),
            ),
          ],
        ),
      ),
    );
  }
}