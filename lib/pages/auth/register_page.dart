import 'package:flutter/material.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _directionController = TextEditingController();
  final _serviceController = TextEditingController();

  bool _loading = false;

  Future<void> _register() async {
    setState(() => _loading = true);
    try {
      final user = await AuthService().register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        direction: _directionController.text.trim(),
        service: _serviceController.text.trim(),
      );
      if (user != null && mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppTextField(controller: _firstNameController, label: 'First Name'),
            const SizedBox(height: 12),
            AppTextField(controller: _lastNameController, label: 'Last Name'),
            const SizedBox(height: 12),
            AppTextField(controller: _emailController, label: 'Email'),
            const SizedBox(height: 12),
            AppTextField(controller: _passwordController, label: 'Password', obscureText: true),
            const SizedBox(height: 12),
            AppTextField(controller: _directionController, label: 'Direction'),
            const SizedBox(height: 12),
            AppTextField(controller: _serviceController, label: 'Service'),
            const SizedBox(height: 20),
            AppButton(text: 'Register', onPressed: _register, loading: _loading),
          ],
        ),
      ),
    );
  }
}
