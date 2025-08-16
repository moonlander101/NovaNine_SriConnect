import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/text.dart';

class ResetPasswordOtpScreen extends StatefulWidget {
  const ResetPasswordOtpScreen({super.key});

  @override
  State<ResetPasswordOtpScreen> createState() => _ResetPasswordOtpScreenState();
}

class _ResetPasswordOtpScreenState extends State<ResetPasswordOtpScreen> {
  final List<TextEditingController> _otpControllers = 
      List.generate(5, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = 
      List.generate(5, (index) => FocusNode());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 31),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              
              // Header with back button and title
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    // Back button
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFDDEAFE),
                          width: 0.8,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Color(0xFF1F7BBB),
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    
                    const SizedBox(width: 28),
                    
                    // Title
                    Expanded(
                      child: Text(
                        'Reset Password',
                        style: AppTextStyles.headline5.copyWith(
                          color: const Color(0xFF1C1D21),
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    const SizedBox(width: 76),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Divider
              Container(
                height: 1,
                color: const Color(0xFFDDEAFE),
              ),
              
              const SizedBox(height: 28),
              
              // OTP verification content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instruction text
                  Text(
                    'To reset the password, please enter the 5 digit code we sent to (+94) 70 1234567',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF1C1D21),
                      letterSpacing: 0.2,
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // OTP input fields
                  SizedBox(
                    height: 56,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (index) {
                        return Container(
                          width: index == 1 || index == 3 ? 54 : 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                              color: const Color(0xFFCACACA),
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: AppTextStyles.body1.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) => _onOtpChanged(value, index),
                          ),
                        );
                      }),
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Verify button
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/reset-password');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2BA1F3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Verify',
                        style: AppTextStyles.body1.copyWith(
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Resend code section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Didn't receive a code?",
                        style: AppTextStyles.body1.copyWith(
                          color: const Color(0xFF838383),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle resend code
                        },
                        child: Text(
                          'Resend code',
                          style: AppTextStyles.body1.copyWith(
                            color: const Color(0xFF2BA1F3),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Register link
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.body1.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: const Color(0xFF021627),
                          ),
                        ),
                        TextSpan(
                          text: "Register Now",
                          style: TextStyle(
                            color: const Color(0xFF2BA1F3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}