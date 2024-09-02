// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class VcoffeeOrder {
  int? id;
  final String name;
  final double price;
  String timestamp;
  String buyer;
  VcoffeeOrder({
    this.id,
    required this.name,
    required this.price,
    required this.timestamp,
    required this.buyer,
  });

  VcoffeeOrder copyWith({
    int? id,
    String? name,
    double? price,
    String? timestamp,
    String? buyer,
  }) {
    return VcoffeeOrder(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      timestamp: timestamp ?? this.timestamp,
      buyer: buyer ?? this.buyer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'timestamp': timestamp,
      'buyer': buyer,
    };
  }

  factory VcoffeeOrder.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VcoffeeOrder(
      id: data['id'],
      name: data['name'],
      price: data['price'],
      timestamp: data['timestamp'],
      buyer: data['buyer'],
    );
  }

  factory VcoffeeOrder.fromMap(Map<String, dynamic> map) {
    return VcoffeeOrder(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      price: map['price'] as double,
      timestamp: map['timestamp'] as String,
      buyer: map['buyer'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory VcoffeeOrder.fromJson(String source) => VcoffeeOrder.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(id: $id, name: $name, price: $price, timestamp: $timestamp, buyer: $buyer)';
  }

  @override
  bool operator ==(covariant VcoffeeOrder other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.price == price &&
      other.timestamp == timestamp &&
      other.buyer == buyer;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      price.hashCode ^
      timestamp.hashCode ^
      buyer.hashCode;
  }
}

class Drink {
  int? id;
  final String name;
  final String description;
  final double price;
  final bool cold;
  final bool milky;
  final bool sweet;
  final bool sour;
  final int strength;
  Drink({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.cold,
    required this.milky,
    required this.sweet,
    required this.sour,
    required this.strength,
  });

  Drink copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    bool? cold,
    bool? milky,
    bool? sweet,
    bool? sour,
    int? strength,
  }) {
    return Drink(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      cold: cold ?? this.cold,
      milky: milky ?? this.milky,
      sweet: sweet ?? this.sweet,
      sour: sour ?? this.sour,
      strength: strength ?? this.strength,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'cold': cold,
      'milky': milky,
      'sweet': sweet,
      'sour': sour,
      'strength': strength,
    };
  }

  factory Drink.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Drink(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      price: data['price'],
      cold: data['cold'],
      milky: data['milky'],
      sweet: data['sweet'],
      sour: data['sour'],
      strength: data['strength'],
    );
  }

  factory Drink.fromMap(Map<String, dynamic> map) {
    return Drink(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      cold: map['cold'] as bool,
      milky: map['milky'] as bool,
      sweet: map['sweet'] as bool,
      sour: map['sour'] as bool,
      strength: map['strength'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Drink.fromJson(String source) => Drink.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Drink(id: $id, name: $name, description: $description, price: $price, cold: $cold, milky: $milky, sweet: $sweet, sour: $sour, strength: $strength)';
  }

  @override
  bool operator ==(covariant Drink other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.price == price &&
      other.cold == cold &&
      other.milky == milky &&
      other.sweet == sweet &&
      other.sour == sour &&
      other.strength == strength;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      price.hashCode ^
      cold.hashCode ^
      milky.hashCode ^
      sweet.hashCode ^
      sour.hashCode ^
      strength.hashCode;
  }
}
