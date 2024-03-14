import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primaryColor,
          foregroundColor: ColorsManager.whiteColor,
          textStyle:
              Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20.sp)),
      onPressed: () {},
      child: const Text("Loading..."),
    );
  }
}
