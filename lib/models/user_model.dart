class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String direction;
  final String service;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.direction,
    required this.service,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      role: data['role'],
      direction: data['direction'],
      service: data['service'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'direction': direction,
      'service': service,
    };
  }
}
