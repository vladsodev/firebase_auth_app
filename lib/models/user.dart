// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class MyUser {
  final String uid;
  final String ?email;
  MyUser({
    required this.uid,
    this.email
  });
}

class UserModel {
  final String uid;
  final String? email;
  final bool isAuthenticated;
  final String? timestamp;
  final bool isAdmin = false;
  final bool isOperator = false;
  UserModel({
    required this.uid,
    this.email,
    required this.isAuthenticated,
    this.timestamp,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    bool? isAuthenticated,
    String? timestamp,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'isAuthenticated': isAuthenticated,
      'timestamp': timestamp,
    };
  }

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      isAuthenticated: user.isAnonymous,
      timestamp: FieldValue.serverTimestamp().toString(),
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      isAuthenticated: map['isAuthenticated'] as bool,
      timestamp: map['timestamp'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, isAuthenticated: $isAuthenticated, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.email == email &&
      other.isAuthenticated == isAuthenticated &&
      other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      email.hashCode ^
      isAuthenticated.hashCode ^
      timestamp.hashCode;
  }
}
