import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';

class OnBoardingAnimatedContainer extends StatelessWidget {
  const OnBoardingAnimatedContainer(
      {super.key, required this.currentPage, required this.index});
  final int currentPage;
  final int index;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
        color: currentPage == index
            ? ColorsManager.primaryColor
            : ColorsManager.darkPrimaryColor,
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: currentPage == index ? 20 : 10,
    );
  }
}
