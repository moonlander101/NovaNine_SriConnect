import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorWidget({
    Key? key,
    required this.currentStep,
    this.totalSteps = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildSteps(),
      ),
    );
  }

  List<Widget> _buildSteps() {
    List<Widget> steps = [];
    
    for (int i = 1; i <= totalSteps; i++) {
      // Add step circle
      steps.add(_buildStepCircle(i));
      
      // Add connecting line (except for last step)
      if (i < totalSteps) {
        steps.add(_buildConnectingLine(i));
      }
    }
    
    return steps;
  }

  Widget _buildStepCircle(int stepNumber) {
    bool isCompleted = stepNumber < currentStep;
    bool isActive = stepNumber == currentStep;

    Color backgroundColor;
    Widget child;
    
    if (isCompleted) {
      backgroundColor = const Color(0xFF2BA1F3);
      child = const Icon(Icons.check, color: Colors.white, size: 20);
    } else if (isActive) {
      backgroundColor = const Color(0xFF2BA1F3);
      child = Text(
        stepNumber.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      );
    } else {
      backgroundColor = const Color(0xFFCACACA);
      child = Text(
        stepNumber.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isCompleted || isActive ? [
          BoxShadow(
            color: const Color(0x2604147C),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ] : null,
      ),
      child: Center(child: child),
    );
  }

  Widget _buildConnectingLine(int stepNumber) {
    bool isCompleted = stepNumber < currentStep;
    Color lineColor = isCompleted ? const Color(0xFF2BA1F3) : const Color(0xFFCACACA);
    
    return Container(
      width: 49,
      height: 2,
      color: lineColor,
    );
  }
}