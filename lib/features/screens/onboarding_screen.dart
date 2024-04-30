import 'package:daprot_seller/config/constants/onboarding_content.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/features/widgets/onboarding_widget/animated_container.dart';
import 'package:daprot_seller/features/widgets/onboarding_widget/bottom_row_buttons.dart';
import 'package:daprot_seller/features/widgets/onboarding_widget/get_started_button.dart';
import 'package:daprot_seller/features/widgets/onboarding_widget/onboarding_listview_item_builder.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    double width = 100.w;
    double height = 100.h;

    return Scaffold(
      backgroundColor: ColorsManager.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, index) {
                  return OnBoardingPageViewItem(
                    height: height,
                    width: width,
                    i: index,
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                      (int index) => OnBoardingAnimatedContainer(
                        currentPage: _currentPage,
                        index: index,
                      ),
                    ),
                  ),
                  _currentPage + 1 == contents.length
                      ? const GetStartedButton()
                      : BottomButtons(controller: _controller, width: width)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
