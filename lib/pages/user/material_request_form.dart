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

  final TextEditingController techCtrl = TextEditingController();
  final TextEditingController justCtrl = TextEditingController();

  bool loading = false;
  UserModel? user;

  String? selectedArticle;

  final List<String> articles = [
    "Ordinateur de bureau",
    "Ordinateur portable",
    "Clavier",
    "Souris",
    "Lecteur CD/DVD",
    "Scanner",
    "Graveur CD/DVD",
    "Imprimante",
    "Haut parleur",
    "Multiprise",
    "Flash-disk USB",
    "Cable Réseau",
    "Autre article informatique"
  ];

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
    if (selectedArticle == null ||
        techCtrl.text.trim().isEmpty ||
        justCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => loading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _firestore.createMaterialRequest({
      'userId': uid,
      'requesterName': user!.name,
      'direction': user!.direction,
      'article': selectedArticle,
      'technicalDetails': techCtrl.text.trim(),
      'justification': justCtrl.text.trim(),
      'status': 'pending',
      'adminComment': '',
      'createdAt': DateTime.now(),
    });

    setState(() => loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Material Request"),
        backgroundColor: const Color(0xFF0B1B33),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF4F6F8),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildTitle(),
            const SizedBox(height: 16),

            // Dropdown
            DropdownButtonFormField<String>(
              value: selectedArticle,
              items: articles
                  .map((a) => DropdownMenuItem(
                        value: a,
                        child: Text(a),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => selectedArticle = v),
              decoration: InputDecoration(
                labelText: "Article",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            _buildField(
              controller: techCtrl,
              label: "Détails techniques",
              hint: "ex: 20px, 10 units, etc.",
            ),
            const SizedBox(height: 12),

            _buildField(
              controller: justCtrl,
              label: "Justification",
              hint: "Pourquoi avez-vous besoin de cet article ?",
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B1B33),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: loading ? null : submit,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Submit Request",
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Material Request Form",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B1B33),
          ),
        ),
        SizedBox(height: 6),
        Text(
          "Request materials with full details",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
