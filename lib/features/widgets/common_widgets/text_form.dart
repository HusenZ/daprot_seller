import 'package:gozip_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DTextformField extends StatelessWidget {
  const DTextformField(
      {super.key,
      required this.controller,
      this.inputTextSize,
      this.label,
      required this.readOnly,
      this.hintText,
      this.validator,
      this.keyboardType});

  final TextEditingController controller;
  final double? inputTextSize;
  final String? label;
  final bool readOnly;
  final String? hintText;
  final TextInputType? keyboardType;
  final FormFieldValidator? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      validator: validator,
      keyboardType: keyboardType,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: inputTextSize,
          ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: ColorsManager.hintTextColor,
              fontSize: 15.sp,
            ),
        border: const OutlineInputBorder(),
        floatingLabelStyle: const TextStyle(
          color: ColorsManager.accentColor,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
    );
  }
}
