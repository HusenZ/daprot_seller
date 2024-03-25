import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.validator,
    this.width,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final FormFieldValidator? validator;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleY: 0.23.w,
      child: SizedBox(
        width: width,
        child: TextFormField(
          keyboardType: keyboardType,
          controller: controller,
          validator: validator,
          style: TextStyle(
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: ColorsManager.accentColor, width: 2.0),
              borderRadius: BorderRadius.circular(3.w),
            ),
            helperText: " ",
            hintText: hintText,
            hintStyle:
                TextStyle(fontSize: 15.sp, color: ColorsManager.greyColor),
            helperStyle: const TextStyle(
              color: Colors.red,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DescriptionFormField extends StatelessWidget {
  const DescriptionFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    required this.width,
    required this.height,
  });

  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleY: 0.23.w,
      child: SizedBox(
        width: width,
        height: height,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: 50, // Allows multiple lines of input
          controller: controller,
          validator: validator,
          style: TextStyle(
            fontSize: 12.sp,
          ),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: ColorsManager.accentColor,
                width: 4.0,
              ),
              borderRadius: BorderRadius.circular(3.w),
            ),
            helperText: " ",
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 15.sp,
              color: ColorsManager.greyColor,
            ),
            helperStyle: const TextStyle(
              color: Colors.red,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
