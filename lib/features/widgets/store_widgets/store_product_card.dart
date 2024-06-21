import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StoreViewProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String image;
  final VoidCallback onTap;
  const StoreViewProductCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          height: 30.h,
          width: 40.w,
          color: ColorsManager.whiteColor,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.sp),
                child: Container(
                  height: 30.h,
                  width: 40.6.w,
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(1), BlendMode.dstATop),
                        image: NetworkImage(image)),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.sp),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color.fromARGB(126, 36, 43, 50),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 12.sp,
              ),
              Padding(
                padding: EdgeInsets.only(left: 1.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      maxLines: 1,
                      text: TextSpan(
                        text: title,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: ColorsManager.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp),
                      ),
                    ),
                    Text(
                      "₹$price",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: ColorsManager.whiteColor),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
