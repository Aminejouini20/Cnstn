import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String name = "";
  String email = "";
  String direction = "";
  String position = "";
  String role = "";
  String profileImage = "";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    setState(() {
      name = doc.get('name') ?? "";
      email = doc.get('email') ?? "";
      direction = doc.get('direction') ?? "";
      position = doc.get('position') ?? "";
      role = doc.get('role') ?? "";
      profileImage = doc.get('profileImage') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.6,
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            Center(
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
                  backgroundImage: profileImage != ""
                      ? NetworkImage(profileImage)
                      : null,
                  child: profileImage == ""
                      ? Text(
                          name.isNotEmpty ? name[0].toUpperCase() : "U",
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1565C0),
                          ),
                        )
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Infos
            buildInfoTile("Full Name", name, Icons.person),
            buildInfoTile("Email", email, Icons.email),
            buildInfoTile("Direction", direction, Icons.location_city),
            buildInfoTile("Position", position, Icons.work),
            buildInfoTile("Role", role, Icons.shield),

            const SizedBox(height: 20),

            // Edit profile button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 5,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/profileEdit');
              },
              child: const Text(
                "Edit Profile",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildInfoTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1565C0)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
