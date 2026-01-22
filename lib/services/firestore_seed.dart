import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSeed {
  static final _db = FirebaseFirestore.instance;

  static Future<void> seedAdmin({
    required String uid,
    required String email,
  }) async {
    await _db.collection('users').doc(uid).set({
      'name': 'Amine',
      'email': 'amine.jouini.545@gmail.com',
      'role': 'admin',
      'profileImage': '',
    });
  }
}
