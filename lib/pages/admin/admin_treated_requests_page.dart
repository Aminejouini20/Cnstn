import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../models/material_request_model.dart';
import '../../models/room_reservation_model.dart';
import '../../utils/status_color.dart';

class AdminTreatedRequestsPage extends StatelessWidget {
  final FirestoreService _firestore = FirestoreService();

  AdminTreatedRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Treated Requests"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Materials"),
              Tab(text: "Rooms"),
            ],
          ),
        ),
        body: TabBarView(
          children: [_materials(), _rooms()],
        ),
      ),
    );
  }

  Widget _materials() {
    return StreamBuilder<List<MaterialRequestModel>>(
      stream: _firestore.getTreatedMaterialRequests(),
      builder: (_, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(12),
          children: snap.data!.map((m) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.inventory_2),
                title: Text(m.article),
                subtitle: Text(m.requesterName),
                trailing: Chip(
                  label: Text(m.status.toUpperCase()),
                  backgroundColor: statusColor(m.status).withOpacity(.15),
                  labelStyle: TextStyle(
                    color: statusColor(m.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _rooms() {
    return StreamBuilder<List<RoomReservationModel>>(
      stream: _firestore.getTreatedRoomReservations(),
      builder: (_, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(12),
          children: snap.data!.map((r) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.meeting_room),
                title: Text(r.reason),
                subtitle: Text(r.reason),
                trailing: Chip(
                  label: Text(r.status.toUpperCase()),
                  backgroundColor: statusColor(r.status).withOpacity(.15),
                  labelStyle: TextStyle(
                    color: statusColor(r.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
