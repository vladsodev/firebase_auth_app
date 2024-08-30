import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/features/auth/repo/auth_repository.dart';
import 'package:firebase_auth_app/models/user.dart';
import 'package:firebase_auth_app/utils/show_snack_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider), 
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChanges;
},);

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool>{
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref, 
        super(false); // represents the loading state

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  void signUpWithEmail(String email, String password, BuildContext context) async {
    state = true;
    final user = await _authRepository.signUpWithEmail(email, password);
    state = false;
    user.fold((l) => showSnackBar(context, l.message), (userModel) => _ref.read(userProvider.notifier).update((state) => userModel));
  }



  void signInWithEmail(String email, String password, BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithEmail(email, password);
    state = false;
    user.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  void signInAnonymously(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInAnonymously();
    state = false;
    user.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  void signOut(String email, BuildContext context) async {
    state = true;
    await _authRepository.signOut(email);
    state = false;
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }


}