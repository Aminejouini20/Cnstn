import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../core/app_routes.dart';
import '../../services/firestore_service.dart';
import '../../core/constants/cloudinary_constants.dart';

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

  Future<String> uploadProfileImageToCloudinary() async {
    final uri = Uri.parse(CloudinaryConstants.uploadUrl);

    final request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] = CloudinaryConstants.uploadPreset;
    request.files.add(
      await http.MultipartFile.fromPath('file', pickedImage!.path),
    );

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = json.decode(resBody);
      return data['secure_url'];
    } else {
      throw Exception("Cloudinary upload failed");
    }
  }

  Future<void> register() async {
    setState(() => loading = true);

    try {
      final userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      final uid = userCred.user!.uid;

      String imageUrl = '';
      if (pickedImage != null) {
        imageUrl = await uploadProfileImageToCloudinary();
      }

      final fs = FirestoreService();
      await fs.createUser(uid, {
        'Direction': 'Informatique',
        'direction': directionCtrl.text.trim().isEmpty
            ? '*'
            : directionCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
        'name': nameCtrl.text.trim(),
        'position': positionCtrl.text.trim().isEmpty
            ? '*'
            : positionCtrl.text.trim(),
        'profileImage': imageUrl,
        'role': 'employee',
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

  Widget _buildField(TextEditingController ctrl, String label, IconData icon,
      {bool hide = false}) {
    return Container(
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
        controller: ctrl,
        obscureText: hide,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter your $label',
          prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
          filled: true,
          fillColor: const Color(0xFFF7F9FC),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: ListView(
            children: [
              const SizedBox(height: 25),

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

              _buildField(nameCtrl, "Full Name", Icons.person),
              const SizedBox(height: 12),
              _buildField(emailCtrl, "Email", Icons.email),
              const SizedBox(height: 12),
              _buildField(passCtrl, "Password", Icons.lock, hide: true),
              const SizedBox(height: 12),
              _buildField(directionCtrl, "Direction", Icons.apartment),
              const SizedBox(height: 12),
              _buildField(positionCtrl, "Position", Icons.work),

              const SizedBox(height: 18),

              ElevatedButton(
                onPressed: loading ? null : register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
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
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, AppRoutes.login),
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
