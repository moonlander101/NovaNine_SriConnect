import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/text.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(5, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOTPDigitChanged(int index, String value) {
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
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 25, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFDDEAFE),
              width: 0.8,
            ),
          ),
          child: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF1F7BBB),
              size: 18,
            ),
          ),
        ),
        title: Text(
          'Account Verification',
          style: AppTextStyles.headline5.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1C1D21),
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              
              // Instructions text
              Text(
                'Please enter the 5 digit code we sent to (+94) 70 1234567',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF1C1D21),
                  letterSpacing: 0.2,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 25),
              
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return Container(
                    width: index == 1 || index == 4 ? 54 : 56,
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
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: AppTextStyles.headline4.copyWith(
                        color: const Color(0xFF1C1D21),
                        fontWeight: FontWeight.w600,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onChanged: (value) => _onOTPDigitChanged(index, value),
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: 25),
              
              // Verify button
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    _showSuccessDialog(context);
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
              
              const SizedBox(height: 22),
              
              // Resend code
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
                  Text(
                    'Resend code',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF2BA1F3),
                      letterSpacing: 0.2,
                    ),
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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.24),
      builder: (BuildContext context) {
        return const SuccessDialog();
      },
    );
  }
}

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 376,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFD1FADF),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFECFDF3),
                  width: 16.67,
                ),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Color(0xFF039855),
                size: 50,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Success text
            Text(
              'Successfully Logged In',
              style: AppTextStyles.headline4.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1C1D21),
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // Subtitle
            Text(
              'Time to connect with the right people.',
              style: AppTextStyles.body2.copyWith(
                fontSize: 14,
                color: const Color(0xFF1C1D21),
                height: 1.29,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Back to Login button
            SizedBox(
              width: 312,
              height: 64,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  context.go('/home'); // Navigate to home after successful login
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
                  'Back to Login',
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}