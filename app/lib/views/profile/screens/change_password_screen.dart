
import 'package:flutter/material.dart';
import 'package:lanka_connect/l10n/localizations_helper.dart';

import '../../../components/custom_input.dart';
import '../../../components/elevated_bottom_bar.dart';
import '../../../components/primary_button.dart';
import '../../../theme/dimens.dart';
import '../../../theme/text.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  bool _canSubmit = false;


  bool _validateInputs() {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    setState(() {
      _currentPasswordError = currentPassword.isEmpty
          ? context.l10n.currentpasswordcannotbeempty
          : null;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(context.l10n.changepassword, style: AppTextStyles.title2),
      ),
      body:Padding(
              padding: const EdgeInsets.all(Dimens.defaultScreenMargin),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.l10n.currentpasswordasterisk,
                      style: AppTextStyles.body2,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  CustomTextInput(
                    controller: _currentPasswordController,
                    obscureText: true,
                    onChanged: (_) => _validateInputs(),
                    errorText:  _currentPasswordError,
                  ),
                  const SizedBox(height: 28.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(context.l10n.newpasswordastersisk,
                        style: AppTextStyles.body2),
                  ),
                  const SizedBox(height: 12.0),
                  CustomTextInput(
                    controller: _newPasswordController,
                    obscureText: true,
                    onChanged: (_) => _validateInputs(),
                    errorText:_newPasswordError,
                  ),
                  const SizedBox(height: 28.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(context.l10n.confirmnewpasswordasterisk,
                        style: AppTextStyles.body2),
                  ),
                  const SizedBox(height: 12.0),
                  CustomTextInput(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    onChanged: (_) => _validateInputs(),
                    errorText: _confirmPasswordError,
                  ),
                ],
              ),
            ),
      bottomNavigationBar: ElevatedBottomBar(
        child: PrimaryButton(
          onPressed: (){},
          label: context.l10n.savechanges,
          isActive:  _canSubmit,
        ),
      ),
    );
  }
}
