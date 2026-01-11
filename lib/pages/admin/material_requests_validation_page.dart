import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../models/material_request_model.dart';

class MaterialRequestsValidationPage extends StatelessWidget {
  const MaterialRequestsValidationPage({super.key});

  Future<void> _approveRequest(MaterialRequest request) async {
    await FirestoreService().updateMaterialRequest(request.copyWith(status: 'Approved'));
  }

  Future<void> _rejectRequest(MaterialRequest request) async {
    await FirestoreService().updateMaterialRequest(request.copyWith(status: 'Rejected'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MaterialRequest>>(
      stream: FirestoreService().allMaterialRequests(),
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
                trailing: req.status == 'Pending'
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () => _approveRequest(req)),
                          IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _rejectRequest(req)),
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
