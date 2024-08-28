import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/core/failure.dart';
import 'package:firebase_auth_app/core/providers/firebase_providers.dart';
import 'package:firebase_auth_app/core/type_defs.dart';
import 'package:firebase_auth_app/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authRepositoryProvider = Provider((ref) => AuthRepository(firestore: ref.read(firestoreProvider), auth: ref.read(authProvider)));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  AuthRepository({required FirebaseFirestore firestore, required FirebaseAuth auth})
    : _firestore = firestore,
      _auth = auth;


  FutureEither<UserModel> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(UserModel.fromFirebaseUser(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  Future<UserModel?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      print('Error signing in anonymously: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Stream<UserModel?> get authStateChanges {
  //   return _auth.authStateChanges().map(
  //     (user) => user != null ? UserModel.fromFirebaseUser(user) : null,
  //   );
  // }
  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }
}