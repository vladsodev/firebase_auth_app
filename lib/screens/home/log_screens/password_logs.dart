import 'package:firebase_auth_app/screens/home/log_list.dart';
import 'package:flutter/material.dart';

class PasswordLogs extends StatefulWidget {
  const PasswordLogs({super.key});

  @override
  State<PasswordLogs> createState() => _PasswordLogsState();
}

class _PasswordLogsState extends State<PasswordLogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password logs'),
      ),
      body: const LogList(),
    );
  }
}