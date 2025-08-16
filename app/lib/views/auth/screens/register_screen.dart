import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lanka_connect/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants//app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/progress_indicator_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
    _fullNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _authSubscription.cancel();
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        setState(() {
          _isLoading = true;
        });
        await supabase.auth.signUp(
          phone: _mobileController.text,
          password: _passwordController.text,
          data: {
            'full_name': _fullNameController.text,
          },
        );
        if (mounted) {
          context.showSnackBar('Sign In successful!');
          _fullNameController.clear();
          _mobileController.clear();
          _confirmPasswordController.clear();
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
                        'Basic Details',
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
              padding: EdgeInsets.only(top: 27, left: 32, right: 32),
              child: ProgressIndicatorWidget(
                currentStep: 1,
                totalSteps: 3,
              ),
            ),

            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 36, 32, 32),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Full Name
                              CustomInputField(
                                label: 'Full Name',
                                hintText: 'Enter your full name',
                                controller: _fullNameController,
                              ),
                              const SizedBox(height: 30),

                              // Mobile Number
                              CustomInputField(
                                label: 'Mobile Number',
                                hintText: 'Enter your mobile number',
                                controller: _mobileController,
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 30),

                              // Password
                              CustomInputField(
                                label: 'Password',
                                hintText: 'Enter your password',
                                controller: _passwordController,
                                obscureText: true,
                              ),
                              const SizedBox(height: 30),

                              // Confirm Password
                              CustomInputField(
                                label: 'Confirm Password',
                                hintText: 'Re-enter your password',
                                controller: _confirmPasswordController,
                                obscureText: true,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Continue Button
                      CustomButton(
                        text: 'Continue',
                        onPressed: _onContinue,
                        isLoading: _isLoading,
                      ),
                    ],
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
