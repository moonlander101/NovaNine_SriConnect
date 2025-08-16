import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lanka_connect/main.dart';
import '../constants//app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  late StreamSubscription<AuthState> _authSubscription;
  bool _isLoading = false;
  bool _redirecting = false;

  @override
  void initState() {
    super.initState();
    _authSubscription = supabase.auth.onAuthStateChange.listen(
      (data) {
        final session = data.session;
        if (_redirecting) return;
        if (session != null) {
          _redirecting = true;
          if (mounted) context.go('/home');
        }
      },
      onError: (error) {
        if (error is AuthException) {
          if (mounted) context.showSnackBar(error.message, isError: true);
        } else {
          if (mounted) context.showSnackBar('Unexpected error occurred', isError: true);
        }
      },
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _authSubscription.cancel();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await supabase.auth.signInWithPassword(
        phone: _phoneController.text,
        password: _passwordController.text,
      );
      if (mounted) {
        context.showSnackBar('Sign In successful!');
        _phoneController.clear();
        _passwordController.clear();
      }
    } on AuthException catch (error) {
      if (mounted) context.showSnackBar(error.message, isError: true);
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Unexpected error occurred', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                      isLoading: _isLoading,
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
