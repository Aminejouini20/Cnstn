import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/app_routes.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        final name = data['name'] ?? '';
        final email = data['email'] ?? '';
        final direction = data['direction'] ?? '';
        final position = data['position'] ?? '';
        final role = data['role'] ?? 'employee';
        final profileImage = data['profileImage'] ?? '';

        return Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              /// AVATAR
              Center(
                child: CircleAvatar(
                  radius: 62,
                  backgroundColor: const Color(0xFFECEFF1),
                  backgroundImage:
                      profileImage.isNotEmpty ? NetworkImage(profileImage) : null,
                  child: profileImage.isEmpty
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

              const SizedBox(height: 16),

              Center(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 6),

              Center(
                child: Chip(
                  backgroundColor:
                      role == 'admin' ? Colors.redAccent : Colors.blueAccent,
                  label: Text(
                    role.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _infoTile("Email", email, Icons.email),
              _infoTile("Direction", direction, Icons.location_city),
              _infoTile("Position", position, Icons.work),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.profileEdit);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1565C0)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
