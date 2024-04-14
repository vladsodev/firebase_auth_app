import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/models/log.dart';
import 'package:firebase_auth_app/services/encrypt_data.dart';

class DatabaseService {

  final CollectionReference logCollection = FirebaseFirestore.instance.collection('logs');

  final logDocuments = FirebaseFirestore.instance.collection('logs').snapshots();

  Future addLogOnSignIn(User user) async {
    await logCollection.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('${user.email} signed in')
    });
  }

  Future addLogOnRegister(User user) async {
    await logCollection.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('${user.email} registered')
    });
  }

  Future addLogOnAnonymous(User user) async {
    await logCollection.doc(DateTime.now().toString()).set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': cypher.encrypt('Anonymous user ${user.uid} signed in')
    });
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

  Stream<List<Log>> get logs {
    return logCollection.snapshots()
      .map(_logListFromSnapshot);
  }

}


// class DatabaseService {

//   final String uid;
//   DatabaseService({required this.uid});

//   final CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');

//   Future updateUserData(String sugars, String name, int strength) async {
//     return await brewCollection.doc(uid).set({
//       'sugars': sugars,
//       'name': name,
//       'strength': strength

//     });
//   }
// }
