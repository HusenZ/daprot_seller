import 'package:gozip_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BannerWidget extends StatelessWidget {
  final String bannerImage;
  final String logo;
  final String shopName;

  const BannerWidget(
      {super.key,
      required this.bannerImage,
      required this.logo,
      required this.shopName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 25.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            image: DecorationImage(
              image: NetworkImage(bannerImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 17.h, left: 15.h, right: 15.h),
                  child: CircleAvatar(
                    radius: 32.sp,
                    backgroundColor: ColorsManager.whiteColor,
                    child: Container(
                      padding: EdgeInsets.all(8.h),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(logo),
                          fit: BoxFit.cover,
                        ),
                      ),
                      // child: CachedNetworkImage(
                      //   imageUrl: logo,
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
