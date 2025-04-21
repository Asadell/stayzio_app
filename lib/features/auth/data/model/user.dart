// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final int? id;
  final String fullName;
  final String email;
  final String password;
  final String? phoneNumber;
  final String? username;
  final String? profileImage;
  final String? createdAt;

  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.username,
    this.profileImage,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'username': username,
      'profileImage': profileImage,
      'createdAt': createdAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as int : null,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      profileImage:
          map['profileImage'] != null ? map['profileImage'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
