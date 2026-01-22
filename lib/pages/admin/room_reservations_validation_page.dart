import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../models/room_reservation_model.dart';

class RoomReservationsValidationPage extends StatefulWidget {
  const RoomReservationsValidationPage({super.key});

  @override
  State<RoomReservationsValidationPage> createState() =>
      _RoomReservationsValidationPageState();
}

class _RoomReservationsValidationPageState
    extends State<RoomReservationsValidationPage> {
  final FirestoreService _firestore = FirestoreService();
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            onChanged: (v) => setState(() => search = v.toLowerCase()),
            decoration: InputDecoration(
              hintText: "Search by reason or requester",
              prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Expanded(
          child: StreamBuilder<List<RoomReservationModel>>(
            stream: _firestore.getPendingRoomReservations(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Error loading reservations"));
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final list = snapshot.data!
                  .where((e) =>
                      e.reason.toLowerCase().contains(search) ||
                      e.requesterName.toLowerCase().contains(search))
                  .toList();

              if (list.isEmpty) {
                return const Center(child: Text("No pending reservations"));
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];

                  return _card(
                    title: item.reason,
                    subtitle:
                        "${item.requesterName} • ${item.reservationDate.toLocal()}",
                    onApprove: () async {
                      await _firestore.updateRoomReservation(item.id, {
                        'status': 'approved',
                        'adminComment': 'Approved',
                      });
                    },
                    onReject: () async {
                      await _firestore.updateRoomReservation(item.id, {
                        'status': 'rejected',
                        'adminComment': 'Rejected',
                      });
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _card({
    required String title,
    required String subtitle,
    required VoidCallback onApprove,
    required VoidCallback onReject,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: _box(),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: onApprove,
            ),
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.redAccent),
              onPressed: onReject,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _box() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      );
}
