import 'package:gozip_seller/config/theme/colors_manager.dart';
import 'package:gozip_seller/config/theme/fonts_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class InputTimeWidget extends StatelessWidget {
  const InputTimeWidget({
    super.key,
    required this.openTimeController,
    required this.hintText,
    required this.width,
    required this.height,
    required this.validator,
  });

  final TextEditingController openTimeController;
  final String hintText;
  final double width;
  final double height;
  final FormFieldValidator validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        keyboardType: TextInputType.datetime,
        controller: openTimeController,
        validator: validator,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 16.sp,
            ),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorsManager.accentColor, width: 1.w),
            borderRadius: BorderRadius.circular(18.0),
          ),
          helperText: " ",
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: FontSize.s12,
                color: Colors.grey,
              ),
          helperStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.red,
              ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}
