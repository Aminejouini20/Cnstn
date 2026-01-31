import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../user/my_room_reservations_page.dart';
import '../user/my_material_requests_page.dart';
import '../profile/profile_page.dart';
import 'user_dashboard_page.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _index = 0;

  final pages = const [
    UserDashboardPage(), // ⭐ Home dashboard
    MyRoomReservationsPage(),
    MyMaterialRequestsPage(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),

      body: pages[_index],

      // ✅ Samsung style bottom bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0B1B33),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.meeting_room_rounded), label: "Rooms"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_rounded), label: "Materials"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profile"),
        ],
      ),

      // Floating button contextuel
      floatingActionButton: _index == 1
          ? FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/roomReservationForm'),
              backgroundColor: const Color(0xFF0B1B33),
              child: const Icon(Icons.add),
            )
          : _index == 2
              ? FloatingActionButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/materialRequestForm'),
                  backgroundColor: const Color(0xFF0B1B33),
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }
}
