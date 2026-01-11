import 'package:flutter/material.dart';
import 'material_request_form.dart';
import 'my_material_requests_page.dart';
import 'room_reservation_form.dart';
import 'my_room_reservations_page.dart';
import '../../services/auth_service.dart';
import '../../core/app_routes.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _currentIndex = 0;
  final _pages = [
    MaterialRequestForm(),
    MyMaterialRequestsPage(),
    RoomReservationForm(),
    MyRoomReservationsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          )
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Request Material'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'My Material Requests'),
          BottomNavigationBarItem(icon: Icon(Icons.meeting_room), label: 'Reserve Room'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'My Reservations'),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
