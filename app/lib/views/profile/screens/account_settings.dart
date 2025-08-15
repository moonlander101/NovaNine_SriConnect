import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lanka_connect/l10n/localizations_helper.dart';
import 'package:lanka_connect/theme/colors.dart';

import '../../../components/appbar.dart';
import '../../../theme/dimens.dart';
import '../../home/widgets/account_setting_option.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      appBar:
          AppBarCustom(title: 'Account Settings', isBackButtonVisible: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: Dimens.defaultMarginSM),
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
                      title: context.l10n.editprofile,
                      icon: Iconsax.user,
                      onTap: () => context.push('/edit-profile'),
                      ),
                      AccountSettingOption(
                      title: context.l10n.changepassword,
                      icon: Iconsax.password_check,
                      onTap: () => context.push('/change-password'),
                      ),
                      AccountSettingOption(
                      title: context.l10n.languagepreferences,
                      icon: Iconsax.language_circle,
                      onTap: () => context.push('/language-preferences'),
                      ),
                      AccountSettingOption(
                      title: context.l10n.locationpreferences,
                      icon: Iconsax.location,
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
          ],
        ),
      ),
    );
  }
}
