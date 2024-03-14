import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';

class DelevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final ButtonStyle? style;
  const DelevatedButton({
    super.key,
    required this.text,
    required this.onTap,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: style ??
          ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.primaryColor,
            foregroundColor: ColorsManager.whiteColor,
            elevation: 5,
          ),
      child: Text(text),
    );
  }
}
