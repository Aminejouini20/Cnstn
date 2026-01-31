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
        backgroundColor: const Color(0xffF6F7FB),

        ////////////////////////////////////////////////////////////
        /// APP BAR (NO TITLE - CLEAN SAMSUNG STYLE)
        ////////////////////////////////////////////////////////////

        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          toolbarHeight: 8, // minimal height (no title space)

          bottom: const TabBar(
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            tabs: [
              Tab(text: "Materials"),
              Tab(text: "Rooms"),
            ],
          ),
        ),

        ////////////////////////////////////////////////////////////

        body: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: TabBarView(
            children: [
              _MaterialsTab(),
              _RoomsTab(),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// MATERIALS TAB
////////////////////////////////////////////////////////////

class _MaterialsTab extends StatelessWidget {
  const _MaterialsTab();

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return StreamBuilder<List<MaterialRequestModel>>(
      stream: firestore.getTreatedMaterialRequests(),
      builder: (_, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: snap.data!.length,
          itemBuilder: (_, i) {
            final m = snap.data![i];

            return _ModernCard(
              icon: Icons.inventory_2_outlined,
              title: m.article,
              subtitle: m.requesterName,
              status: m.status,
            );
          },
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////
/// ROOMS TAB
////////////////////////////////////////////////////////////

class _RoomsTab extends StatelessWidget {
  const _RoomsTab();

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return StreamBuilder<List<RoomReservationModel>>(
      stream: firestore.getTreatedRoomReservations(),
      builder: (_, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: snap.data!.length,
          itemBuilder: (_, i) {
            final r = snap.data![i];

            return _ModernCard(
              icon: Icons.meeting_room_outlined,
              title: r.reason,
              subtitle: r.reason,
              status: r.status,
            );
          },
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////
/// SAMSUNG ONE UI MODERN CARD
////////////////////////////////////////////////////////////

class _ModernCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String status;

  const _ModernCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final color = statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Icon bubble
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 16),

          /// Text section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          /// Status pill
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
