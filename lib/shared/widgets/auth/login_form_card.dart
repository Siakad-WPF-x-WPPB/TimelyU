import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/auth/auth_controller.dart';

class LoginFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final RxBool isPasswordVisible; // Dari LoginScreen (atau AuthController)
  final VoidCallback onLoginPressed;
  // final VoidCallback onForgotPasswordPressed; // Jika logic-nya kompleks dan butuh callback

  // Constants for UI, bisa juga diletakkan di file terpisah jika banyak
  static const double _cardElevation = 8.0;
  static const double _borderRadius = 16.0;
  static const double _inputBorderRadius = 12.0;

  const LoginFormCard({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.onLoginPressed,
    // required this.onForgotPasswordPressed,
  });

  AuthController get _authController => Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Card(
        elevation: _cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Silakan masuk untuk melanjutkan",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              // Optional: Tampilkan error message global dari AuthController di sini jika ada
              // Obx(() {
              //   if (_authController.errorMessage.value != null && 
              //       !_authController.isLoading.value) { // Tampilkan jika tidak loading
              //     return Padding(
              //       padding: const EdgeInsets.only(bottom: 16.0),
              //       child: Text(
              //         _authController.errorMessage.value!,
              //         style: TextStyle(color: Colors.red.shade700, fontSize: 13),
              //       ),
              //     );
              //   }
              //   return const SizedBox.shrink();
              // }),
              _buildEmailField(),
              const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 12),
              _buildForgotPasswordButton(context),
              const SizedBox(height: 24),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: _inputDecoration(
        labelText: 'Email',
        hintText: 'Masukkan email Anda',
        prefixIcon: Icons.email,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email tidak boleh kosong';
        }
        if (!GetUtils.isEmail(value)) {
          return 'Masukkan email yang valid';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return Obx(() {
      return TextFormField(
        controller: passwordController,
        obscureText: !isPasswordVisible.value,
        decoration: _inputDecoration(
          labelText: 'Password',
          hintText: 'Masukkan password Anda',
          prefixIcon: Icons.lock,
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () => isPasswordVisible.toggle(),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password tidak boleh kosong';
          }
          if (value.length < 6) {
            return 'Password minimal 6 karakter';
          }
          return null;
        },
      );
    });
  }

  InputDecoration _inputDecoration({
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: Colors.blue.shade800),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_inputBorderRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_inputBorderRadius),
        borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_inputBorderRadius),
        borderSide: BorderSide(color: Colors.red.shade700, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_inputBorderRadius),
        borderSide: BorderSide(color: Colors.red.shade700, width: 2),
      ),
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Get.snackbar("Fitur", "Halaman lupa password belum diimplementasikan.", snackPosition: SnackPosition.BOTTOM);
        },
        child: Text(
          "Lupa Password?",
          style: TextStyle(
            color: Colors.blue.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onLoginPressed, // Menggunakan callback yang di-pass
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_inputBorderRadius),
          ),
        ),
        child: const Text(
          'MASUK',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}