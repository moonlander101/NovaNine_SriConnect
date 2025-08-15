import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lanka_connect/theme/colors.dart';
import '../../../components/appbar.dart';
import '../../../components/margin.dart';
import '../../../theme/assets.dart';
import '../../../theme/dimens.dart';
import '../../../theme/text.dart';
import '../../home/widgets/account_setting_option.dart';
import '../../home/widgets/category_card.dart';

class MyDocumentsScreen extends StatelessWidget {
  const MyDocumentsScreen({super.key});
  Widget sectionTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(bottom: 12.0, left: 12.0),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.body3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      appBar: AppBarCustom(title: 'My Documents', isBackButtonVisible: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Margin(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.defaultScreenMarginSM,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimens.defaultMargin),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimens.defaultRadiusL),
                  border: Border.all(color: AppColors.blue.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        categoryIcon(AppAssets.profile3, "NIC", () {
                          context.push('/my-documents');
                        }),
                        categoryIcon(AppAssets.img2, "Passport", () {
                          context.push('/payment-methods');
                        }),
                        categoryIcon(AppAssets.img3, "Driving License", () {
                          context.push('/personal-information');
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: sectionTitle(
                  "Education Documents",
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.blue.shade200, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      AccountSettingOption(
                        title: "Educational Certificates",
                        icon: Iconsax.award,
                        onTap: () => context.push('/edit-profile'),
                      ),
                      AccountSettingOption(
                        title: "Professional Qualifications",
                        icon: Iconsax.briefcase,
                        onTap: () => context.push('/change-password'),
                      ),
                      AccountSettingOption(
                        title: "Transcript of Records",
                        icon: Iconsax.book,
                        onTap: () => context.push('/language-preferences'),
                      ),
                      AccountSettingOption(
                        title: "English Proficiency Test Results",
                        icon: Iconsax.document_text,
                        onTap: () {
                          final userId = 'your_user_id_here';
                          context.push('/addresses/$userId');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: sectionTitle(
                  "Travel Documents",
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.blue.shade200, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      AccountSettingOption(
                        title: "Passport",
                        icon: Iconsax.global,
                        onTap: () => context.push('/edit-profile'),
                      ),
                      AccountSettingOption(
                        title: "Visa",
                        icon: Iconsax.shield_tick,
                        onTap: () => context.push('/change-password'),
                      ),
                      AccountSettingOption(
                        title: "Travel Insurance",
                        icon: Iconsax.shield_cross,
                        onTap: () => context.push('/language-preferences'),
                      ),
                      AccountSettingOption(
                        title: "Vaccination Certificate",
                        icon: Iconsax.health,
                        onTap: () {
                          final userId = 'your_user_id_here';
                          context.push('/addresses/$userId');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: sectionTitle(
                  "Legal Documents",
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.blue.shade200, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      AccountSettingOption(
                        title: "Income Tax Records",
                        icon: Iconsax.receipt_item,
                        onTap: () => context.push('/edit-profile'),
                      ),
                      AccountSettingOption(
                        title: "Property Deeds",
                        icon: Iconsax.house,
                        onTap: () => context.push('/change-password'),
                      ),
                      AccountSettingOption(
                        title: "Business Registration Certificate",
                        icon: Iconsax.shop,
                        onTap: () => context.push('/language-preferences'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
