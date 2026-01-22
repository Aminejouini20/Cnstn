import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/notification_model.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final FirestoreService _firestore = FirestoreService();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NotificationModel>>(
      stream: _firestore.getUserNotifications(uid),
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
                leading: Icon(Icons.notifications),
                title: Text(item.title),
                subtitle: Text(item.message),
                trailing: item.read ? null : const Icon(Icons.circle, size: 10, color: Colors.blue),
                onTap: () async {
                  await _firestore.markNotificationRead(item.id);
                },
              ),
            );
          },
        );
      },
    );
  }
}
