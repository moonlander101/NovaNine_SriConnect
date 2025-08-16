import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lanka_connect/components/appbar.dart';
import 'package:lanka_connect/theme/text.dart';

import '../../../theme/assets.dart';
import '../../../theme/colors.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHolding = false;
  bool aiSpeaking = true;

  final List<String> _aiLines = [
    "An appointment for a passport application.",
    "I’ll guide you through the process step-by-step.",
    "Let’s start — is this for a new passport or a renewal?",
    "Please confirm your choice before we proceed.",
    "Great! Now let’s check your documents.",
    "We’ll also schedule your biometric capture.",
  ];

  int _currentIndex = 0;
  Timer? _lineTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    if (aiSpeaking) {
      _startLineScroll();
    }
  }

  void _startLineScroll() {
    _lineTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentIndex < _aiLines.length - 1) {
        setState(() => _currentIndex++);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _lineTimer?.cancel();
    super.dispose();
  }

  void _onMicPressed() => setState(() => _isHolding = true);
  void _onMicReleased() => setState(() => _isHolding = false);

  @override
  Widget build(BuildContext context) {
    final visibleLines = _aiLines.sublist(
        _currentIndex, (_currentIndex + 4).clamp(0, _aiLines.length));

    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      appBar: AppBarCustom(title: "AI Assistant"),
      body: Column(
        children: [
          const SizedBox(height: 48),
          Text(
            _isHolding ? "AI Listening ..." : "AI Speaking ...",
            style: AppTextStyles.bodyX,
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onLongPressStart: (_) => _onMicPressed(),
            onLongPressEnd: (_) => _onMicReleased(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // if (_isHolding)
                //   ...List.generate(2, (i) {
                //     return AnimatedBuilder(
                //       animation: _controller,
                //       builder: (context, child) {
                //         final value = (_controller.value + (i * 0.3)) % 1;
                //         final scale = 1 + (value);
                //         final opacity = 1 - value;
                //         return Transform.scale(
                //           scale: scale,
                //           child: Container(
                //             width: 150,
                //             height: 150,
                //             decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               color:
                //                   // ignore: deprecated_member_use
                //                   Colors.blue.withOpacity(opacity * 0.25),
                //             ),
                //           ),
                //         );
                //       },
                //     );
                //   }),
                Center(
                  child: SvgPicture.asset(
                    AppAssets.ai,
                    width: 300,
                    height: 300,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          SizedBox(
            height: 160,
            child: ListView.builder(
              itemCount: visibleLines.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final fade = index == 0 ? 0.3 : 1.0; // top line faded
                return Opacity(
                  opacity: fade,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      visibleLines[index],
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body1,
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSmallButton(Iconsax.message_text, onTap: () {}),
              const SizedBox(width: 40),
              GestureDetector(
                onLongPressStart: (_) => _onMicPressed(),
                onLongPressEnd: (_) => _onMicReleased(),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_isHolding)
                      ...List.generate(3, (i) {
                        return AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            final value = (_controller.value + (i * 0.3)) % 1;
                            final scale = 1 + (value * 1.5);
                            final opacity = 1 - value;
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue
                                      // ignore: deprecated_member_use
                                      .withOpacity(opacity * 0.3),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: const Icon(
                        Iconsax.microphone,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              _buildSmallButton(Icons.close, onTap: () {}),
            ],
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildSmallButton(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blue, width: 1.5),
        ),
        child: Icon(icon, size: 20, color: Colors.blue),
      ),
    );
  }
}
