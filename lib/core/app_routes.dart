import 'package:flutter/material.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/reset_password_page.dart';
import '../pages/user/user_home_page.dart';
import '../pages/admin/admin_home_page.dart';
import '../pages/user/material_request_form.dart';
import '../pages/user/my_material_requests_page.dart';
import '../pages/user/room_reservation_form.dart';
import '../pages/user/my_room_reservations_page.dart';
import '../pages/user/notifications_page.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const reset = '/reset';
  static const userHome = '/userHome';
  static const adminHome = '/adminHome';

  static const materialRequestForm = '/materialRequestForm';
  static const roomReservationForm = '/roomReservationForm';

  static final routes = <String, WidgetBuilder>{
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    reset: (_) => const ResetPasswordPage(),
    userHome: (_) => const UserHomePage(),
    adminHome: (_) => const AdminHomePage(),
    materialRequestForm: (_) => const MaterialRequestForm(),
    roomReservationForm: (_) => const RoomReservationForm(),
  };
}
