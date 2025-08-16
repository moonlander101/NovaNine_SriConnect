import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/text.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Blue gradient section with logo
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF2BA1F3),
                      Color(0xFF1F7BBB),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    // Sri Lankan Government Logo
                    Container(
                      width: 250,
                      height: 300,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
            
            // Wave transition and white section
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    // Wave shape at the top
                    Positioned(
                      top: -5,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 50,
                        child: CustomPaint(
                          painter: WavePainter(),
                          size: Size(MediaQuery.of(context).size.width, 50),
                        ),
                      ),
                    ),
                    
                    // Content
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 40, 32, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome text
                          Text(
                            'Welcome',
                            style: AppTextStyles.headline2.copyWith(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4A4A4A),
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Subtitle
                          Text(
                            'All your government services. One smart app.',
                            style: AppTextStyles.body1.copyWith(
                              color: Colors.black,
                              letterSpacing: 0.2,
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Get Started Button
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                print('Get Started button pressed!');
                                // Show visual feedback
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Navigating to login...'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                                
                                try {
                                  context.push('/login');
                                  print('Navigation successful');
                                } catch (e) {
                                  print('Navigation error: $e');
                                  // Fallback navigation
                                  Navigator.of(context).pushNamed('/login');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2BA1F3),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Get Started',
                                style: AppTextStyles.body1.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                          
                          const Spacer(),
                          
                          // Language selector
                          Center(
                            child: DropdownButton<String>(
                              value: 'English',
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFF1C1D21),
                                size: 18,
                              ),
                              underline: const SizedBox(),
                              items: ['English', 'සිංහල', 'தமிழ்'].map((String language) {
                                return DropdownMenuItem<String>(
                                  value: language,
                                  child: Text(
                                    language,
                                    style: AppTextStyles.body1.copyWith(
                                      color: Colors.black,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                // Handle language change
                                if (newValue != null) {
                                  // TODO: Implement language change logic
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for the wave effect
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1F7BBB)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Start from top left and go well above to eliminate white line completely
    path.moveTo(0, -10);
    
    // Draw straight line down
    path.lineTo(0, 40);
    
    // Smooth wave across the width with better control points
    path.cubicTo(
      size.width * 0.2, 80,    // Control point 1 - higher curve
      size.width * 0.8, -15,   // Control point 2 - lower curve
      size.width, 40,          // End point (right side)
    );
    
    // Then go back up to top-right and well above
    path.lineTo(size.width, -10);
    
    // Close the path
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}