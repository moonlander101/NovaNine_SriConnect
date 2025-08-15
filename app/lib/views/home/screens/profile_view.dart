import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lanka_connect/components/margin.dart';
import 'package:lanka_connect/l10n/localizations_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../components/appbar.dart';
import '../../../components/sucess_dialog.dart';
import '../../../theme/assets.dart';
import '../../../theme/colors.dart';
import '../../../theme/dimens.dart';
import '../../../theme/text.dart';
import '../widgets/account_setting_option.dart';
import '../widgets/category_card.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String userEmail = "Vimosh@example.com";
  String userName = "Vimosh Vasanthakumar";
  String userProfileURL = "https://example.com/vimosh.jpg";
  String userNIC = "200222500189";

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

  Future<void> openWebsite(BuildContext context) async {
    Uri uri = Uri.parse("https://socialpass.co");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open website'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      appBar: AppBarCustom(title: 'Profile', isBackButtonVisible: false),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Margin(),
            Container(
              padding: const EdgeInsets.all(Dimens.defaultPadding),
              margin: const EdgeInsets.symmetric(
                horizontal: Dimens.defaultScreenMarginSM,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.blue.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.blue,
                    child: Text(
                      userName.isNotEmpty && userName != "Guest"
                          ? userName[0].toUpperCase()
                          : "?",
                      style: AppTextStyles.headline4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              userName,
                              style: AppTextStyles.title1,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: SvgPicture.asset(
                                AppAssets.idCard,
                                width: 16,
                                height: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              userNIC,
                              style: AppTextStyles.body2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Margin(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.defaultScreenMarginSM,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(
                    Dimens.defaultMargin), // internal padding
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
                        categoryIcon(AppAssets.profile2, "My \nDocuments", () {
                          context.push('/my-documents');
                        }),
                        categoryIcon(AppAssets.profile3, "Payment \nMethods",
                            () {
                          context.push('/payment-methods');
                        }),
                        categoryIcon(
                            AppAssets.profile4, "Personal \nInformation", () {
                          context.push('/personal-information');
                        }),
                      ],
                    ),
                    Margin(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        categoryIcon(
                            AppAssets.profile1, "Complaints &\n Support", () {
                          context.push('/complaints-support');
                        }),
                        categoryIcon(
                            AppAssets.profile6, "Transaction \n History", () {
                          context.push('/transaction-history');
                        }),
                        categoryIcon(AppAssets.profile5, "Account \nSettings",
                            () {
                          context.push('/account-settings');
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: sectionTitle(
                  context.l10n.support,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.blue.shade200),
                ),
                child: Column(
                  children: [
                    AccountSettingOption(
                      title: context.l10n.contactus,
                      icon: Iconsax.sms_notification,
                      onTap: () => openWebsite(context),
                    ),
                    AccountSettingOption(
                      title: context.l10n.privacypolicy,
                      icon: Iconsax.lock,
                      onTap: () => openWebsite(context),
                    ),
                    AccountSettingOption(
                      title: context.l10n.termsofuse,
                      icon: Iconsax.people,
                      onTap: () => openWebsite(context),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: sectionTitle(context.l10n.dangerzone),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.blue.shade200),
                ),
                child: Column(
                  children: [
                    AccountSettingOption(
                      title: context.l10n.logout,
                      icon: Iconsax.logout,
                      onTap: () => {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => SucessDialog(
                            text: 'logout',
                            subText: 'Are you sure you want to logout',
                            buttonText: 'Yes',
                            backgroundColor: Colors.white,
                            onPressed: () => {
                              context.go('/login'),
                            },
                            hasCancelButton: true,
                          ),
                        )
                      },
                    ),
                    AccountSettingOption(
                      title: context.l10n.deleteaccount,
                      icon: Iconsax.trash,
                      onTap: () => {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => SucessDialog(
                            text: 'Delete Account',
                            subText: 'Are you sure you want to delete?',
                            buttonText: 'Yes',
                            backgroundColor: Colors.white,
                            onPressed: () => {
                              context.go('/login'),
                            },
                            hasCancelButton: true,
                          ),
                        )
                      },
                      color: AppColors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 123),
          ],
        ),
      ),
    );
  }
}
