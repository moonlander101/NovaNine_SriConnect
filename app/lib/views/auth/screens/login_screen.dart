import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants//app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Simulate login process
    context.push('/home');
  }

  void _handleForgotPassword() {
    context.push('/forgot-password');
  }

  void _handleRegister() {
    // Navigate to register screen
    context.push('/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              
              // Title
              const Text(
                'Welcome Back! Glad to see you, Again!',
                style: AppTextStyles.heading28,
              ),
              const SizedBox(height: 48),
              
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
                    const SizedBox(height: 20),
                    
                    // Password input
                    CustomInputField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    
                    // Forgot password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _handleForgotPassword,
                        child: const Text(
                          'Forgot password?',
                          style: AppTextStyles.linkText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Login button
                    CustomButton(
                      text: 'Login',
                      onPressed: _handleLogin,
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
      ),
    );
  }
}
