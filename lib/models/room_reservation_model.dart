import 'package:cloud_firestore/cloud_firestore.dart';

class RoomReservationModel {
  final String id;
  final String userId;
  final String requesterName;
  final String direction;
  final String reason;
  final String timeSlot;
  final int participants;
  final String status;
  final String adminComment;
  final DateTime reservationDate;
  final DateTime createdAt;

  RoomReservationModel({
    required this.id,
    required this.userId,
    required this.requesterName,
    required this.direction,
    required this.reason,
    required this.timeSlot,
    required this.participants,
    required this.status,
    required this.adminComment,
    required this.reservationDate,
    required this.createdAt,
  });

  factory RoomReservationModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return RoomReservationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      requesterName: data['requesterName'] ?? '',
      direction: data['direction'] ?? '',
      reason: data['reason'] ?? '',
      timeSlot: data['timeSlot'] ?? '',
      participants: data['participants'] ?? 0,
      status: data['status'] ?? 'pending',
      adminComment: data['adminComment'] ?? '',
      reservationDate: (data['reservationDate'] is Timestamp)
          ? (data['reservationDate'] as Timestamp).toDate()
          : DateTime.now(),
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
