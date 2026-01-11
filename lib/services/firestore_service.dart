import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/material_request_model.dart';
import '../models/room_reservation_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  /// ----------------- User Role -----------------
  Future<String> getUserRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return 'user';
    return doc.data()?['role'] ?? 'user';
  }

  /// ----------------- Material Requests -----------------

  // Create material request
  Future<void> createMaterialRequest(MaterialRequest request) async {
    await _db.collection('material_requests').add(request.toMap());
  }

  // Get current user's material requests (user page)
  Stream<List<MaterialRequest>> myMaterialRequests(String uid) {
    return _db
        .collection('material_requests')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MaterialRequest.fromFirestore(doc)).toList());
  }

  // Get all material requests (admin page)
  Stream<List<MaterialRequest>> allMaterialRequests() {
    return _db.collection('material_requests').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => MaterialRequest.fromFirestore(doc))
            .toList());
  }

  // Update material request status
  Future<void> updateMaterialRequest(MaterialRequest request) async {
    await _db.collection('material_requests').doc(request.id).update(request.toMap());
  }

  /// ----------------- Room Reservations -----------------

  // Create room reservation
  Future<void> createRoomReservation(RoomReservation reservation) async {
    await _db.collection('room_reservations').add(reservation.toMap());
  }

  // Get current user's room reservations
  Stream<List<RoomReservation>> myRoomReservations(String uid) {
    return _db
        .collection('room_reservations')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RoomReservation.fromFirestore(doc))
            .toList());
  }

  // Get all room reservations (admin page)
  Stream<List<RoomReservation>> allRoomReservations() {
    return _db.collection('room_reservations').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => RoomReservation.fromFirestore(doc))
            .toList());
  }

  // Update room reservation status
  Future<void> updateRoomReservation(RoomReservation reservation) async {
    await _db
        .collection('room_reservations')
        .doc(reservation.id)
        .update(reservation.toMap());
  }
}
