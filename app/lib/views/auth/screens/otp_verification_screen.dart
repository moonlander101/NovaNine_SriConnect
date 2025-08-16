import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants//app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/progress_indicator_widget.dart';
import '../widgets/success_dialog.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isForPasswordReset;

  const OtpVerificationScreen({
    super.key,
    this.phoneNumber = '+94 711234567',
    this.isForPasswordReset = false,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    5,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 4) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String _getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _onVerify() {
    final otpCode = _getOtpCode();
    if (otpCode.length == 5) {
      // Show success dialog
      SuccessDialog.show(
        context,
        title: 'Account Created\nSuccessfully',
        subtitle: 'Time to connect with the right people.',
        buttonText: 'Back to Login',
        onButtonPressed: () {
          Navigator.of(context).pop(); // Close dialog
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
        },
      );
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete OTP code'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  void _onResendOtp() {
    // Clear all OTP fields
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
    
    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP code has been resent'),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 48,
              margin: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 20,
              ),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                        border: Border.all(
                          color: AppColors.inputBorder,
                          width: 0.8,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.blue500,
                        size: 20,
                      ),
                    ),
                  ),
                  
                  // Title
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 28),
                      child: const Text(
                        'Verify Phone Number',
                        style: AppTextStyles.heading20,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),
            
            // Divider
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.inputBorder,
              margin: const EdgeInsets.only(top: 20),
            ),

            // Progress indicator
            const Padding(
              padding: EdgeInsets.only(top: 27),
              child: ProgressIndicatorWidget(
                currentStep: 3,
                totalSteps: 3,
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Instructions
                          Text(
                            'Please enter the 5 digit code we sent to ${widget.phoneNumber}',
                            style: AppTextStyles.body16,
                          ),
                          const SizedBox(height: 25),

                          // OTP Input Fields
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(5, (index) {
                              return Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusS),
                                  border: Border.all(
                                    color: AppColors.borderColor,
                                    width: 1,
                                  ),
                                ),
                                child: TextField(
                                  controller: _otpControllers[index],
                                  focusNode: _focusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: AppTextStyles.body16.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    counterText: '',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) => _onOtpChanged(value, index),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 25),

                          // Verify Button
                          CustomButton(
                            text: 'Verify',
                            onPressed: _onVerify,
                          ),
                          const SizedBox(height: 25),

                          // Resend OTP
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Didn't receive a code?",
                                style: AppTextStyles.placeholder,
                              ),
                              GestureDetector(
                                onTap: _onResendOtp,
                                child: const Text(
                                  'Resend code',
                                  style: AppTextStyles.linkText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Bottom text
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: RichText(
                        text: const TextSpan(
                          style: AppTextStyles.body16,
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(color: AppColors.blue800),
                            ),
                            TextSpan(
                              text: "Register Now",
                              style: AppTextStyles.linkText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
