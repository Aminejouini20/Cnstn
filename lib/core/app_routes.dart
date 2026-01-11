import 'package:flutter/material.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/user/user_home_page.dart';
import '../pages/admin/admin_home_page.dart';
import '../pages/user/material_request_form.dart';
import '../pages/user/my_material_requests_page.dart';
import '../pages/user/room_reservation_form.dart';
import '../pages/user/my_room_reservations_page.dart';
import '../pages/admin/material_requests_validation_page.dart';
import '../pages/admin/room_reservations_validation_page.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const userHome = '/user_home';
  static const adminHome = '/admin_home';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    userHome: (_) => const UserHomePage(),
    adminHome: (_) => const AdminHomePage(),
    '/material_request_form': (_) => const MaterialRequestForm(),
    '/my_material_requests': (_) => const MyMaterialRequestsPage(),
    '/room_reservation_form': (_) => const RoomReservationForm(),
    '/my_room_reservations': (_) => const MyRoomReservationsPage(),
    '/material_requests_validation': (_) => const MaterialRequestsValidationPage(),
    '/room_reservations_validation': (_) => const RoomReservationsValidationPage(),
  };
}
