import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/room_reservation_model.dart';

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

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            return Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                title: Text(item.reason),
                subtitle: Text("Status: ${item.status}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await _firestore.deleteRoomReservation(item.id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
