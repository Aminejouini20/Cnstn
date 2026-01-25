import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../admin/material_requests_validation_page.dart';
import '../admin/room_reservations_validation_page.dart';
import '../admin/admin_users_page.dart';
import '../admin/admin_treated_requests_page.dart';
import '../admin/admin_dashboard_page.dart';
import '../profile/profile_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late Widget _currentPage;
  late String _title;

  /// Pages list (ORDER IS IMPORTANT)
  final List<_AdminPage> _pages = [
    _AdminPage("Dashboard", const AdminDashboardPage()),
    _AdminPage("Material Requests",
        const MaterialRequestsValidationPage()),
    _AdminPage("Room Reservations",
        const RoomReservationsValidationPage()),
    _AdminPage("Treated Requests", AdminTreatedRequestsPage()),
    _AdminPage("Users", AdminUsersPage()),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// 👇 GET INDEX FROM ROUTE
    final int initialIndex =
        ModalRoute.of(context)?.settings.arguments as int? ?? 0;

    final safeIndex =
        initialIndex.clamp(0, _pages.length - 1);

    _title = _pages[safeIndex].title;
    _currentPage = _pages[safeIndex].page;
  }

  void _navigateTo(int index) {
    setState(() {
      _title = _pages[index].title;
      _currentPage = _pages[index].page;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        elevation: 0.8,
      ),

      /// ===== DRAWER =====
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1565C0)),
              child: Center(
                child: Text(
                  "CNSTN Admin",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            _drawerItem(Icons.dashboard, "Dashboard",
                () => _navigateTo(0)),

            _drawerItem(Icons.inventory, "Material Requests",
                () => _navigateTo(1)),

            _drawerItem(Icons.meeting_room, "Room Reservations",
                () => _navigateTo(2)),

            _drawerItem(Icons.check_circle, "Treated Requests",
                () => _navigateTo(3)),

            _drawerItem(Icons.people, "Users",
                () => _navigateTo(4)),

            const Divider(),

            _drawerItem(Icons.person, "My Profile", () {
              setState(() {
                _title = "My Profile";
                _currentPage = const UserProfilePage();
              });
              Navigator.pop(context);
            }),

            const Spacer(),

            /// ===== LOGOUT (BOTTOM) =====
            _drawerItem(Icons.logout, "Logout", () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (_) => false,
              );
            }),
          ],
        ),
      ),

      /// ===== PAGE CONTENT =====
      body: _currentPage,
    );
  }

  Widget _drawerItem(
      IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1565C0)),
      title: Text(title),
      onTap: onTap,
    );
  }
}

/// ===== PAGE MODEL =====
class _AdminPage {
  final String title;
  final Widget page;

  _AdminPage(this.title, this.page);
}
