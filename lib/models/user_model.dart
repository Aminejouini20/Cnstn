import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String direction;
  final String position;
  final String role;
  final String profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.direction,
    required this.position,
    required this.role,
    required this.profileImage,
  });

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      direction: data['direction'] ?? '',
      position: data['position'] ?? '',
      role: data['role'] ?? 'employee',
      profileImage: data['profileImage'] ?? '',
    );
  }
}
