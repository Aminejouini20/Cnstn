import 'package:flutter/material.dart';
import '../../models/room_reservation_model.dart';
import '../../services/firestore_service.dart';

class RoomReservationDetailsPage extends StatelessWidget {
  final RoomReservationModel reservation;
  const RoomReservationDetailsPage({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservation Details"),
        backgroundColor: const Color.fromARGB(255, 240, 241, 243),
      ),
      backgroundColor: const Color(0xFFF4F6F8),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _detailCard("Reason", reservation.reason),
            _detailCard("Time Slot", reservation.timeSlot),
            _detailCard("Participants", reservation.participants.toString()),
            _detailCard("Direction", reservation.direction),
            _detailCard("Status", reservation.status),
            _detailCard("Admin Comment", reservation.adminComment.isEmpty ? "—" : reservation.adminComment),

            const SizedBox(height: 24),

            if (reservation.status == 'pending')
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: () async {
                  await FirestoreService().deleteRoomReservation(reservation.id);
                  Navigator.pop(context);
                },
                child: const Text("Delete Reservation"),
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
