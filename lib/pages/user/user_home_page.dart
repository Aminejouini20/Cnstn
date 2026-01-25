import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../user/my_room_reservations_page.dart';
import '../user/my_material_requests_page.dart';
import '../profile/profile_page.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _index = 2; // Profile first (welcome)

  final pages = const [
    MyRoomReservationsPage(),
    MyMaterialRequestsPage(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("CNSTN"),
        backgroundColor: const Color(0xFF0B1B33),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),

      drawer: Drawer(
        child: Container(
          color: const Color(0xFF0B1B33),
          child: Column(
            children: [
              const SizedBox(height: 40),

              const CircleAvatar(
                radius: 42,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Color(0xFF0B1B33)),
              ),

              const SizedBox(height: 12),
              const Text(
                "Welcome",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 6),
              const Text(
                "CNSTN Employee",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),

              const SizedBox(height: 30),
              _drawerItem(Icons.person, "Profile", 2),
              _drawerItem(Icons.meeting_room, "My Rooms", 0),
              _drawerItem(Icons.inventory, "My Materials", 1),

              const Spacer(),

              // Logout button
              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Logout",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: pages[_index],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 14,
              offset: const Offset(0, -6),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF0B1B33),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.meeting_room),
              label: "Rooms",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: "Material",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),

      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/roomReservationForm'),
              child: const Icon(Icons.add),
              backgroundColor: const Color(0xFF0B1B33),
            )
          : _index == 1
              ? FloatingActionButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/materialRequestForm'),
                  child: const Icon(Icons.add),
                  backgroundColor: const Color(0xFF0B1B33),
                )
              : null,
    );
  }

  Widget _drawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        setState(() => _index = index);
        Navigator.pop(context);
      },
    );
  }
}
