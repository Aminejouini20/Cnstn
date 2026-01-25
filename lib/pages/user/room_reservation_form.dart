import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/user_model.dart';

class RoomReservationForm extends StatefulWidget {
  const RoomReservationForm({super.key});

  @override
  State<RoomReservationForm> createState() => _RoomReservationFormState();
}

class _RoomReservationFormState extends State<RoomReservationForm> {
  final FirestoreService _firestore = FirestoreService();

  final TextEditingController reasonCtrl = TextEditingController();
  final TextEditingController participantsCtrl = TextEditingController();
  final TextEditingController timeCtrl = TextEditingController();

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
    if (reasonCtrl.text.trim().isEmpty ||
        participantsCtrl.text.trim().isEmpty ||
        timeCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (int.tryParse(participantsCtrl.text.trim()) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Participants must be a number")),
      );
      return;
    }

    setState(() => loading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _firestore.createRoomReservation({
      'userId': uid,
      'requesterName': user!.name,
      'direction': user!.direction,
      'reason': reasonCtrl.text.trim(),
      'timeSlot': timeCtrl.text.trim(),
      'participants': int.parse(participantsCtrl.text.trim()),
      'status': 'pending',
      'adminComment': '',
      'reservationDate': DateTime.now(),
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
        title: const Text("Room Reservation"),
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

            _buildField(
              controller: reasonCtrl,
              label: "Reason",
              hint: "ex: Training session",
            ),
            const SizedBox(height: 12),

            _buildField(
              controller: timeCtrl,
              label: "Time Slot",
              hint: "ex: 12:00 - 14:00",
            ),
            const SizedBox(height: 12),

            _buildField(
              controller: participantsCtrl,
              label: "Participants",
              hint: "ex: 24",
              keyboardType: TextInputType.number,
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
                      "Submit Reservation",
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
          "Room Reservation Form",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B1B33),
          ),
        ),
        SizedBox(height: 6),
        Text(
          "Fill the details below to request a room",
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
