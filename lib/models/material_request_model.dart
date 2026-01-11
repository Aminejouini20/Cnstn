import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialRequest {
  final String id;
  final String userId;
  final String materialName;
  final int quantity;
  final String status;

  MaterialRequest({
    required this.id,
    required this.userId,
    required this.materialName,
    required this.quantity,
    required this.status,
  });

  factory MaterialRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MaterialRequest(
      id: doc.id,
      userId: data['userId'] ?? '',
      materialName: data['materialName'] ?? '',
      quantity: data['quantity'] ?? 0,
      status: data['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'materialName': materialName,
      'quantity': quantity,
      'status': status,
    };
  }

  MaterialRequest copyWith({
    String? id,
    String? userId,
    String? materialName,
    int? quantity,
    String? status,
  }) {
    return MaterialRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      materialName: materialName ?? this.materialName,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
    );
  }
}
