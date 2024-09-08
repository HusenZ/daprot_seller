import 'package:gozip_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DPhoneNumFiled extends StatelessWidget {
  const DPhoneNumFiled(
      {super.key,
      required this.contactEditingController,
      this.width,
      this.height,
      this.fontSize,
      required this.labelText,
      this.hintText});

  final TextEditingController contactEditingController;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool labelText;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Form(
        child: TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            prefix: Text(
              '+91 ',
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            labelText: labelText ? "Phone Number" : '',
            labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: fontSize, color: ColorsManager.hintTextColor),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorsManager.primaryColor),
              borderRadius: BorderRadius.circular(16.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: ColorsManager.greyColor,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
          keyboardType: TextInputType.number,
          controller: contactEditingController,
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
          ],
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}
