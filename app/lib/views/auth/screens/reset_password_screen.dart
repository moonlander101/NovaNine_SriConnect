import 'package:flutter/material.dart';
import '../constants//app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/success_dialog.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_newPasswordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // Show success dialog
    SuccessDialog.show(
      context,
      title: 'Password reset successful!',
      subtitle: 'Please login using new password',
      buttonText: 'Back to Login',
      onButtonPressed: () {
        Navigator.of(context).pop(); // Close dialog
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      },
    );
  }

  void _handleRegister() {
    // Navigate to register screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Register functionality not implemented')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.blue200,
              width: 0.8,
            ),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF1F7BBB),
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text('Reset Password'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppColors.blue200,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenMargin),
        child: Column(
          children: [
            const SizedBox(height: 30),
            
            // Form
            Expanded(
              child: Column(
                children: [
                  // New password input
                  CustomInputField(
                    label: 'New Password',
                    hintText: 'Enter your new password',
                    controller: _newPasswordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  
                  // Confirm password input
                  CustomInputField(
                    label: 'Confirm Password',
                    hintText: 'Re-enter your new password',
                    controller: _confirmPasswordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 32),
                  
                  // Reset password button
                  CustomButton(
                    text: 'Reset Password',
                    onPressed: _handleResetPassword,
                  ),
                  
                  const Spacer(),
                  
                  // Register link
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontFamily: AppFonts.dmSans,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blue800,
                          ),
                        ),
                        GestureDetector(
                          onTap: _handleRegister,
                          child: const Text(
                            'Register Now',
                            style: TextStyle(
                              fontFamily: AppFonts.dmSans,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
