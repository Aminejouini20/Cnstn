import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/firestore_service.dart';

class AdminUserEditPage extends StatefulWidget {
  final UserModel user;
  const AdminUserEditPage({super.key, required this.user});

  @override
  State<AdminUserEditPage> createState() => _AdminUserEditPageState();
}

class _AdminUserEditPageState extends State<AdminUserEditPage> {
  final _firestore = FirestoreService();

  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController directionCtrl;
  late TextEditingController positionCtrl;
  String role = 'employee';

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.user.name);
    emailCtrl = TextEditingController(text: widget.user.email);
    directionCtrl = TextEditingController(text: widget.user.direction);
    positionCtrl = TextEditingController(text: widget.user.position);
    role = widget.user.role;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit User')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _field(nameCtrl, 'Full Name'),
            _field(emailCtrl, 'Email'),
            _field(directionCtrl, 'Direction'),
            _field(positionCtrl, 'Position'),

            DropdownButtonFormField(
              value: role,
              items: const [
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
                DropdownMenuItem(value: 'employee', child: Text('Employee')),
              ],
              onChanged: (v) => setState(() => role = v!),
              decoration: const InputDecoration(labelText: 'Role'),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                await _firestore.updateUser(widget.user.id, {
                  'name': nameCtrl.text,
                  'email': emailCtrl.text,
                  'direction': directionCtrl.text,
                  'position': positionCtrl.text,
                  'role': role,
                });
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            )
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

