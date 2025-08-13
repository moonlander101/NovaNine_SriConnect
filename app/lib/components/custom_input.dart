import '../theme/colors.dart';
import '../theme/dimens.dart';
import '../theme/text.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomTextInput extends StatefulWidget {
  const CustomTextInput({
    super.key,
    this.labelText,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.hintText,
    this.initialValue,
    this.prefixIcon,
    this.validator,
    this.isPrefixIcon = false,
  });

  final String? labelText;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool obscureText;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String? initialValue;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final bool isPrefixIcon;

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  bool _isObscure = false;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimens.defaultMarginB),
        Text(widget.labelText ?? '',
            style: AppTextStyles.body2.copyWith(
              fontWeight: FontWeight.w500,
            )),
        const SizedBox(height: 12),
        TextFormField(
          
          initialValue: widget.controller == null ? widget.initialValue : null,
          validator: widget.validator,
          controller: widget.controller,
          cursorColor: AppColors.black.shade700,
          cursorWidth: 1.5,
          obscureText: _isObscure,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          
          style: AppTextStyles.body2,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: Dimens.defaultScreenMarginSM),
            filled: true,
            fillColor: Colors.white,
            errorMaxLines: 2,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            prefixIcon: widget.isPrefixIcon ? widget.prefixIcon : null,
            suffixIcon: widget.obscureText
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: Icon(
                      _isObscure ? Iconsax.eye : Iconsax.eye_slash,
                      color: AppColors.black.shade200,
                    ),
                  )
                : null,
            // labelText: widget.labelText,
            labelStyle: AppTextStyles.body1.copyWith(
              color: AppColors.black.shade300,
              fontWeight: FontWeight.w400,
            ),
            floatingLabelStyle: AppTextStyles.body1.copyWith(
              color: AppColors.black.shade500,
              fontWeight: FontWeight.w500,
            ),
            errorText: widget.errorText,
            errorStyle: AppTextStyles.body3.copyWith(
              color: AppColors.red,
              fontSize: 12,
            ),
            hintText: widget.hintText,
            hintStyle: AppTextStyles.body2.copyWith(
              color: AppColors.black.shade300,
              fontWeight: FontWeight.w400,
            ),
            focusColor: AppColors.black.shade50,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2 * Dimens.defaultRadiusL),
              borderSide: BorderSide(
                color: AppColors.black.shade500,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2 * Dimens.defaultRadiusL),
              borderSide: BorderSide(
                color: AppColors.black.shade100,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2 * Dimens.defaultRadiusL),
              borderSide: BorderSide(
                color: AppColors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2 * Dimens.defaultRadiusL),
              borderSide: BorderSide(
                color: AppColors.red,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
