import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> login(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return result.user;
  }

  Future<User?> register({
    required String email,
    required String password,
    required String name,
    required String direction,
    required String position,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    // create user profile in Firestore
    await _db.collection('users').doc(result.user!.uid).set({
      'Direction': 'Informatique',
      'direction': direction.isEmpty ? '*' : direction,
      'email': email,
      'name': name,
      'position': position.isEmpty ? '*' : position,
      'role': 'employee',
      'profileImage': '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return result.user;
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
