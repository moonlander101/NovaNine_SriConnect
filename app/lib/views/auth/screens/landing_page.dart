import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/text.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

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
                      width: 280,
                      height: 320,
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
                      top: -1,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        child: CustomPaint(
                          painter: WavePainter(),
                          size: Size(MediaQuery.of(context).size.width, 40),
                        ),
                      ),
                    ),
                    
                    // Content
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 50, 32, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome text
                          Text(
                            'Welcome',
                            style: AppTextStyles.headline2.copyWith(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4A4A4A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Subtitle
                          Text(
                            'All your government services. One smart app.',
                            style: AppTextStyles.body1.copyWith(
                              color: Colors.black,
                              letterSpacing: 0.2,
                            ),
                          ),
                          
                          const SizedBox(height: 48),
                          
                          // Get Started Button
                          SizedBox(
                            width: double.infinity,
                            height: 64,
                            child: ElevatedButton(
                              onPressed: () {
                                context.push('/login');
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
                                'Get Started',
                                style: AppTextStyles.body1.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
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
    
   // Start from top left
path.moveTo(0, 0);

// Draw straight line down a bit
path.lineTo(0, 35);

// Smooth single wave across the width
path.cubicTo(
  size.width * 0.25, 80,   // Control point 1
  size.width * 0.75, -10,  // Control point 2
  size.width, 35,          // End point (right side)
);

// Then go back up to top-right
path.lineTo(size.width, 0);

// Close the path
path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}