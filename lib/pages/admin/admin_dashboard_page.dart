import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../core/app_routes.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fs = FirestoreService();

    /// Navigate to a specific tab in AdminHomePage
    void goToAdminTab(int index) {
      Navigator.pushNamed(
        context,
        AppRoutes.adminHome,
        arguments: index, // 0 = Users tab
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// ===== USERS =====
              _usersCard(
                stream: fs.getUsers(),
                onTap: () => goToAdminTab(4), // 4 = Users list tab
              ),

              const SizedBox(height: 18),

              /// ===== MATERIAL REQUESTS =====
              _requestsCard(
                title: "Material Requests",
                icon: Icons.inventory_2,
                pendingStream: fs.getPendingMaterialRequests(),
                treatedStream: fs.getTreatedMaterialRequests(),
                onTap: () => goToAdminTab(1),
              ),

              const SizedBox(height: 18),

              /// ===== ROOM REQUESTS =====
              _requestsCard(
                title: "Room Requests",
                icon: Icons.meeting_room,
                pendingStream: fs.getPendingRoomReservations(),
                treatedStream: fs.getTreatedRoomReservations(),
                onTap: () => goToAdminTab(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ===== USERS CARD =====
  Widget _usersCard({
    required Stream stream,
    required VoidCallback onTap,
  }) {
    return StreamBuilder(
      stream: stream,
      builder: (_, snap) {
        final count = snap.hasData ? (snap.data as List).length : 0;

        return _card(
          onTap,
          Column(
            children: [
              const Icon(Icons.people,
                  size: 42, color: Color(0xFF1A237E)),
              const SizedBox(height: 12),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Users",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ===== REQUESTS CARD (PENDING / TREATED) =====
  Widget _requestsCard({
    required String title,
    required IconData icon,
    required Stream pendingStream,
    required Stream treatedStream,
    required VoidCallback onTap,
  }) {
    return _card(
      onTap,
      Column(
        children: [
          Icon(icon, size: 38, color: const Color(0xFF00695C)),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 14),

          /// Pending
          StreamBuilder(
            stream: pendingStream,
            builder: (_, s) {
              final pending = s.hasData ? (s.data as List).length : 0;
              return _statusRow(
                emoji: "⏳",
                label: "Pending",
                value: pending,
                color: Colors.orange,
              );
            },
          ),

          const SizedBox(height: 6),

          /// Treated
          StreamBuilder(
            stream: treatedStream,
            builder: (_, s) {
              final treated = s.hasData ? (s.data as List).length : 0;
              return _statusRow(
                emoji: "✅",
                label: "Treated",
                value: treated,
                color: Colors.green,
              );
            },
          ),
        ],
      ),
    );
  }

  /// ===== STATUS ROW =====
  Widget _statusRow({
    required String emoji,
    required String label,
    required int value,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Text(
          "$label:",
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(width: 6),
        Text(
          value.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// ===== SAMSUNG STYLE CARD =====
  Widget _card(VoidCallback onTap, Widget child) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 26),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
