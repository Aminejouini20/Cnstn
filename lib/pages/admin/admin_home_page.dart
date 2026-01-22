import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../admin/material_requests_validation_page.dart';
import '../admin/room_reservations_validation_page.dart';
import '../admin/admin_users_page.dart';
import '../admin/admin_treated_requests_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _index = 0;

  final pages = const [
    MaterialRequestsValidationPage(),
    RoomReservationsValidationPage(),
    AdminUsersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: 'Treated Requests',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminTreatedRequestsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory), label: "Materials"),
          BottomNavigationBarItem(
              icon: Icon(Icons.meeting_room), label: "Rooms"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Users"),
        ],
      ),
    );
  }
}
