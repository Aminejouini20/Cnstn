import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../models/room_reservation_model.dart';
import '../../services/firestore_service.dart';

class RoomReservationForm extends StatefulWidget {
  const RoomReservationForm({Key? key}) : super(key: key);

  @override
  _RoomReservationFormState createState() => _RoomReservationFormState();
}

class _RoomReservationFormState extends State<RoomReservationForm> {
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final fromDate = DateTime.tryParse(_fromController.text.trim());
    final toDate = DateTime.tryParse(_toController.text.trim());
    if (fromDate == null || toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid dates (YYYY-MM-DD)')),
      );
      return;
    }

    final reservation = RoomReservation(
      id: '', // Firestore will auto-generate
      userId: user.uid, // updated from requesterId
      roomNumber: _roomController.text.trim(),
      from: fromDate,
      to: toDate,
      status: 'Pending',
    );

    await FirestoreService().createRoomReservation(reservation);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Room reservation submitted!')),
    );

    _roomController.clear();
    _fromController.clear();
    _toController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Room Reservation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(controller: _roomController, label: 'Room Number'),
              const SizedBox(height: 16),
              AppTextField(controller: _fromController, label: 'From (YYYY-MM-DD)'),
              const SizedBox(height: 16),
              AppTextField(controller: _toController, label: 'To (YYYY-MM-DD)'),
              const SizedBox(height: 20),
              AppButton(text: 'Submit', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
