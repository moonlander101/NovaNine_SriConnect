import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomInputField extends StatefulWidget {
  final String? label;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final bool showLabel;

  const CustomInputField({
    super.key,
    this.label,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.showLabel = true,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel && widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.body16,
          ),
          const SizedBox(height: 12),
        ],
        Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusXXL),
            border: Border.all(
              color: AppColors.inputBorder,
              width: 1,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            obscureText: widget.obscureText ? _isObscured : false,
            keyboardType: widget.keyboardType,
            style: AppTextStyles.body16,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyles.placeholder,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 23,
                vertical: 20,
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.primaryText,
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    )
                  : widget.suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
