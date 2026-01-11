import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<User?> login(String email, String password) async {
    final res = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return res.user;
  }

  Future<User?> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String direction,
    required String service,
  }) async {
    final res = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _db.collection('users').doc(res.user!.uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': 'user',
      'direction': direction,
      'service': service,
    });

    return res.user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
