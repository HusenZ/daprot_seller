import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class InputBrandLogoUi extends StatelessWidget {
  const InputBrandLogoUi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 13.h,
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: ColorsManager.lightGreyColor!,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.file_upload_outlined,
              color: ColorsManager.lightGreyColor,
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              'Supports : JPG,PNG,JPEG,WEBP',
              style: TextStyle(color: ColorsManager.lightGreyColor),
            )
          ],
        ));
  }
}

class InputProImaUi extends StatelessWidget {
  const InputProImaUi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 13.h,
        width: 30.w,
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: ColorsManager.lightGreyColor!,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.file_upload_outlined,
              color: ColorsManager.lightGreyColor,
            ),
            Text(
              "Image of the product",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: ColorsManager.greyColor),
            )
          ],
        ));
  }
}
