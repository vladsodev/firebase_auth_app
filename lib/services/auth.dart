import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/models/user.dart';
import 'package:firebase_auth_app/services/database.dart';
import 'package:firebase_auth_app/utils/showSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth_app/services/encrypt_data.dart';

MyUser? _userFromFirebaseUser(User user) {
  return MyUser(uid: user.uid, email: user.email);
}


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  // auth change user stream
  Stream<MyUser?> get user {
    return _auth.userChanges()
      .map((User? user) => _userFromFirebaseUser(user!));
  }


  // sign in anon
  Future signinAnon(BuildContext context) async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      await DatabaseService().addLogOnAnonymous(user);
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      await DatabaseService().addLogOnError('Anonymous', e.message!);
      if (context.mounted) {
        showSnackBar(context, e.message!);
        return null;
      }
    }
  }


  // email sign up
  Future registerWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      // new doc to db
      await DatabaseService().addLogOnRegister(user);
      await DatabaseService().addPasswordLog(user, password);
      await DatabaseService().db.collection('users').doc(user.uid).set({'email': user.email});
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      await DatabaseService().addLogOnError(email, e.message!);
      if (context.mounted) {
        showSnackBar(context, e.message!);
      }
      return null;
    }
  }

  // email sign in
  Future signInWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      await DatabaseService().addLogOnSignIn(user);
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      await DatabaseService().addLogOnError(email, e.message!);
      if (context.mounted) {
        showSnackBar(context, e.message!);
      }
      return null;
    }
  }

  // sign out
  Future<void> signOut(String email, BuildContext context) async {
    try {
      await DatabaseService().addLogOnSignOut(email);
      return await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.message!);
      }
    }
  }

}