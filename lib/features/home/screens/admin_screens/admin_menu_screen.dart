import 'package:firebase_auth_app/core/common/sign_in_buttons.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class AdminMenu extends ConsumerStatefulWidget {
  const AdminMenu({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminMenuState();
}

class _AdminMenuState extends ConsumerState<AdminMenu> {

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin menu'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Routemaster.of(context).push('/viewlogs');
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(double.infinity, 25))
                ),
                child: const Text('View Logs'),
              ),
              SignOutButton(user: user)
            ],
          )
        )
      ),
    );
  }
}