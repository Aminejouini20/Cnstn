import 'package:flutter/material.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/user/user_home_page.dart';
import '../pages/admin/admin_home_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/login': (_) => const LoginPage(),
    '/register': (_) => const RegisterPage(),
    '/userHome': (_) => const UserHomePage(),
    '/adminHome': (_) => const AdminHomePage(),
  };
}
