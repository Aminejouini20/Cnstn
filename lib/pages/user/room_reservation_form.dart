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

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text("Room Reservation")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: reasonCtrl,
              decoration: const InputDecoration(labelText: "Reason"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timeCtrl,
              decoration: const InputDecoration(labelText: "Time Slot"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: participantsCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Participants"),
            ),
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
