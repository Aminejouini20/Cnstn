// lib/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.role,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profileImage: data['profileImage'] ?? '',
      role: data['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'role': role,
    };
  }
}
