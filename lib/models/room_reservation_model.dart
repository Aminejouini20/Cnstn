import 'package:cloud_firestore/cloud_firestore.dart';

class RoomReservation {
  final String id;
  final String userId;
  final String roomNumber;
  final DateTime from;
  final DateTime to;
  final String status;

  RoomReservation({
    required this.id,
    required this.userId,
    required this.roomNumber,
    required this.from,
    required this.to,
    required this.status,
  });

  factory RoomReservation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RoomReservation(
      id: doc.id,
      userId: data['userId'] ?? '',
      roomNumber: data['roomNumber'] ?? '',
      from: (data['from'] as Timestamp).toDate(),
      to: (data['to'] as Timestamp).toDate(),
      status: data['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'roomNumber': roomNumber,
      'from': from,
      'to': to,
      'status': status,
    };
  }

  RoomReservation copyWith({
    String? id,
    String? userId,
    String? roomNumber,
    DateTime? from,
    DateTime? to,
    String? status,
  }) {
    return RoomReservation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      roomNumber: roomNumber ?? this.roomNumber,
      from: from ?? this.from,
      to: to ?? this.to,
      status: status ?? this.status,
    );
  }
}
