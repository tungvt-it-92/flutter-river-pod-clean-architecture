import 'package:flutter/material.dart';
import '../styles/index.dart';

class SolidButton extends StatelessWidget {
  final Color? backgroundColor;
  final double? height;
  final double? width;

  final TextStyle? titleStyle;
  final String title;

  final VoidCallback? onPressed;
  final double borderRadius;
  final BorderSide? borderSide;

  const SolidButton({
    required this.title,
    this.height = 44,
    this.width,
    this.backgroundColor,
    this.titleStyle,
    this.onPressed,
    this.borderRadius = 10,
    this.borderSide,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            //side: borderSide ?? const BorderSide(width: 1)
          ),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(
          backgroundColor ?? AppColors.primaryColor,
        ),
      ),
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: Text(title, style: titleStyle ?? titleMedium),
        ),
      ),
    );
  }
}
