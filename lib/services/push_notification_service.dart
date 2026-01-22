import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    await _fcm.requestPermission();
  }

  Future<String?> getToken() async {
    return await _fcm.getToken();
  }
}
