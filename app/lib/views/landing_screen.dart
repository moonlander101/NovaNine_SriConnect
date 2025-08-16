import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/assets.dart';
import '../theme/colors.dart';
import '../theme/text.dart';
import '../theme/dimens.dart';
import '../components/primary_button.dart';
import '../components/gap.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      body: Stack(
        children: [
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main illustration
                      Container(
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
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.defaultScreenMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: AppTextStyles.headline1.copyWith(
                          color: AppColors.darkGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gapz(),
                      Text(
                        'All your government services. One smart app.',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.black.shade400,
                        ),
                      ),
                      SizedBox(height: 3 * Dimens.defaultMargin),
                      SizedBox(
                        width: double.infinity,
                        height: 56, // Larger button for easier tap
                        child: PrimaryButton(
                          onPressed: () {
                            context.push('/login');
                          },
                          label: 'Get Started',
                        ),
                      ),
                      SizedBox(height: Dimens.defaultScreenMargin),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimens.defaultPaddingSM,
                            vertical: Dimens.defaultPaddingSM,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(Dimens.defaultRadius),
                            border: Border.all(color: AppColors.blue.shade100),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedLanguage,
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
                              if (newValue != null) {
                                setState(() {
                                  _selectedLanguage = newValue;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Language changed to $newValue'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
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