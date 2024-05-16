import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_app/services/encrypt_data.dart';

class Log {
  final Timestamp? timeStamp;
  final String? message;
  Log({
    this.message,
    this.timeStamp
  });

  void decryptLog(EncryptData cypher) {
    cypher.decrypt(message!);
  }
}
