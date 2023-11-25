import 'dart:convert';

import 'package:retailed_mart/common/constant/app_collections.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String email;
  final String uid;
  String fullName;
  String address;
  bool isApproved;
  DateTime createdAt;
  UserModel({
    required this.email,
    required this.uid,
    required this.fullName,
    required this.address,
    required this.isApproved,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'uid': uid,
      'fullName': fullName,
      'address': address,
      'isApproved': isApproved,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      uid: map['uid'] as String,
      fullName: map['fullName'] as String,
      address: map['address'] as String,
      isApproved: (map['isApproved'] ?? false) as bool,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
