import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/colors.dart';
import '../theme/dimens.dart';
import '../theme/text.dart';

class CustomDropdownInput extends StatefulWidget {
  const CustomDropdownInput(
      {super.key,
      required this.labelText,
      required this.options,
      required this.onChanged,
      this.initialValue,
      this.validator,
      this.includeOther = false,
      this.hintText});

  final String labelText;
  final List<String> options;
  final String? initialValue;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final bool includeOther;
  final String? hintText;

  @override
  State<CustomDropdownInput> createState() => _CustomDropdownInputState();
}

class _CustomDropdownInputState extends State<CustomDropdownInput> {
  String? selectedValue;
  late TextEditingController _otherController;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.options.contains(widget.initialValue)
        ? widget.initialValue
        : widget.includeOther && widget.initialValue != null
            ? 'Other'
            : null;

    _otherController = TextEditingController(
      text: widget.includeOther &&
              widget.initialValue != null &&
              !widget.options.contains(widget.initialValue)
          ? widget.initialValue
          : '',
    );
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> dropdownItems = widget.options
        .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option, style: AppTextStyles.body2),
            ))
        .toList();

    if (widget.includeOther) {
      dropdownItems.add(
        DropdownMenuItem(
          value: 'Other',
          child: Text('Other', style: AppTextStyles.body2),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimens.defaultMarginB),
        Text(widget.labelText,
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          icon: const Icon(Iconsax.arrow_down_1, color: AppColors.black),
          isExpanded: true,
          value: selectedValue,
          items: dropdownItems,
          validator: widget.validator,
          hint: Text(
            widget.hintText ?? 'Select an option',
            style:
                AppTextStyles.body2.copyWith(color: AppColors.black.shade400),
          ),
          onChanged: (val) {
            setState(() {
              selectedValue = val;
              if (val == 'Other') {
                widget.onChanged(_otherController.text);
              } else {
                widget.onChanged(val);
                _otherController.clear();
              }
            });
          },
          decoration: _inputDecoration(),
        ),
        if (selectedValue == 'Other')
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              controller: _otherController,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: 'Please specify',
                hintStyle: AppTextStyles.body2
                    .copyWith(color: AppColors.black.shade400),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: _border(AppColors.blue.shade200),
                focusedBorder: _border(AppColors.blue.shade200),
              ),
            ),
          ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      errorBorder: _border(AppColors.red),
      focusedErrorBorder: _border(AppColors.red, width: 2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: _border(AppColors.blue.shade200),
      focusedBorder: _border(AppColors.blue),
      border: _border(AppColors.blue.shade200),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 0.8}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
