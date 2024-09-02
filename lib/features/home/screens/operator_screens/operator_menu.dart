import 'package:firebase_auth_app/core/common/sign_in_buttons.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class OperatorMenuScreen extends ConsumerStatefulWidget {
  const OperatorMenuScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OperatorMenuScreenState();
}




class _OperatorMenuScreenState extends ConsumerState<OperatorMenuScreen> {

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operator Panel'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Routemaster.of(context).push('/editrotation');
                }, 
                child: const Text('Edit Rotation')
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Routemaster.of(context).push('/alldrinks');
                }, 
                child: const Text('View All Drinks')
              ),
              const SizedBox(height: 30),
              SignOutButton(user: user),
            ],
          ),
        )
      ),
    );
  }
}