import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../components/appbar.dart';
import '../../../theme/colors.dart';
import '../../../theme/dimens.dart';
import '../../../theme/text.dart';
import '../widgets/service_card.dart';

class FixOptionScreen extends StatelessWidget {
  const FixOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      appBar: AppBarCustom(title: "Appointment Options"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimens.defaultScreenMarginSM,
                vertical: Dimens.defaultScreenMarginSM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.headline4
                          .copyWith(fontWeight: FontWeight.w400),
                      children: [
                        TextSpan(
                          text: "How would you like to\n",
                        ),
                        TextSpan(
                          text: "get this fixed?",
                          style: TextStyle(color: AppColors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Card options
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Dimens.defaultScreenMarginSM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ServiceCard(
                    title: 'Proceed \nManually',
                    description: 'Fill out the appointment details yourself at your own pace.',
                    buttonText: 'Continue',
                    icon: Iconsax.document,
                    onPressed: () {

                    },
                  ),
                ),
                SizedBox(width: Dimens.defaultMarginSM),
                Expanded(
                  child: ServiceCard(
                    title: 'Start with AI Assistant',
                    description: 'Let our AI guide you step-by-step to book your appointment quickly and easily.',
                    buttonText: 'Continue',
                    icon: Icons.auto_awesome,
                    onPressed: () {
                      // Navigate to AI Assistant screen
                      context.push('/ai-assistant');
                    },
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
