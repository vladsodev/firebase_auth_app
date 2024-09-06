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
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? dateOfBirth;
  final bool isAnonymous;
  final String? timestamp;
  final bool? isAdmin;
  final bool? isOperator;
  UserModel({
    required this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.dateOfBirth,
    required this.isAnonymous,
    this.timestamp,
    this.isAdmin,
    this.isOperator,
  });
 

  UserModel copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? dateOfBirth,
    bool? isAnonymous,
    String? timestamp,
    bool? isAdmin,
    bool? isOperator,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      timestamp: timestamp ?? this.timestamp,
      isAdmin: isAdmin ?? this.isAdmin,
      isOperator: isOperator ?? this.isOperator,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'isAnonymous': isAnonymous,
      'timestamp': timestamp,
      'isAdmin': isAdmin,
      'isOperator': isOperator,
    };
  }

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      isAnonymous: user.isAnonymous,
      timestamp: DateTime.now().toString(),
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      dateOfBirth: map['dateOfBirth'] != null ? map['dateOfBirth'] as String : null,
      isAnonymous: map['isAnonymous'] as bool,
      timestamp: map['timestamp'] != null ? map['timestamp'] as String : null,
      isAdmin: map['isAdmin'] != null ? map['isAdmin'] as bool : null,
      isOperator: map['isOperator'] != null ? map['isOperator'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, dateOfBirth: $dateOfBirth, isAnonymous: $isAnonymous, timestamp: $timestamp, isAdmin: $isAdmin, isOperator: $isOperator)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.email == email &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.phoneNumber == phoneNumber &&
      other.dateOfBirth == dateOfBirth &&
      other.isAnonymous == isAnonymous &&
      other.timestamp == timestamp &&
      other.isAdmin == isAdmin &&
      other.isOperator == isOperator;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      email.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      phoneNumber.hashCode ^
      dateOfBirth.hashCode ^
      isAnonymous.hashCode ^
      timestamp.hashCode ^
      isAdmin.hashCode ^
      isOperator.hashCode;
  }
}
