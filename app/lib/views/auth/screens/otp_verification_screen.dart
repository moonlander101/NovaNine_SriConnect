import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 4) {
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
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Header with back button and title
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFDDEAFE),
                        width: 0.8,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xFF1F7BBB),
                      size: 20,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Account Verification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1C1D21),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Instructions
              const Text(
                'Please enter the 5 digit code we sent to (+94) 70 1234567',
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1C1D21),
                  letterSpacing: 0.2,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // OTP input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: const Color(0xFFCACACA),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1D21),
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      onChanged: (value) => _onChanged(value, index),
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: 32),
              
              // Verify button
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    context.pushReplacement('/success');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2BA1F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Resend code
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Didn't receive a code?",
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF838383),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle resend code
                    },
                    child: const Text(
                      'Resend code',
                      style: TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2BA1F3),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Bottom register link
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Color(0xFF021627)),
                        ),
                        TextSpan(
                          text: 'Register Now',
                          style: TextStyle(color: Color(0xFF2BA1F3)),
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

