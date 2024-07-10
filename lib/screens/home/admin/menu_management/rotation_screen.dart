import 'package:firebase_auth_app/screens/home/admin/menu_management/rotation_list.dart';
import 'package:flutter/material.dart';

class RotationScreen extends StatelessWidget {
  const RotationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotation'),
      ),
      body: const Center(
        child: RotationList(),
      ),
    );
  }
}