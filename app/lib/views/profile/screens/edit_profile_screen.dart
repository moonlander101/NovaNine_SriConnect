import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lanka_connect/components/appbar.dart';
import 'package:lanka_connect/l10n/localizations_helper.dart';
import '../../../components/custom_input.dart';
import '../../../components/elevated_bottom_bar.dart';
import '../../../components/file_picker.dart';
import '../../../components/gap.dart';
import '../../../components/margin.dart';
import '../../../components/primary_button.dart';
import '../../../theme/colors.dart';
import '../../../theme/dimens.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _displayNameError;
  String? _phoneError;
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  bool _validateInputs() {
    final displayName = _displayNameController.text.trim();
    final phoneNumber = _phoneController.value.text.trim();

    setState(() {
      _displayNameError =
          displayName.isEmpty ? context.l10n.displaynamecannotbeempty : null;
      _phoneError = phoneNumber.isEmpty
          ? context.l10n.phonenumbercannotbeempty
          : phoneNumber.length <= 10
              ? null
              : context.l10n.invalidphonenumber;
      _canSubmit = _displayNameError == null && _phoneError == null;
    });

    return _canSubmit;
  }

  Future<void> _loadProfile() async {}

  Future<void> _updateProfile() async {}

  Future<void> _uploadImage(File imageFile) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      appBar: AppBarCustom(
          title: context.l10n.editprofile, isBackButtonVisible: true),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.defaultScreenMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _profileImage(),
            Margin(),
            CustomTextInput(
              labelText: context.l10n.nameasteisk,
              hintText: context.l10n.nameHint,
              controller: _displayNameController,
              onChanged: (_) => _validateInputs(),
              errorText: _displayNameError,
            ),
            Gapz(),
            CustomTextInput(
              labelText: context.l10n.phonenumberasterisk,
              hintText: context.l10n.phoneNumberHint,
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
          onPressed: _updateProfile,
          label: context.l10n.savechanges,
          isActive: true,
          isLoading: false,
        ),
      ),
    );
  }

  Stack _profileImage() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.black,
          child: Text(
            'V',
            style: TextStyle(
              fontSize: 40,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: FilePickerInputWrapper(
            options: [
              PickerOptions.takePhoto,
              PickerOptions.imageGallery,
            ],
            onSelect: _uploadImage,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.black.shade700,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                child: const Icon(
                  Icons.edit,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
