import 'package:flutter/material.dart';
import 'material_requests_validation_page.dart';
import 'room_reservations_validation_page.dart';
import '../../services/auth_service.dart';
import '../../core/app_routes.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  final _pages = [
    const MaterialRequestsValidationPage(),
    const RoomReservationsValidationPage(),
  ];

  void _onSelectItem(int index) {
    setState(() => _selectedIndex = index);
    Navigator.pop(context); // close drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Admin Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Material Requests'),
              onTap: () => _onSelectItem(0),
            ),
            ListTile(
              leading: const Icon(Icons.meeting_room),
              title: const Text('Room Reservations'),
              onTap: () => _onSelectItem(1),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await AuthService().logout();
                if (!mounted) return;
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
