import 'package:flutter/material.dart';
import 'package:test/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          // Background gradient shape
          Positioned(
            top: 0,
            left: -2,
            child: Container(
              width: 442,
              height: 669,
              decoration: const BoxDecoration(
                color: Color(0xFF2BA1F3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Main illustration
                Padding(
                  padding: const EdgeInsets.only(top: 85),
                  child: Center(
                    child: Container(
                      width: 206,
                      height: 292,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                        '../assets/images/phone_illustration.png', // You'll need to add this image
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Content section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome text
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A4A4A),
                          letterSpacing: 0.2,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Description
                      const Text(
                        'All your government services. One smart app.',
                        style: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          letterSpacing: 0.2,
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Get Started button
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                            'Get Started',
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
                      
                      const SizedBox(height: 32),
                      
                      // Language selector
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'English',
                                style: TextStyle(
                                  fontFamily: 'Noto Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: const Color(0xFF1C1D21),
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

