import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/text.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
                        'Forgot Password',
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
              
            const SizedBox(height: 36),
            
              // Phone number input section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Telephone Number',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF1C1D21),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: const Color(0xFFDDEAFE),
                        width: 1,
                      ),
                    ),
                    child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                      style: AppTextStyles.body1.copyWith(
                        letterSpacing: 0.2,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your telephone number',
                        hintStyle: AppTextStyles.body1.copyWith(
                          color: const Color(0xFF838383),
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.2,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 23,
                          vertical: 20,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Back to login link
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Back to login',
                        style: AppTextStyles.body1.copyWith(
                          color: const Color(0xFF2BA1F3),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
                  const SizedBox(height: 32),
                  
                  // Send OTP button
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/reset-password-otp');
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
                    'Send OTP',
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
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