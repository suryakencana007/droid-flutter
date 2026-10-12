import 'package:flutter/foundation.dart';

@immutable
class User {
  const User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
      );

  final String id;
  final String name;
  final String email;

  String get initials => name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};

  User copyWith({String? id, String? name, String? email}) => User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
      );

  @override
  bool operator ==(Object other) =>
      other is User && other.id == id && other.name == name && other.email == email;

  @override
  int get hashCode => Object.hash(id, name, email);
}
