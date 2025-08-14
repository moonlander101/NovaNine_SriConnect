
import 'package:flutter/material.dart';
import '../../../../components/elevated_bottom_bar.dart';
import '../../../../components/primary_button.dart';
import '../../../components/appbar.dart';
import '../../../components/custom_dropdown.dart';
import '../../../components/custom_input.dart';
import '../../../components/gap.dart';
import '../../../models/address.dart';
import '../../../theme/colors.dart';
import '../../../theme/dimens.dart';

class AddAddressScreen extends StatefulWidget {
  final Address? address;
  final String? addressID;

  const AddAddressScreen({super.key, this.address, this.addressID});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _unitNumberController;
  late final TextEditingController _buildingNameController;
  late final TextEditingController _streetController;
  late final TextEditingController _cityController;
  late final TextEditingController _districtController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _countryController;
  late AddressType _addressType;
  String? selectedCityId;
  String? selectedAreaId;
  bool get isEditing => widget.address != null;
  late bool isDefault;

  @override
  void initState() {
    super.initState();
    final a = widget.address;
    _nameController = TextEditingController(text: a?.name ?? '');
    _phoneNumberController = TextEditingController(text: a?.phoneNumber ?? '');
    _unitNumberController = TextEditingController(text: a?.unitNumber ?? '');
    _buildingNameController =
        TextEditingController(text: a?.buildingName ?? '');
    _streetController = TextEditingController(text: a?.street ?? '');
    _cityController = TextEditingController(text: a?.city ?? '');
    _districtController = TextEditingController(text: a?.district ?? '');
    _postalCodeController = TextEditingController(text: a?.postalCode ?? '');
    _countryController = TextEditingController(text: a?.country ?? '');
    _addressType = a?.addressType ?? AddressType.home;
    isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _unitNumberController.dispose();
    _buildingNameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      appBar: AppBarCustom(
        title: isEditing ? "Edit Address" : "Add Address",
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.defaultScreenMarginSM),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextInput(
                hintText: "Enter your name",
                labelText: "Name",
                controller: _nameController,
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              Gapz(),
              CustomDropdownInput(
                labelText: "Address Type",
                options: AddressType.values.map((e) => e.name).toList(),
                initialValue:
                    widget.address?.addressType.name ?? AddressType.home.name,
                includeOther: false,
                
                onChanged: (val) {
                  setState(() {
                    if (val != null) {
                      _addressType = AddressType.values.firstWhere(
                        (e) => e.name == val,
                        orElse: () => AddressType.home,
                      );
                    }
                  });
                },
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              CustomTextInput(
                labelText: "Phone Number",
                hintText: "Enter your phone number",
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              Gapz(),
              CustomTextInput(
                hintText: _addressType == AddressType.home
                    ? "Enter your house number"
                    : "Enter your apartment number",
                labelText: _addressType == AddressType.home
                    ? "House Number"
                    : "Apartment Number",
                controller: _unitNumberController,
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              Gapz(),
              CustomTextInput(
                hintText: _addressType == AddressType.home
                    ? "Enter your house name"
                    : "Enter your apartment name",
                labelText: _addressType == AddressType.home
                    ? "House Name"
                    : "Apartment Name",
                controller: _buildingNameController,
              ),
              Gapz(),
              CustomTextInput(
                hintText: "Enter your street",
                labelText: "Street",
                controller: _streetController,
              ),
              Gapz(),
              CustomTextInput(
                labelText: "Postal Code",
                controller: _postalCodeController,
                keyboardType: TextInputType.number,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Dimens.defaultMarginSM),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Default Address",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    value: isDefault,
                    activeColor: AppColors.white,
                    activeTrackColor: AppColors.blue,
                    inactiveThumbColor: AppColors.blue,
                    inactiveTrackColor: AppColors.white,
                    trackOutlineColor:
                        WidgetStateProperty.all(AppColors.border),
                    onChanged: (val) {
                      setState(() {
                        isDefault = val;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(Dimens.defaultScreenMarginSM),
      //   child: ElevatedButton(
      //     onPressed: _submit,
      //     child: Text(isEditing ? "Update Address" : "Save Address"),
      //   ),
      // ),
      bottomNavigationBar: ElevatedBottomBar(
        child: SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            onPressed: _submit,
            label: isEditing ? "Update Address" : "Save Address",
          ),
        ),
      ),
    );
  }
}
