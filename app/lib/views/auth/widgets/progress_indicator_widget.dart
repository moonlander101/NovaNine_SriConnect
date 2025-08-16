import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final stepNumber = index + 1;
        final isCompleted = stepNumber <= currentStep;

        return Expanded(
          child: Container(
            height: 8,
            margin: EdgeInsets.only(right: index < totalSteps - 1 ? 12 : 0),
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.primaryBlue : AppColors.black300,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      }),
    );
  }
}
