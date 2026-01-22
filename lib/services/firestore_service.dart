import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../models/material_request_model.dart';
import '../models/room_reservation_model.dart';
import '../models/notification_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /* ========================= USERS ========================= */

  Stream<List<UserModel>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          return UserModel.fromDoc(doc);
        } catch (e) {
          debugPrint('❌ User parse error (${doc.id}): $e');
          return UserModel(
            id: doc.id,
            name: 'Unknown',
            email: '',
            direction: '',
            position: '',
            role: 'employee',
            profileImage: '',
          );
        }
      }).toList();
    });
  }

  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromDoc(doc);
    } catch (e) {
      debugPrint('❌ getUserById error: $e');
      return null;
    }
  }

  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set(data);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  Future<void> deleteUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }

  /* ========================= MATERIAL REQUESTS ========================= */

  Stream<List<MaterialRequestModel>> getPendingMaterialRequests() {
    return _db
        .collection('material_requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(_mapMaterialList);
  }

  Stream<List<MaterialRequestModel>> getTreatedMaterialRequests() {
    return _db
        .collection('material_requests')
        .where('status', whereIn: ['approved', 'rejected'])
        .snapshots()
        .map(_mapMaterialList);
  }

  Stream<List<MaterialRequestModel>> getUserMaterialRequests(String uid) {
    return _db
        .collection('material_requests')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map(_mapMaterialList);
  }

  Future<void> createMaterialRequest(Map<String, dynamic> data) async {
    await _db.collection('material_requests').add(data);
  }

  Future<void> updateMaterialRequest(String id, Map<String, dynamic> data) async {
    await _db.collection('material_requests').doc(id).update(data);
  }

  Future<void> deleteMaterialRequest(String id) async {
    await _db.collection('material_requests').doc(id).delete();
  }

  List<MaterialRequestModel> _mapMaterialList(QuerySnapshot snap) {
    return snap.docs.map((doc) {
      try {
        return MaterialRequestModel.fromDoc(doc);
      } catch (e) {
        debugPrint('❌ Material parse error (${doc.id}): $e');
        return null;
      }
    }).whereType<MaterialRequestModel>().toList();
  }

  /* ========================= ROOM RESERVATIONS ========================= */

  Stream<List<RoomReservationModel>> getPendingRoomReservations() {
    return _db
        .collection('room_reservations')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(_mapRoomList);
  }

  Stream<List<RoomReservationModel>> getTreatedRoomReservations() {
    return _db
        .collection('room_reservations')
        .where('status', whereIn: ['approved', 'rejected'])
        .snapshots()
        .map(_mapRoomList);
  }

  Stream<List<RoomReservationModel>> getUserRoomReservations(String uid) {
    return _db
        .collection('room_reservations')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map(_mapRoomList);
  }

  Future<void> createRoomReservation(Map<String, dynamic> data) async {
    await _db.collection('room_reservations').add(data);
  }

  Future<void> updateRoomReservation(String id, Map<String, dynamic> data) async {
    await _db.collection('room_reservations').doc(id).update(data);
  }

  Future<void> deleteRoomReservation(String id) async {
    await _db.collection('room_reservations').doc(id).delete();
  }

  List<RoomReservationModel> _mapRoomList(QuerySnapshot snap) {
    return snap.docs.map((doc) {
      try {
        return RoomReservationModel.fromDoc(doc);
      } catch (e) {
        debugPrint('❌ Room parse error (${doc.id}): $e');
        return null;
      }
    }).whereType<RoomReservationModel>().toList();
  }

  /* ========================= NOTIFICATIONS ========================= */

  Stream<List<NotificationModel>> getUserNotifications(String uid) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          return NotificationModel.fromDoc(doc);
        } catch (e) {
          debugPrint('❌ Notification error (${doc.id}): $e');
          return null;
        }
      }).whereType<NotificationModel>().toList();
    });
  }

  Future<void> createNotification(Map<String, dynamic> data) async {
    await _db.collection('notifications').add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'read': false,
    });
  }

  Future<void> markNotificationRead(String id) async {
    await _db.collection('notifications').doc(id).update({'read': true});
  }

  Future<void> deleteNotification(String id) async {
    await _db.collection('notifications').doc(id).delete();
  }
}
