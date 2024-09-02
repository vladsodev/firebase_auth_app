import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/core/constants/firebase_constants.dart';
import 'package:firebase_auth_app/core/failure.dart';
import 'package:firebase_auth_app/core/providers/firebase_providers.dart';
import 'package:firebase_auth_app/core/type_defs.dart';
import 'package:firebase_auth_app/models/drink.dart';
import 'package:firebase_auth_app/models/log.dart';
import 'package:firebase_auth_app/models/user.dart';
import 'package:firebase_auth_app/services/encrypt_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:zxcvbn/zxcvbn.dart';



final authRepositoryProvider = Provider((ref) => AuthRepository(firestore: ref.read(firestoreProvider), auth: ref.read(authProvider)));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  AuthRepository({required FirebaseFirestore firestore, required FirebaseAuth auth})
    : _firestore = firestore,
      _auth = auth;


  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _logs => _firestore.collection(FirebaseConstants.logCollection);
  CollectionReference get _drinks => _firestore.collection('drinks').doc('drink_collection').collection('drinks');
  CollectionReference get _rotation => _firestore.collection('drinks').doc('drink_collection').collection('rotation');
  CollectionReference get _removedFromRotation => _firestore.collection('drinks').doc('drink_collection').collection('removed_from_rotation');
  CollectionReference get _orders => _firestore.collection(FirebaseConstants.orders);
  CollectionReference get _allOrders => _firestore.collection(FirebaseConstants.orders).doc('vcoffee_orders').collection('all_orders');
  CollectionReference get _ordersInProgress => _firestore.collection(FirebaseConstants.orders).doc('vcoffee_orders').collection('orders_in_progress');
  CollectionReference get _completedOrders => _firestore.collection(FirebaseConstants.orders).doc('vcoffee_orders').collection('completed_orders');
  CollectionReference get _cancelledOrders => _firestore.collection(FirebaseConstants.orders).doc('vcoffee_orders').collection('cancelled_orders');
  CollectionReference get _newOrders => _firestore.collection(FirebaseConstants.orders).doc('vcoffee_orders').collection('orders_in_progress');

  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }

  FutureEither<UserModel> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel user = UserModel.fromFirebaseUser(userCredential.user!);

      _users.doc(user.uid).set(user.toMap());
      addLogOnRegister(user);
      addPasswordLog(user, password);
      return right(user);
    } on FirebaseAuthException catch (e) {
      await addLogOnError(email, e.message!);
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel user = UserModel.fromFirebaseUser(userCredential.user!);
      await addLogOnSignIn(user);
      return right(user);
    } on FirebaseAuthException catch (e) {
      await addLogOnError(email, e.message!);
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      UserModel user = UserModel.fromFirebaseUser(userCredential.user!);
      await addLogOnAnonymous(user);
      _users.doc(user.uid).set(user.toMap());
      return right(user);
    } on FirebaseAuthException catch (e) {
      await addLogOnError('Anonymous', e.message!);
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

    FutureEither<UserModel> signInAsGuest() async {
    try {
      var userCredential = await _auth.signInAnonymously();
      await addLogOnAnonymous(UserModel.fromFirebaseUser(userCredential.user!));
      UserModel userModel = UserModel(
        firstName: 'Guest',
        isAnonymous: true,
        uid: userCredential.user!.uid,
      );

      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      return right(userModel);
    } on FirebaseException catch (e) {
      await addLogOnError('Guest', e.message!);
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<void> signOut(UserModel user) async {
    addLogOnSignOut(user);
    await _auth.signOut();
  }

  // Stream<UserModel?> get authStateChanges {
  //   return _auth.authStateChanges().map(
  //     (user) => user != null ? UserModel.fromFirebaseUser(user) : null,
  //   );
  // }


  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  Future updateUserData(UserModel user) async {
    await _users.doc(user.uid).update(user.toMap());
  }



  Future addLogOnSignIn(UserModel user) async {
    await _logs.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('${user.email} signed in')
    });
  }

  Future addLogOnSignOut(UserModel user) async {
    if (user.isAnonymous) {
      await _logs.doc(DateTime.now().toString()).set({
        'timestamp': FieldValue.serverTimestamp(),
        'message': cypher.encrypt('Guest ${user.uid} signed out')
      });
      return;
    }
    await _logs.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('${user.email} signed out')
    });
  }

  Future addLogOnRegister(UserModel user) async {
    await _logs.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('${user.email} registered')
    });
  }

  Future addLogOnAnonymous(UserModel user) async {
    await _logs.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('Guest ${user.uid} signed in')
    });
  }

  Future addLogOnError(String email, String message) async {
    await _logs.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('User with email $email encountered error: $message')
    });
  }

  Future addPasswordLog(UserModel user, String password) async{
    final Zxcvbn zxcvbn = Zxcvbn();
    final strenght = zxcvbn.evaluate(password);
    await _logs.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('${user.email} used password with ${strenght.score} strength')
    });
  }

  Future addLogOnOrder(String uid, Drink drink) async {
      await _logs.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('User $uid ordered ${drink.name} with id ${drink.id}')
    });
  }

  Future addLogOnNewDrink(String uid, Drink drink) async {
    await _logs.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('Operator $uid added new drink ${drink.name} with id ${drink.id}')
    });
  }

  // Future addDrinkToHistory(String uid, Map<String, dynamic> selectedProduct) async {
  //   await _users.doc(uid).collection('history').doc(DateTime.now().toString()).set({
  //     'id': selectedProduct['id'],
  //     'name' : selectedProduct['name'],
  //     'timestamp': DateTime.now().toString(),
  //   });
  // }

  Future orderDrink(String uid, Drink drink) async {
    await addLogOnOrder(uid, drink);
    await _users.doc(uid).collection('history').doc(DateTime.now().toString()).set(drink.toMap());
    await _allOrders.doc(DateTime.now().toString()).set({
      ...drink.toMap(),
      'timestamp': DateTime.now().toString(),
      'buyer': uid
    });
    await _newOrders.doc(DateTime.now().toString()).set({
      ...drink.toMap(),
      'timestamp': DateTime.now().toString(),
      'buyer': uid
    });
  }

  Future acceptOrder(String uid, Drink drink) async {
    await _ordersInProgress.doc(DateTime.now().toString()).set({
      ...drink.toMap(),
      'timestamp': DateTime.now().toString(),
      'buyer': uid
    });
  }

  Future cancelOrder(String uid, Drink drink) async {
    await _cancelledOrders.doc(DateTime.now().toString()).set({
      ...drink.toMap(),
      'timestamp': DateTime.now().toString(),
      'buyer': uid
    });
  }

  // Future addDrinkToRotation(Map<String, dynamic> selectedProduct) async {
  //   await _rotation.doc(selectedProduct['id'].toString()).set({
  //     'id': selectedProduct['id'],
  //     'name': selectedProduct['name'],
  //     'description': selectedProduct['description'],
  //     'price': selectedProduct['price'],
  //     'cold': selectedProduct['cold'],
  //     'milky': selectedProduct['milky'],
  //     'sweet': selectedProduct['sweet'],
  //     'sour': selectedProduct['sour'],
  //     'strength': selectedProduct['strength'],
  //   });
  // }

  Future<int> getNextId() async {
    final querySnapshot = await _drinks
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final maxId = querySnapshot.docs.first.get('id') as int;
      return maxId + 1;
    } else {
      return 1; // Если коллекция пуста
    }
  }


  Future<void> addNewDrink(String uid, Drink drink) async {
    int newId = await getNextId();
    drink.id = newId;
    final drinkDoc = _drinks.doc(drink.id.toString());
    await drinkDoc.set(drink.toMap());
    await addLogOnNewDrink(uid, drink);
  }


  Future addDrinkToRotationBetter(Drink drink) async {
    await _removedFromRotation.doc(drink.id.toString()).delete();
    await _rotation.doc(drink.id.toString()).set(drink.toMap());
  }


  Future removeDrinkFromRotation(Drink selectedProduct) async {
    await _removedFromRotation.doc(selectedProduct.id.toString()).set(selectedProduct.toMap());
    await _rotation.doc(selectedProduct.id.toString()).delete();
  }


  // log list from snapshot
  List<Log> _logListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Log(
        timeStamp: (doc.data() as dynamic)['timestamp'] as Timestamp,
        message: cypher.decrypt((doc.data() as dynamic)['message'] as String) 
      );
    }).toList();
  }

  
  // get logs stream

  Stream<List<Log>> get logList {
    return _logs.snapshots()
      .map(_logListFromSnapshot);
  }

  Stream<List<Map<String, dynamic>>> get drinksList {
    return _drinks.snapshots()
      .map(
        (snapshot) => snapshot.docs.map((doc) {
          return {
            'id': doc['id'],
            'name': doc['name'],
            'description': doc['description'],
            'price': doc['price'],
            'cold': doc['cold'],        
            'milky': doc['milky'],
            'sweet': doc['sweet'],
            'sour': doc['sour'],
            'strength': doc['strength'],
          };
        }).toList()
      );
  }
  

  Stream<List<Map<String, dynamic>>> drinkHistory(String uid) {
    final snapshot = _users.doc(uid).collection('history').snapshots();
    return snapshot.map(
      (event) => event.docs.map((doc) {
      return {
        'id': doc['id'],
        'name': doc['name'],
        'timestamp': doc['timestamp'],
      }; 
    }).toList()
    );
  }

  Stream<List<Drink>> getDrinksFromHistory(String uid) {
    return _users.doc(uid).collection('history').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Drink.fromFirestore(doc)).toList();
    });
  }

  Stream<List<Drink>> get getDrinksFromRotation {
    return _rotation.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Drink.fromFirestore(doc)).toList();
    });
  }

  Stream<List<Drink>> get getRemovedDrinks {
    return _removedFromRotation.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Drink.fromFirestore(doc)).toList();
    });
  }


  Stream<List<Drink>> get getMenu {
    return _drinks.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Drink.fromFirestore(doc)).toList();
    });
  }

  



  Stream<List<Map<String, dynamic>>> get rotationList {
    return _rotation.snapshots()
      .map(
        (snapshot) => snapshot.docs.map((doc) {
          return {
            'id': doc['id'],
            'name': doc['name'],
            'description': doc['description'],
            'price': doc['price'],
            'cold': doc['cold'],        
            'milky': doc['milky'],
            'sweet': doc['sweet'],
            'sour': doc['sour'],
            'strength': doc['strength'],
          };
        }).toList()
      );
  }




}