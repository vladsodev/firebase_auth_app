import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/models/log.dart';
import 'package:firebase_auth_app/services/encrypt_data.dart';
import 'package:zxcvbn/zxcvbn.dart';

class DatabaseService {

  final db = FirebaseFirestore.instance;
  final CollectionReference signInLogs = FirebaseFirestore.instance.collection('sign_in_logs');
  final CollectionReference passwordLogs = FirebaseFirestore.instance.collection('password_logs');
  final CollectionReference logs = FirebaseFirestore.instance.collection('logs');
  final CollectionReference drinks = FirebaseFirestore.instance.collection('drinks').doc('drink_collection').collection('drinks');
  final CollectionReference rotation = FirebaseFirestore.instance.collection('drinks').doc('drink_collection').collection('rotation');
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  final logDocuments = FirebaseFirestore.instance.collection('sign_in_logs').snapshots();

  Future addLogOnSignIn(User user) async {
    await logs.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('${user.email} signed in')
    });
  }

  Future addLogOnSignOut(String email) async {
    await logs.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('$email signed out')
    });
  }

  Future addLogOnRegister(User user) async {
    await logs.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('${user.email} registered')
    });
  }

  Future addLogOnAnonymous(User user) async {
    await logs.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('Anonymous user ${user.uid} signed in')
    });
  }

  Future addLogOnError(String email, String message) async {
    await logs.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('User with email $email encountered error: $message')
    });
  }

  Future addPasswordLog(User user, String password) async{
    final Zxcvbn zxcvbn = Zxcvbn();
    final strenght = zxcvbn.evaluate(password);
    await logs.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('${user.email} used password with ${strenght.score} strength')
    });
  }

  Future addDrinkToHistory(String uid, Map<String, dynamic> selectedProduct) async {
    await DatabaseService().db.collection('users').doc(uid).collection('history').doc(DateTime.now().toString()).set({
      'id': selectedProduct['id'],
      'name' : selectedProduct['name'],
      'timestamp': DateTime.now().toString(),
    });
  }

  Future addDrinkToRotation(Map<String, dynamic> selectedProduct) async {
    await DatabaseService().rotation.doc(selectedProduct['id'].toString()).set({
      'id': selectedProduct['id'],
      'name': selectedProduct['name'],
      'description': selectedProduct['description'],
      'price': selectedProduct['price'],
      'cold': selectedProduct['cold'],        
      'milky': selectedProduct['milky'],
      'sweet': selectedProduct['sweet'],
      'sour': selectedProduct['sour'],
      'strength': selectedProduct['strength'],
    });
  }

  Future removeDrinkFromRotation(Map<String, dynamic> selectedProduct) async {
    await DatabaseService().rotation.doc(selectedProduct['id'].toString()).delete();
  }


  // log list from snapshot
  List<Log> _logListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Log(
        timeStamp: (doc.data() as dynamic)['timestamp'] as Timestamp,
        message: (doc.data() as dynamic)['message'] as String
      );
    }).toList();
  }

  
  // get logs stream


  Stream<List<Log>> get signInLogsList {
    return signInLogs.snapshots()
      .map(_logListFromSnapshot);
  }


  Stream<List<Log>> get passwordLogList {
    return passwordLogs.snapshots()
      .map(_logListFromSnapshot);
  }

  Stream<List<Log>> get logList {
    return logs.snapshots()
      .map(_logListFromSnapshot);
  }

  Stream<List<Map<String, dynamic>>> get drinksList {
    return drinks.snapshots()
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
    final snapshot = users.doc(uid).collection('history').snapshots();
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

  Stream<List<Map<String, dynamic>>> get rotationList {
    return rotation.snapshots()
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

