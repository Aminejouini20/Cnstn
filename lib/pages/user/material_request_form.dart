import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/user_model.dart';

class MaterialRequestForm extends StatefulWidget {
  const MaterialRequestForm({super.key});

  @override
  State<MaterialRequestForm> createState() => _MaterialRequestFormState();
}

class _MaterialRequestFormState extends State<MaterialRequestForm> {
  final FirestoreService _firestore = FirestoreService();
  final TextEditingController articleCtrl = TextEditingController();
  final TextEditingController techCtrl = TextEditingController();
  final TextEditingController justCtrl = TextEditingController();

  bool loading = false;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final u = await _firestore.getUserById(uid);
    setState(() => user = u);
  }

  Future<void> submit() async {
    setState(() => loading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _firestore.createMaterialRequest({
      'userId': uid,
      'requesterName': user!.name,
      'direction': user!.direction,
      'article': articleCtrl.text.trim(),
      'technicalDetails': techCtrl.text.trim(),
      'justification': justCtrl.text.trim(),
      'status': 'pending',
      'adminComment': '',
      'createdAt': DateTime.now(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text("Material Request")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: articleCtrl, decoration: const InputDecoration(labelText: "Article")),
            const SizedBox(height: 12),
            TextField(controller: techCtrl, decoration: const InputDecoration(labelText: "Technical Details")),
            const SizedBox(height: 12),
            TextField(controller: justCtrl, decoration: const InputDecoration(labelText: "Justification")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : submit,
              child: loading ? const CircularProgressIndicator() : const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
