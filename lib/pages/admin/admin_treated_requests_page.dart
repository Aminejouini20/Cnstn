import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../models/material_request_model.dart';
import '../../models/room_reservation_model.dart';

class AdminTreatedRequestsPage extends StatelessWidget {
  final FirestoreService _firestore = FirestoreService();

  AdminTreatedRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Treated Requests'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Materials'),
              Tab(text: 'Rooms'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _materials(),
            _rooms(),
          ],
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

        return ListView.builder(
          itemCount: snap.data!.length,
          itemBuilder: (_, i) {
            final item = snap.data![i];
            return ListTile(
              leading: const Icon(Icons.inventory_2),
              title: Text(item.article),
              subtitle: Text(item.status.toUpperCase()),
            );
          },
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

        return ListView.builder(
          itemCount: snap.data!.length,
          itemBuilder: (_, i) {
            final item = snap.data![i];
            return ListTile(
              leading: const Icon(Icons.meeting_room),
              title: Text(item.reason),
              subtitle: Text(item.status.toUpperCase()),
            );
          },
        );
      },
    );
  }
}
