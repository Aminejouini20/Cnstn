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

  final reasonCtrl = TextEditingController();
  final participantsCtrl = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  UserModel? user;
  bool loading = false;

  /// ================= INIT =================
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

  /// ================= SUBMIT =================
  Future<void> submit() async {
    if (reasonCtrl.text.isEmpty ||
        participantsCtrl.text.isEmpty ||
        selectedDate == null ||
        startTime == null ||
        endTime == null) {
      _snack("Please fill all fields");
      return;
    }

    if (int.tryParse(participantsCtrl.text) == null) {
      _snack("Participants must be a number");
      return;
    }

    setState(() => loading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final timeSlot =
        "${startTime!.format(context)} - ${endTime!.format(context)}";

    await _firestore.createRoomReservation({
      'userId': uid,
      'requesterName': user!.name,
      'direction': user!.direction,
      'reason': reasonCtrl.text.trim(),
      'timeSlot': timeSlot,
      'participants': int.parse(participantsCtrl.text.trim()),
      'status': 'pending',
      'adminComment': '',
      'reservationDate': selectedDate,
      'createdAt': DateTime.now(),
    });

    setState(() => loading = false);
    Navigator.pop(context);
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      /// ===== APP BAR =====
      appBar: AppBar(
        title: const Text("Room Reservation"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      /// ===== BODY =====
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          /// ===== FORM CARD =====
          _card(
            child: Column(
              children: [
                _textField(reasonCtrl, "Reason", icon: Icons.edit_note),
                const SizedBox(height: 16),

                _participantsField(),
                const SizedBox(height: 16),

                _datePicker(),
                const SizedBox(height: 16),

                _timePickers(),
              ],
            ),
          ),

          const SizedBox(height: 28),

          _submitButton(),
        ],
      ),
    );
  }

  /// CARD CONTAINER
  Widget _card({required Widget child}) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: child,
      );

  /// TEXT FIELD
  Widget _textField(TextEditingController controller, String label,
          {IconData? icon}) =>
      TextField(
        controller: controller,
        decoration: _input(label, icon: icon),
      );

  /// PARTICIPANTS
  Widget _participantsField() => TextField(
        controller: participantsCtrl,
        keyboardType: TextInputType.number,
        decoration: _input("Participants", icon: Icons.people),
      );

  /// DATE PICKER
  Widget _datePicker() => InkWell(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            initialDate: DateTime.now(),
          );

          if (date != null) {
            setState(() => selectedDate = date);
          }
        },
        child: _fakeField(
          label: "Date",
          value: selectedDate == null
              ? "Select date"
              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
          icon: Icons.calendar_month,
        ),
      );

  /// TIME PICKERS
  Widget _timePickers() => Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                final t = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (t != null) setState(() => startTime = t);
              },
              child: _fakeField(
                label: "Start",
                value: startTime?.format(context) ?? "Start time",
                icon: Icons.access_time,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () async {
                final t = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (t != null) setState(() => endTime = t);
              },
              child: _fakeField(
                label: "End",
                value: endTime?.format(context) ?? "End time",
                icon: Icons.access_time_filled,
              ),
            ),
          ),
        ],
      );

  /// FAKE FIELD (for pickers)
  Widget _fakeField(
          {required String label,
          required String value,
          required IconData icon}) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F6FA),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(child: Text(value)),
          ],
        ),
      );

  /// INPUT STYLE
  InputDecoration _input(String label, {IconData? icon}) => InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: const Color(0xFFF3F6FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      );

  /// SUBMIT BUTTON
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
            : const Text(
                "Reserve Room",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      );

  /// SNACK
  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
