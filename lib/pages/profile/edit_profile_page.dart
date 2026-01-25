import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/cloudinary_service.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final nameCtrl = TextEditingController();
  final directionCtrl = TextEditingController();
  final positionCtrl = TextEditingController();

  File? image;
  String profileUrl = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data() ?? {};

    nameCtrl.text = data['name'] ?? '';
    directionCtrl.text = data['direction'] ?? '';
    positionCtrl.text = data['position'] ?? '';
    profileUrl = data['profileImage'] ?? '';

    setState(() => loading = false);
  }

  Future<void> _pickImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  Future<void> _save() async {
    setState(() => loading = true);
    final uid = FirebaseAuth.instance.currentUser!.uid;

    String finalImageUrl = profileUrl;

    // ✅ Upload to Cloudinary ONLY if user picked a new image
    if (image != null) {
      final uploadedUrl =
          await CloudinaryService.uploadProfileImage(image!);

      if (uploadedUrl != null) {
        finalImageUrl = uploadedUrl;
      }
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': nameCtrl.text.trim(),
      'direction': directionCtrl.text.trim(),
      'position': positionCtrl.text.trim(),
      'profileImage': finalImageUrl,
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xFFECEFF1),
                backgroundImage: image != null
                    ? FileImage(image!)
                    : (profileUrl.isNotEmpty
                        ? NetworkImage(profileUrl)
                        : null) as ImageProvider?,
                child: image == null && profileUrl.isEmpty
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
          ),

          const SizedBox(height: 24),

          _field(nameCtrl, "Full Name"),
          _field(directionCtrl, "Direction"),
          _field(positionCtrl, "Position"),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              "Save",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
