import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/features/auth/repo/auth_repository.dart';
import 'package:firebase_auth_app/models/user.dart';
import 'package:firebase_auth_app/utils/show_snack_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final authControllerProvider = Provider((ref) => AuthController(authRepository: ref.read(authRepositoryProvider)));

class AuthController {
  final AuthRepository _authRepository;
  AuthController({required AuthRepository authRepository}) : _authRepository = authRepository;

  void signUpWithEmail(String email, String password, BuildContext context) async {
    final user = await _authRepository.signUpWithEmail(email, password);
    user.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  // Future<UserModel?> signUpWithEmail(String email, String password) {
  //   return _authRepository.signUpWithEmail(email, password);
  // }

  Future<UserModel?> signInWithEmail(String email, String password) {
    return _authRepository.signInWithEmail(email, password);
  }

  Future<UserModel?> signInAnonymously() {
    return _authRepository.signInAnonymously();
  }

  Future<void> signOut() {
    return _authRepository.signOut();
  }

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

}