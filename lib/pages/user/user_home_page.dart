import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/user_model.dart';
import '../user/notifications_page.dart';
import '../user/material_request_form.dart';
import '../user/my_material_requests_page.dart';
import '../user/room_reservation_form.dart';
import '../user/my_room_reservations_page.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final FirestoreService _firestore = FirestoreService();
  int _index = 0;

  final List<Widget> pages = const [
    MyRoomReservationsPage(),
    MyMaterialRequestsPage(),
    NotificationsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CNSTN Dashboard", style: TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.white,
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
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.meeting_room), label: "Rooms"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Material"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
        ],
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/roomReservationForm');
              },
              child: const Icon(Icons.add),
            )
          : _index == 1
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/materialRequestForm');
                  },
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }
}
