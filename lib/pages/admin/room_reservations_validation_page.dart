import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../models/room_reservation_model.dart';

class RoomReservationsValidationPage extends StatelessWidget {
  const RoomReservationsValidationPage({super.key});

  Future<void> _approveReservation(RoomReservation res) async {
    await FirestoreService().updateRoomReservation(res.copyWith(status: 'Approved'));
  }

  Future<void> _rejectReservation(RoomReservation res) async {
    await FirestoreService().updateRoomReservation(res.copyWith(status: 'Rejected'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RoomReservation>>(
      stream: FirestoreService().allRoomReservations(),
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
                trailing: res.status == 'Pending'
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () => _approveReservation(res)),
                          IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _rejectReservation(res)),
                        ],
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}
