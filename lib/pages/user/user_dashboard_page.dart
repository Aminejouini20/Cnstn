import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDashboardPage extends StatelessWidget {
  const UserDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ===== Welcome Header =====
              Text(
                "Welcome,",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 6),

              /// ===== Fetch User Name from Firestore =====
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid) // current user UID
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text(
                      "User",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B1B33),
                      ),
                    );
                  }

                  // Get the user's name from Firestore
                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                  final userName = userData['name'] ?? 'User';

                  return Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B1B33),
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              /// ===== Grid cards =====
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [

                    /// ===== ROOMS → DIRECT REQUEST =====
                    _dashboardCard(
                      context,
                      icon: Icons.meeting_room_rounded,
                      title: "Rooms",
                      subtitle: "Reserve a room",
                      color: Colors.blue,
                      onTap: () =>
                          Navigator.pushNamed(context, '/roomReservationForm'),
                    ),

                    /// ===== MATERIALS → DIRECT REQUEST =====
                    _dashboardCard(
                      context,
                      icon: Icons.inventory_2_rounded,
                      title: "Materials",
                      subtitle: "Request material",
                      color: Colors.orange,
                      onTap: () =>
                          Navigator.pushNamed(context, '/materialRequestForm'),
                    ),

                    /// ===== MY ROOM RESERVATIONS =====
                    _dashboardCard(
                      context,
                      icon: Icons.history_rounded,
                      title: "My Rooms",
                      subtitle: "Reservations history",
                      color: Colors.green,
                      onTap: () =>
                          Navigator.pushNamed(context, '/myRoomReservations'),
                    ),

                    /// ===== MY MATERIAL REQUESTS =====
                    _dashboardCard(
                      context,
                      icon: Icons.receipt_long_rounded,
                      title: "My Materials",
                      subtitle: "Requests history",
                      color: Colors.purple,
                      onTap: () =>
                          Navigator.pushNamed(context, '/myMaterialRequests'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ===== Modern Samsung-style card =====
  Widget _dashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(.15),
              child: Icon(icon, color: color),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}