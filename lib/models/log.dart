import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  final Timestamp? timeStamp;
  final String? message;
  Log({
    this.message,
    this.timeStamp
  });
}