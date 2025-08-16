import 'package:flutter/material.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              const SizedBox(height: 50),
              
              // Welcome title
              const Text(
                'Welcome Back! Glad to see you, Again!',
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: 0.2,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Telephone Number field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Telephone Number',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1C1D21),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(64),
                      border: Border.all(
                        color: const Color(0xFFDDEAFE),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _phoneController,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 16,
                        color: Color(0xFF1C1D21),
                        letterSpacing: 0.2,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter your telephone number',
                        hintStyle: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF838383),
                          letterSpacing: 0.2,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 23, vertical: 20),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Password field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1C1D21),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(64),
                      border: Border.all(
                        color: const Color(0xFFDDEAFE),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 16,
                        color: Color(0xFF1C1D21),
                        letterSpacing: 0.2,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF838383),
                          letterSpacing: 0.2,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 23, vertical: 20),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: const Color(0xFF1C1D21),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Handle forgot password
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF2BA1F3),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Login button
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OtpVerificationScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2BA1F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Login',
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

