import 'package:flutter/material.dart';
import '../../models/material_request_model.dart';
import '../../services/firestore_service.dart';

class MaterialRequestDetailsPage extends StatelessWidget {
  final MaterialRequestModel request;
  const MaterialRequestDetailsPage({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Details"),
        backgroundColor: const Color(0xFF0B1B33),
      ),
      backgroundColor: const Color(0xFFF4F6F8),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _detailCard("Article", request.article),
            _detailCard("Technical Details", request.technicalDetails),
            _detailCard("Justification", request.justification),
            _detailCard("Direction", request.direction),
            _detailCard("Status", request.status),
            _detailCard("Admin Comment", request.adminComment.isEmpty ? "—" : request.adminComment),

            const SizedBox(height: 24),

            if (request.status == 'pending')
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: () async {
                  await FirestoreService().deleteMaterialRequest(request.id);
                  Navigator.pop(context);
                },
                child: const Text("Delete Request"),
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
