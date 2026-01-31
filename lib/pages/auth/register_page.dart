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
  final positionCtrl = TextEditingController();

  final List<String> directions = const [
    "Direction de la recherche sur l'énergie et la matière",
    "Direction de la recherche sur l'environnement et le vivant",
    "Direction de la valorisation des projets",
    "Direction de la sûreté nucléaire",
    "Direction des relations internationales",
    "Direction des affaires administratives",
  ];

  String? selectedDirection;
  bool loading = false;
  File? pickedImage;

  ////////////////////////////////////////////////////////////
  /// IMAGE PICK
  ////////////////////////////////////////////////////////////
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (img != null) setState(() => pickedImage = File(img.path));
  }

  ////////////////////////////////////////////////////////////
  /// CLOUDINARY UPLOAD
  ////////////////////////////////////////////////////////////
  Future<String> uploadProfileImageToCloudinary() async {
    final uri = Uri.parse(CloudinaryConstants.uploadUrl);
    final request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = CloudinaryConstants.uploadPreset;
    request.files.add(await http.MultipartFile.fromPath('file', pickedImage!.path));

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = json.decode(resBody);
      return data['secure_url'];
    } else {
      throw Exception("Cloudinary upload failed");
    }
  }

  ////////////////////////////////////////////////////////////
  /// REGISTER
  ////////////////////////////////////////////////////////////
  Future<void> register() async {
    if (selectedDirection == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select your direction")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      final uid = userCred.user!.uid;
      String imageUrl = '';

      if (pickedImage != null) imageUrl = await uploadProfileImageToCloudinary();

      final fs = FirestoreService();

      await fs.createUser(uid, {
        'email': emailCtrl.text.trim(),
        'name': nameCtrl.text.trim(),
        'direction': selectedDirection,
        'position': positionCtrl.text.trim().isEmpty ? '*' : positionCtrl.text.trim(),
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

  ////////////////////////////////////////////////////////////
  /// UI
  ////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // IMAGE PICKER
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    decoration: _shadow(),
                    padding: const EdgeInsets.all(4),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: pickedImage != null ? FileImage(pickedImage!) : null,
                      child: pickedImage == null
                          ? const Icon(Icons.add_a_photo, color: Color(0xFF1565C0), size: 30)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // FIELDS
                _field(nameCtrl, "Full Name", Icons.person),
                const SizedBox(height: 16),
                _field(emailCtrl, "Email", Icons.email),
                const SizedBox(height: 16),
                _field(passCtrl, "Password", Icons.lock, hide: true),
                const SizedBox(height: 16),
                _dropdown(),
                const SizedBox(height: 16),
                _field(positionCtrl, "Position", Icons.work),
                const SizedBox(height: 30),

                // REGISTER BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: loading ? null : register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 6,
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Register",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // LOGIN LINK
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
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// FIELD STYLE
  ////////////////////////////////////////////////////////////
  Widget _field(TextEditingController ctrl, String label, IconData icon, {bool hide = false}) {
    return Container(
      decoration: _shadow(),
      child: TextField(
        controller: ctrl,
        obscureText: hide,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// DROPDOWN
  ////////////////////////////////////////////////////////////
  Widget _dropdown() {
    return Container(
      decoration: _shadow(),
      child: DropdownButtonFormField<String>(
        value: selectedDirection,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: "Direction",
          prefixIcon: const Icon(Icons.apartment, color: Color(0xFF1565C0)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        ),
        items: directions
            .map((d) => DropdownMenuItem(
                  value: d,
                  child: Text(
                    d,
                    style: const TextStyle(fontSize: 15),
                  ),
                ))
            .toList(),
        onChanged: (v) => setState(() => selectedDirection = v),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// SHADOW STYLE
  ////////////////////////////////////////////////////////////
  BoxDecoration _shadow() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          )
        ],
      );
}
