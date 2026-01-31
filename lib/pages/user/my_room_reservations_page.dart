import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/room_reservation_model.dart';
import 'room_reservation_details_page.dart';

class MyRoomReservationsPage extends StatelessWidget {
  const MyRoomReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final firestore = FirestoreService();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: StreamBuilder<List<RoomReservationModel>>(
          stream: firestore.getUserRoomReservations(uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final list = snapshot.data!;

            /// ===== EMPTY STATE =====
            if (list.isEmpty) {
              return Column(
                children: [
                  _header(0),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "No room reservations yet",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              );
            }

            /// ===== LIST =====
            return Column(
              children: [
                /// HEADER WITH COUNTER
                _header(list.length),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final item = list[i];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RoomReservationDetailsPage(reservation: item),
                            ),
                          );
                        },
                        child: _modernCard(item),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// ================= HEADER WITH COUNTER =================
  Widget _header(int count) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "My Room Reservations",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// Counter badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= MODERN CARD =================
  Widget _modernCard(RoomReservationModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE8F0FE),
            child: Icon(Icons.meeting_room, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 14),

          /// Reason + Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.reason,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text("Time: ${item.timeSlot}",
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),

          /// Status Badge
          _statusBadge(item.status),
        ],
      ),
    );
  }

  /// ================= STATUS BADGE =================
  Widget _statusBadge(String status) {
    Color color = status == 'approved'
        ? Colors.green
        : status == 'rejected'
            ? Colors.red
            : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
