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
import 'package:firebase_auth_app/services/api.dart';
import 'package:firebase_auth_app/services/encrypt_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:zxcvbn/zxcvbn.dart';
import 'package:http/http.dart' as http;



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
  CollectionReference get _newOrders => _firestore.collection(FirebaseConstants.orders).doc('vcoffee_orders').collection('new_orders');

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
      //await http.post(Uri.parse('http://127.0.0.1/sign_up_attempt/'));
      _users.doc(user.uid).set(user.toMap());
      addLogOnRegister(user);
      addPasswordLog(user, password);

      //sendApiLog('Timestamp: ${DateTime.now().toString()} Message: new user registered');
      sendApiLog('new user registered');
      //await http.post(Uri.parse('http://127.0.0.1/signed_up/'));
      return right(user);
    } on FirebaseAuthException catch (e) {
      await addLogOnError(email, e.message!);
      //endApiLog('Timestamp: ${DateTime.now().toString()} Message: sing up attempt encountered error: ${e.message}');
      sendApiLog('sing up attempt encountered error: ${e.message}');
      return left(Failure(e.message!));
    } catch (e) {
      //sendApiLog('Timestamp: ${DateTime.now().toString()} Message: sing up attempt encountered error: $e');
      sendApiLog('sing up attempt encountered error: $e');
      await http.post(Uri.parse('http://127.0.0.1/sign_up_error/'));
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
      sendApiLog('user signed in');
      //sendApiLog('Timestamp: ${DateTime.now().toString()} Source: $email Message: signed in');
      return right(user);
    } on FirebaseAuthException catch (e) {
      sendApiLog('sign in attempt encountered error: ${e.message}');
      //sendApiLog('Timestamp: ${DateTime.now().toString()} Message: sign in attempt encountered error: ${e.message}');
      //sendApiLog('Timestamp: ${DateTime.now().toString()} Source: $email Message: sign in attempt encountered error: ${e.message}');
      await addLogOnError(email, e.message!);
      return left(Failure(e.message!));
    } catch (e) {
      sendApiLog('sign in attempt encountered error: $e');
      //sendApiLog('Timestamp: ${DateTime.now().toString()} Source: $email Message: sign in attempt encountered error: $e');
      //sendApiLog('Timestamp: ${DateTime.now().toString()} Message: sign in attempt encountered error: $e');
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      UserModel user = UserModel.fromFirebaseUser(userCredential.user!);
      await addLogOnAnonymous(user);
      _users.doc(user.uid).set(user.toMap());

      await http.post(Uri.parse('http://127.0.0.1/sign_in/'));
      sendApiLog('guest signed in');
      //sendApiLog('Timestamp: ${DateTime.now().toString()} Message: Guest signed in');
      return right(user);
    } on FirebaseAuthException catch (e) {
      sendApiLog('guest sign in attempt encountered error: ${e.message}');
      //sendApiLog('Timestamp: ${DateTime.now().toString()} Message: Guest sign in attempt encountered error: ${e.message}');
      await addLogOnError('Anonymous', e.message!);
      await http.post(Uri.parse('http://127.0.0.1/sign_in_error/'));
      return left(Failure(e.message!));
    } catch (e) {
      sendApiLog('guest sign in attempt encountered error: $e');
      //sendApiLog('Timestamp: ${DateTime.now().toString()} Message: Guest sign in attempt encountered error: $e');
      await http.post(Uri.parse('http://127.0.0.1/sign_in_error/'));
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
      sendApiLog('guest signed in');
      //sendApiLog('Timestamp: ${DateTime.now().toString()} Message: Guest signed in');
      //await http.post(Uri.parse('http://127.0.0.1/signed_in/'));
      return right(userModel);
    } on FirebaseException catch (e) {
      sendApiLog('guest sign in attempt encountered error: ${e.message}');
      //sendApiLog('Timestamp: ${DateTime.now().toString()} Message: Guest sign in attempt encountered error: ${e.message}');
      await addLogOnError('Guest', e.message!);
      //await http.post(Uri.parse('http://127.0.0.1/sign_in_error/'));
      return left(Failure(e.message!));
    } catch (e) {
      sendApiLog('guest sign in attempt encountered error: $e');
      //sendApiLog('Timestamp: ${DateTime.now().toString()} Message: Guest sign in attempt encountered error: $e');
      //await http.post(Uri.parse('http://127.0.0.1/sign_in_error/'));
      return left(Failure(e.toString()));
    }
  }

  Future<void> signOut(UserModel user) async {
    addLogOnSignOut(user);
    sendApiLog('user signed out');
    //sendApiLog('Timestamp: ${DateTime.now().toString()} Message: user signed out');
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
    sendApiLog('user data updated');
    //sendApiLog('Timestamp: ${DateTime.now().toString()} Message: user data updated');
    //await http.post(Uri.parse('http://127.0.0.1/data_updated/'));
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
    final order = VcoffeeOrder(name: drink.name, price: drink.price, timestamp: DateTime.now().toString(), buyer: uid, id: drink.id);
    await addLogOnOrder(uid, drink);
    await _users.doc(uid).collection('history').doc(order.timestamp).set({...drink.toMap(), 'timestamp': order.timestamp});
    await _allOrders.doc(order.timestamp).set(order.toMap());
    await _newOrders.doc(order.timestamp).set(order.toMap());
    await http.post(Uri.parse('http://127.0.0.1/order_added/'));
    sendApiLog('new order');
    //sendApiLog('User $uid ordered ${drink.name} with id ${drink.id}');
  }

  Future acceptOrder(VcoffeeOrder order) async {
    await _ordersInProgress.doc(order.timestamp).set(order.toMap());
    await _newOrders.doc(order.timestamp).delete();
    await http.post(Uri.parse('http://127.0.0.1/order_accepted/'));
    sendApiLog('order accepted');
    //sendApiLog('Order ${order.timestamp} accepted');
  }

// здесь могут быть проблемы
  Future cancelOrder(VcoffeeOrder order) async {
    await _cancelledOrders.doc(order.timestamp).set(order.toMap());
    await _newOrders.doc(order.timestamp).delete();
    await _ordersInProgress.doc(order.timestamp).delete();
    await http.post(Uri.parse('http://127.0.0.1/order_cancelled/'));
    sendApiLog('order cancelled');
    //sendApiLog('Order ${order.timestamp} cancelled');
  }

  Future finishOrder(VcoffeeOrder order) async {
    await _completedOrders.doc(order.timestamp).set(order.toMap());
    await _ordersInProgress.doc(order.timestamp).delete();
    await http.post(Uri.parse('http://127.0.0.1/order_finished/'));
    sendApiLog('order finished');
    //sendApiLog('Order ${order.timestamp} finished');
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
    //await http.post(Uri.parse('http://127.0.0.1/new_drink_added/'));
    sendApiLog('new drink added');
    //sendApiLog('Operator $uid added new drink ${drink.name} with id ${drink.id}');
  }


  Future addDrinkToRotationBetter(String uid, Drink drink) async {
    await _removedFromRotation.doc(drink.id.toString()).delete();
    await _rotation.doc(drink.id.toString()).set(drink.toMap());
    //await http.post(Uri.parse('http://127.0.0.1/new_drink_added_to_rotation/'));
    sendApiLog('new drink added to rotation');
    //sendApiLog('Operator $uid added new drink ${drink.name} with id ${drink.id} to rotation');
  }


  Future removeDrinkFromRotation(String uid, Drink selectedProduct) async {
    await _removedFromRotation.doc(selectedProduct.id.toString()).set(selectedProduct.toMap());
    await _rotation.doc(selectedProduct.id.toString()).delete();
    //await http.post(Uri.parse('http://127.0.0.1/drink_removed_from_rotation/'));
    sendApiLog('drink removed from rotation');
    //sendApiLog('Operator $uid removed drink ${selectedProduct.name} with id ${selectedProduct.id} from rotation');
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
      //http.post(Uri.parse('http://127.0.0.1/drinks_from_history/'));
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

  Stream<List<VcoffeeOrder>> get getOrders {
    return _allOrders.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => VcoffeeOrder.fromFirestore(doc)).toList();
    });
  }

  Stream<List<VcoffeeOrder>> get getNewOrders {
    return _newOrders.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => VcoffeeOrder.fromFirestore(doc)).toList();
    });
  }

  Stream<List<VcoffeeOrder>> get getOrdersInProgress {
    return _ordersInProgress.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => VcoffeeOrder.fromFirestore(doc)).toList();
    });
  }

  Stream<List<VcoffeeOrder>> get getCompletedOrders {
    return _completedOrders.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => VcoffeeOrder.fromFirestore(doc)).toList();
    });
  }

  Stream<List<VcoffeeOrder>> get getCancelledOrders {
    return _cancelledOrders.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => VcoffeeOrder.fromFirestore(doc)).toList();
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