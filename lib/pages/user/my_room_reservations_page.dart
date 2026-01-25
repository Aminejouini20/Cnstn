import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/room_reservation_model.dart';
import 'room_reservation_details_page.dart';

class MyRoomReservationsPage extends StatefulWidget {
  const MyRoomReservationsPage({super.key});

  @override
  State<MyRoomReservationsPage> createState() => _MyRoomReservationsPageState();
}

class _MyRoomReservationsPageState extends State<MyRoomReservationsPage> {
  final FirestoreService _firestore = FirestoreService();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RoomReservationModel>>(
      stream: _firestore.getUserRoomReservations(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final list = snapshot.data!;
        if (list.isEmpty) {
          return const Center(child: Text("No room reservations yet"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RoomReservationDetailsPage(reservation: item),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  title: Text(item.reason, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Time: ${item.timeSlot}"),
                  trailing: _statusBadge(item.status),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    if (status == 'approved') color = Colors.green;
    else if (status == 'rejected') color = Colors.red;
    else color = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
