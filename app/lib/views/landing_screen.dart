import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/assets.dart';
import '../theme/colors.dart';
import '../theme/text.dart';
import '../theme/dimens.dart';
import '../components/primary_button.dart';
import '../components/gap.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      body: Stack(
        children: [
          // Background gradient shape
          Positioned(
            top: 0,
            left: -2,
            child: Container(
              width: 442,
              height: 669,
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(3 * Dimens.defaultRadiusL),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                const Gapz(),
                
                // Main illustration
                Padding(
                  padding: const EdgeInsets.only(top: 85),
                  child: Center(
                    child: Container(
                      width: 206,
                      height: 292,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimens.defaultRadius),
                      ),
                      child: Image.asset(
                        AppAssets.logo,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Content section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.defaultScreenMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome text
                      Text(
                        'Welcome',
                        style: AppTextStyles.headline1.copyWith(
                          color: AppColors.darkGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      const Gapz(),
                      
                      // Description
                      Text(
                        'All your government services. One smart app.',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.black.shade400,
                        ),
                      ),
                      
                      SizedBox(height: 3 * Dimens.defaultMargin),
                      
                      // Get Started button
                      PrimaryButton(
                        onPressed: () {
                          context.push('/login');
                        },
                        label: 'Get Started',
                      ),
                      
                        SizedBox(height: Dimens.defaultScreenMargin),
                        
                        // Language selector
                        Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                          horizontal: Dimens.defaultPaddingSM, 
                          vertical: Dimens.defaultPaddingSM
                          ),
                          child: DropdownButton<String>(
                          value: 'English',
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.fontColor,
                            size: Dimens.iconSizeL,
                          ),
                          underline: SizedBox(),
                          items: ['English', 'සිංහල', 'தமிழ்'].map((String language) {
                            return DropdownMenuItem<String>(
                            value: language,
                            child: Text(
                              language,
                              style: AppTextStyles.body1.copyWith(
                              color: AppColors.fontColor,
                              ),
                            ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            // Handle language change logic here
                            print('Selected language: $newValue');
                          },
                          ),
                        ),
                        ),
                      SizedBox(height: 2.5 * Dimens.defaultMargin),
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

