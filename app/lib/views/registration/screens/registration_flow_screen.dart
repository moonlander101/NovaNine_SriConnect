import 'package:flutter/material.dart';
import 'registration_step1_screen.dart';
import 'registration_step2_screen.dart';

class RegistrationFlowScreen extends StatefulWidget {
  const RegistrationFlowScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationFlowScreen> createState() => _RegistrationFlowScreenState();
}

class _RegistrationFlowScreenState extends State<RegistrationFlowScreen> {
  int _currentStep = 1;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        children: [
          RegistrationStep1Screen(
            onContinue: () => _goToNextStep(),
          ),
          RegistrationStep2Screen(
            onContinue: () => _goToNextStep(),
            onBack: () => _goToPreviousStep(),
          ),
          // Add more steps as needed
        ],
      ),
    );
  }

  void _goToNextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}