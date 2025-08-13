import '../theme/dimens.dart';
import '../theme/text.dart';
import 'package:flutter/material.dart';

import 'glossy_simple_container.dart';

class ServiceProviderCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String role;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final String profileImage;
  const ServiceProviderCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.role,
    required this.buttonText,
    this.onButtonPressed,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimens.defaultRadiusL),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.defaultRadiusL),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black,
                  Colors.black.withAlpha(50),
                ],
              ),
            ),
          ),
          // Texts and button
          Positioned(
            left: 16,
            top: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.headline5.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    height: 1.17, // Set your desired line height here
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  role,
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: GlossyContainer(
              buttonText,
              onTap: onButtonPressed,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(profileImage,
                width: 200, height: 170, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}
