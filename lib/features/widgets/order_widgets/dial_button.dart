import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class DialButton extends StatelessWidget {
  final String phoneNumber;

  const DialButton({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final Uri launchUri = Uri(
          scheme: 'tel',
          path: phoneNumber,
        );
        await launchUrl(launchUri);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 54, 194, 59),
          foregroundColor: ColorsManager.whiteColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.phone,
            color: ColorsManager.whiteColor,
          ),
          SizedBox(width: 3.w),
          Text(
            'Call Now',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: ColorsManager.whiteColor, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
