import 'package:flutter/material.dart';
import 'package:lanka_connect/l10n/localizations_helper.dart';
import '../../../components/appbar.dart';
import '../../../components/custom_input.dart';
import '../../../components/elevated_bottom_bar.dart';
import '../../../components/gap.dart';
import '../../../components/margin.dart';
import '../../../components/primary_button.dart';
import '../../../theme/colors.dart';
import '../../../theme/dimens.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;
  String? _displayNameError;
  String? _phoneError;

  bool _canSubmit = false;

  bool _validateInputs() {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    setState(() {
      _currentPasswordError = currentPassword.isEmpty
          ? context.l10n.currentpasswordcannotbeempty
          : null;
      _newPasswordError =
          newPassword.isEmpty ? context.l10n.newpasswordcannotbeempty : null;
      _confirmPasswordError = confirmPassword.isEmpty
          ? context.l10n.confirmpasswordcannotbeempty
          : confirmPassword != newPassword
              ? context.l10n.passwordsdonotmatch
              : null;

      _canSubmit = _currentPasswordError == null &&
          _newPasswordError == null &&
          _confirmPasswordError == null;
    });

    return _canSubmit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      appBar: AppBarCustom(
          title: context.l10n.editprofile, isBackButtonVisible: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.defaultScreenMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Margin(),
            CustomTextInput(
              hintText: context.l10n.passwordHint,
              labelText: context.l10n.password,
              controller: _displayNameController,
              onChanged: (_) => _validateInputs(),
              errorText: _displayNameError,
            ),
            Gapz(),
            CustomTextInput(
              hintText: context.l10n.confirmPasswordHint,
              labelText: context.l10n.confirmPassword,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onChanged: (_) => _validateInputs(),
              errorText: _phoneError,
            ),
          ],
        ),
      ),
      bottomNavigationBar: ElevatedBottomBar(
        child: PrimaryButton(
          onPressed: (){},
          label: context.l10n.savechanges,
          isActive: true,
          isLoading: false,
        ),
      ),
    );
  }
}
