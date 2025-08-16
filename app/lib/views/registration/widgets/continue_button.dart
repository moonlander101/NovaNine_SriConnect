import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;

  const ContinueButton({
    Key? key,
    this.text = 'Continue',
    this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor = backgroundColor ?? 
        (isEnabled ? const Color(0xFF2BA1F3) : const Color(0xFF838383));
    Color txtColor = textColor ?? 
        (isEnabled ? Colors.white : const Color(0xFFE1E1E2));

    return Container(
      width: width ?? 373,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: bgColor,
      ),
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor: bgColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: txtColor,
                  fontFamily: text == 'Continue' ? 'DM Sans' : 'Noto Sans',
                ),
              ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final double? width;
  final EdgeInsets? padding;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isEnabled = true,
    this.width,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: 64,
      padding: padding,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2BA1F3),
          disabledBackgroundColor: const Color(0xFF838383),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isEnabled ? Colors.white : const Color(0xFFE1E1E2),
            fontFamily: 'DM Sans',
          ),
        ),
      ),
    );
  }
}