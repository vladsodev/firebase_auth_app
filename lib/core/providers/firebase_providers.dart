import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:firebase_auth_app/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final authProvider = Provider((ref) => FirebaseAuth.instance);

final authStateProvider = StreamProvider<UserModel?>((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.authStateChanges;
});