import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/room_reservation_model.dart';

class MyRoomReservationsPage extends StatelessWidget {
  const MyRoomReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Center(child: Text('Not logged in'));

    return StreamBuilder<List<RoomReservation>>(
      stream: FirestoreService().myRoomReservations(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('No reservations'));

        final reservations = snapshot.data!;
        return ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final res = reservations[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text('Room: ${res.roomNumber}'),
                subtitle: Text('From: ${res.from.toLocal().toString().split(' ')[0]}\nTo: ${res.to.toLocal().toString().split(' ')[0]}\nStatus: ${res.status}'),
              ),
            );
          },
        );
      },
    );
  }
}
