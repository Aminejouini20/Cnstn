import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/material_request_model.dart';

class MyMaterialRequestsPage extends StatelessWidget {
  const MyMaterialRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Center(child: Text('Not logged in'));

    return StreamBuilder<List<MaterialRequest>>(
      stream: FirestoreService().myMaterialRequests(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('No requests'));

        final requests = snapshot.data!;
        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(req.materialName),
                subtitle: Text('Quantity: ${req.quantity}\nStatus: ${req.status}'),
              ),
            );
          },
        );
      },
    );
  }
}
