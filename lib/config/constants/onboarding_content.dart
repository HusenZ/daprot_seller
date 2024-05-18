import 'package:daprot_seller/config/constants/lottie_img.dart';

class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: StringManager.onboardingTitle1,
    image: AppLottie.onBoard1,
    desc: StringManager.onboardingDesc1,
  ),
  OnboardingContents(
    title: StringManager.onboardingTitle2,
    image: AppLottie.onBoard2,
    desc: StringManager.onboardingDesc2,
  ),
  OnboardingContents(
    title: StringManager.onboardingTitle3,
    image: AppLottie.onBoard3,
    desc: StringManager.onboardingDesc3,
  ),
];

class StringManager {
  static const String onboardingTitle1 = "Go - Digital!";
  static const String onboardingTitle2 = "Intra - City";
  static const String onboardingTitle3 = "FREE";

  static const String onboardingDesc1 =
      "Want to take your business online for free ?";
  static const String onboardingDesc2 =
      "Helps you sell your products to the people in your city.";
  static const String onboardingDesc3 =
      "Don't worry we are completely free and no commission is charged.";
}
