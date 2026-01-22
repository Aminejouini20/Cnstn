import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final nameCtrl = TextEditingController();
  final directionCtrl = TextEditingController();
  final positionCtrl = TextEditingController();

  String profileUrl = '';
  File? image;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data()!;
    setState(() {
      nameCtrl.text = data['name'] ?? '';
      directionCtrl.text = data['direction'] ?? '';
      positionCtrl.text = data['position'] ?? '';
      profileUrl = data['profileImage'] ?? '';
    });
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() {
      image = File(picked.path);
    });
  }

  Future<void> _saveProfile() async {
    setState(() => loading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    String imgUrl = profileUrl;
    if (image != null) {
      final ref = FirebaseStorage.instance.ref().child('profiles/$uid.jpg');
      await ref.putFile(image!);
      imgUrl = await ref.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': nameCtrl.text.trim(),
      'direction': directionCtrl.text.trim(),
      'position': positionCtrl.text.trim(),
      'profileImage': imgUrl,
    });

    setState(() => loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.6,
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 62,
                    backgroundColor: const Color(0xFFECEFF1),
                    backgroundImage: image != null
                        ? FileImage(image!)
                        : (profileUrl != '' ? NetworkImage(profileUrl) : null) as ImageProvider?,
                    child: profileUrl == '' && image == null
                        ? const Icon(Icons.person, size: 50, color: Color(0xFF1565C0))
                        : null,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            buildTextField(nameCtrl, "Full Name", Icons.person),
            const SizedBox(height: 12),
            buildTextField(directionCtrl, "Direction", Icons.location_city),
            const SizedBox(height: 12),
            buildTextField(positionCtrl, "Position", Icons.work),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 5,
              ),
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Save Profile",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController ctrl, String label, IconData icon) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF1565C0)),
        prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
        filled: true,
        fillColor: const Color(0xFFF7F9FC),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFB0BEC5), width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
