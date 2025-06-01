// File: lib/modules/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/auth/auth_controller.dart'; // Sesuaikan path
import 'package:timelyu/shared/widgets/auth/login_form_card.dart';
import 'package:timelyu/shared/widgets/auth/login_header.dart'; // Sesuaikan path

class LoginScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Password visibility state bisa tetap di sini atau dipindah ke AuthController jika lebih relevan
  final RxBool _isPasswordVisible = false.obs;

  LoginScreen({super.key});

  static const double _horizontalPadding = 24.0;

  void _performLogin() {
    if (_formKey.currentState!.validate()) {
      _authController.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _buildGradientDecoration(),
        child: SafeArea(
          child: Obx(() {
            // Cek isLoading dari AuthController
            if (_authController.isLoading.value && Get.currentRoute == '/login') {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            return _buildContent(context);
          }),
        ),
      ),
    );
  }

  BoxDecoration _buildGradientDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.blue.shade800,
          Colors.blue.shade500,
          Colors.blue.shade300,
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(), // Menggunakan widget LoginHeader
            const SizedBox(height: 50),
            LoginFormCard( // Menggunakan widget LoginFormCard
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              isPasswordVisible: _isPasswordVisible,
              onLoginPressed: _performLogin,
              // onForgotPasswordPressed: () { /* handle forgot password */ },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}