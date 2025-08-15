import 'package:flutter/material.dart';
import 'package:lanka_connect/components/appbar.dart';
import 'package:lanka_connect/l10n/localizations_helper.dart';
import 'package:lanka_connect/theme/text.dart';
import '../../../components/locale_dropdown.dart';
import '../../../theme/colors.dart';

class LanguagePreferenceScreen extends StatelessWidget {
  const LanguagePreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      appBar: AppBarCustom(title: context.l10n.languagePreferences),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.selectYourPreferredLanguageSemicolon,
                style: AppTextStyles.body2),
            const SizedBox(height: 16),
            LocaleDropdown()
          ],
        ),
      ),
    );
  }
}
