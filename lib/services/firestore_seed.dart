import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSeed {
  static final _db = FirebaseFirestore.instance;

  static Future<void> seed() async {
    await _db.collection('users').doc('ADMIN_INIT').set({
      'firstName': 'Admin',
      'lastName': 'CNSTN',
      'email': 'admin@cnstn.tn',
      'role': 'admin',
      'direction': 'DSIN',
      'service': 'Informatique',
    });
  }
}
