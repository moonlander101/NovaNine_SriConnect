import 'package:flutter/material.dart';
import '../constants//app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSendOTP() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OtpVerificationScreen(
          phoneNumber: '(+94) 70 1234567',
          isForPasswordReset: true,
        ),
      ),
    );
  }

  void _handleBackToLogin() {
    Navigator.pop(context);
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
        title: const Text('Forgot Password'),
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
            const SizedBox(height: 36),
            
            // Form
            Expanded(
              child: Column(
                children: [
                  // Phone number input
                  CustomInputField(
                    label: 'Telephone Number',
                    hintText: 'Enter your telephone number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  
                  // Back to login link
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _handleBackToLogin,
                      child: const Text(
                        'Back to login',
                        style: AppTextStyles.linkText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Send OTP button
                  CustomButton(
                    text: 'Send OTP',
                    onPressed: _handleSendOTP,
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
