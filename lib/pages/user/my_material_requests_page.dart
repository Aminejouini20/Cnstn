import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/material_request_model.dart';

class MyMaterialRequestsPage extends StatefulWidget {
  const MyMaterialRequestsPage({super.key});

  @override
  State<MyMaterialRequestsPage> createState() => _MyMaterialRequestsPageState();
}

class _MyMaterialRequestsPageState extends State<MyMaterialRequestsPage> {
  final FirestoreService _firestore = FirestoreService();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MaterialRequestModel>>(
      stream: _firestore.getUserMaterialRequests(uid),
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
                title: Text(item.article),
                subtitle: Text("Status: ${item.status}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await _firestore.deleteMaterialRequest(item.id);
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
