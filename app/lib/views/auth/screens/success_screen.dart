import 'package:flutter/material.dart';
import 'package:lanka_connect/views/home/screens/home_view.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Status bar spacing
                const SizedBox(height: 20),
                
                // Header with back button and title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
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
                ),
              ],
            ),
          ),
          
          // Dark overlay
          Container(
            color: Colors.black.withOpacity(0.24),
          ),
          
          // Success dialog
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
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
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FADF),
                      borderRadius: BorderRadius.circular(58.333),
                      border: Border.all(
                        color: const Color(0xFFECFDF3),
                        width: 16.667,
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Color(0xFF039855),
                        size: 32,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Title and subtitle
                  Column(
                    children: [
                      const Text(
                        'Successfully Logged In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1C1D21),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const SizedBox(
                        width: 265,
                        child: Text(
                          'Time to explore right services.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF1C1D21),
                            height: 1.29,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Back to Login button
                      SizedBox(
                        width: 312,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeView()),
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
                            'Continue',
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
