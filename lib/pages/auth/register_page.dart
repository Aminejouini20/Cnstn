import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../core/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final directionCtrl = TextEditingController();
  final positionCtrl = TextEditingController();

  bool loading = false;
  File? pickedImage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() {
        pickedImage = File(img.path);
      });
    }
  }

  Future<String> uploadProfileImage(String uid) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('users')
        .child(uid)
        .child('profile.jpg');

    await ref.putFile(pickedImage!);
    return await ref.getDownloadURL();
  }

  Future<void> register() async {
    setState(() => loading = true);

    try {
      final userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      final uid = userCred.user!.uid;

      String imageUrl = '';
      if (pickedImage != null) {
        imageUrl = await uploadProfileImage(uid);
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': nameCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
        'direction': directionCtrl.text.trim(),
        'position': positionCtrl.text.trim(),
        'role': 'employee',
        'profileImage': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Register failed: ${e.toString()}')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // no AppBar
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: ListView(
            children: [
              const SizedBox(height: 25),

              Center(
                child: Image.asset(
                  'assets/logo/AppLogo.png',
                  height: 110,
                ),
              ),

              const SizedBox(height: 15),

              // Profile image picker
              Center(
                child: GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        pickedImage != null ? FileImage(pickedImage!) : null,
                    child: pickedImage == null
                        ? const Icon(Icons.add_a_photo, color: Color(0xFF1565C0))
                        : null,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Name
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(Icons.person, color: Color(0xFF1565C0)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Email
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email, color: Color(0xFF1565C0)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Password
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF1565C0)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Direction
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: directionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Direction',
                    hintText: 'Enter your direction',
                    prefixIcon: Icon(Icons.apartment, color: Color(0xFF1565C0)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Position
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: positionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Position',
                    hintText: 'Enter your position',
                    prefixIcon: Icon(Icons.work, color: Color(0xFF1565C0)),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Register button
              ElevatedButton(
                onPressed: loading ? null : register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Register",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),

              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xFF1565C0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
