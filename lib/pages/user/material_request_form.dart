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

  final techCtrl = TextEditingController();
  final justCtrl = TextEditingController();

  UserModel? user;
  bool loading = false;
  String? selectedArticle;

  final List<String> articles = [
    "Ordinateur portable",
    "Clavier",
    "Souris",
    "Imprimante",
    "Scanner",
    "Câble Réseau",
    "USB",
    "Autre"
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    user = await _firestore.getUserById(uid);
    setState(() {});
  }

  Future<void> submit() async {
    if (selectedArticle == null ||
        techCtrl.text.isEmpty ||
        justCtrl.text.isEmpty) {
      _snack("Fill all fields");
      return;
    }

    setState(() => loading = true);

    await _firestore.createMaterialRequest({
      'userId': user!.id,
      'requesterName': user!.name,
      'direction': user!.direction,
      'article': selectedArticle,
      'technicalDetails': techCtrl.text,
      'justification': justCtrl.text,
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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Material Request"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _card(
            child: Column(
              children: [
                _dropdown(),
                const SizedBox(height: 16),
                _field(techCtrl, "Technical details"),
                const SizedBox(height: 16),
                _field(justCtrl, "Justification", max: 4),
              ],
            ),
          ),

          const SizedBox(height: 28),

          _submitButton(),
        ],
      ),
    );
  }

  /// ---------- UI ----------

  Widget _card({required Widget child}) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 12)
          ],
        ),
        child: child,
      );

  Widget _dropdown() => DropdownButtonFormField<String>(
        value: selectedArticle,
        items: articles
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => setState(() => selectedArticle = v),
        decoration: _input("Article"),
      );

  Widget _field(TextEditingController c, String label, {int max = 1}) =>
      TextField(
        controller: c,
        maxLines: max,
        decoration: _input(label),
      );

  InputDecoration _input(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF3F6FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      );

  Widget _submitButton() => ElevatedButton(
        onPressed: loading ? null : submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Submit Request"),
      );

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
