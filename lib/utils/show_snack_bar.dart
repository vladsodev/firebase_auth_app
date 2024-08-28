import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
    SnackBar(
      backgroundColor: Colors.white24,
      content: Text(message),
    ),
  );
}