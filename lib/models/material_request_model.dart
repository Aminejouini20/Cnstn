import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialRequestModel {
  final String id;
  final String userId;
  final String requesterName;
  final String direction;
  final String article;
  final String technicalDetails;
  final String justification;
  final String status;
  final String adminComment;
  final DateTime createdAt;

  MaterialRequestModel({
    required this.id,
    required this.userId,
    required this.requesterName,
    required this.direction,
    required this.article,
    required this.technicalDetails,
    required this.justification,
    required this.status,
    required this.adminComment,
    required this.createdAt,
  });

  factory MaterialRequestModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return MaterialRequestModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      requesterName: data['requesterName'] ?? '',
      direction: data['direction'] ?? '',
      article: data['article'] ?? '',
      technicalDetails: data['technicalDetails'] ?? '',
      justification: data['justification'] ?? '',
      status: data['status'] ?? 'pending',
      adminComment: data['adminComment'] ?? '',
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
