import 'package:flutter/material.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../services/firestore_service.dart';
import '../../models/material_request_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MaterialRequestForm extends StatefulWidget {
  const MaterialRequestForm({Key? key}) : super(key: key);

  @override
  _MaterialRequestFormState createState() => _MaterialRequestFormState();
}

class _MaterialRequestFormState extends State<MaterialRequestForm> {
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final request = MaterialRequest(
      id: '', // Firestore will auto-generate
      userId: user.uid, // updated from requesterId
      materialName: _materialController.text.trim(),
      quantity: int.tryParse(_quantityController.text.trim()) ?? 0,
      status: 'Pending',
    );

    await FirestoreService().createMaterialRequest(request);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Material request submitted!')),
    );
    _materialController.clear();
    _quantityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Material Request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(controller: _materialController, label: 'Material Name'),
              const SizedBox(height: 16),
              AppTextField(
                controller: _quantityController,
                label: 'Quantity',
                keyboardType: TextInputType.number, // updated from keyboardType
              ),
              const SizedBox(height: 20),
              AppButton(text: 'Submit', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
