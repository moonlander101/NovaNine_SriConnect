import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/text.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.24),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 376,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success message
              Text(
                'Password reset successful!',
                style: AppTextStyles.headline4.copyWith(
                  color: const Color(0xFF1C1D21),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Please login using new password',
                style: AppTextStyles.body2.copyWith(
                  color: const Color(0xFF1C1D21),
                  height: 1.28,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
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
              
              const SizedBox(height: 40),
              
              // Back to Login button
              SizedBox(
                width: 312,
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    context.go('/login');
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
      ),
    );
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
              
            const SizedBox(height: 30),
            
              // Password fields section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // New Password field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Password',
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
                          controller: _newPasswordController,
                          obscureText: !_isNewPasswordVisible,
                          style: AppTextStyles.body1.copyWith(
                            letterSpacing: 0.2,
                          ),
                          decoration: InputDecoration(
                    hintText: 'Enter your new password',
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
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Confirm Password field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Password',
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
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          style: AppTextStyles.body1.copyWith(
                            letterSpacing: 0.2,
                          ),
                          decoration: InputDecoration(
                    hintText: 'Re-enter your new password',
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
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isConfirmPasswordVisible 
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF1C1D21),
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 48),
              
              // Reset Password button
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    _showSuccessDialog();
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
                    'Reset Password',
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