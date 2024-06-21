import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_seller/bloc/google_auth_bloc/googe_auth_bloc.dart';
import 'package:daprot_seller/bloc/google_auth_bloc/google_auth_event.dart';
import 'package:daprot_seller/bloc/google_auth_bloc/google_auth_state.dart';
import 'package:daprot_seller/config/constants/app_images.dart';
import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/connectivity_helper.dart';
import 'package:daprot_seller/features/screens/home_screen.dart';
import 'package:daprot_seller/features/screens/splash_screen.dart';
import 'package:daprot_seller/features/screens/under_reivew.dart';
import 'package:daprot_seller/features/widgets/common_widgets/loading_button.dart';
import 'package:daprot_seller/features/widgets/common_widgets/loading_dailog.dart';
import 'package:daprot_seller/features/widgets/common_widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  // final TextEditingController _emailContoller = TextEditingController();
  void showLoading() {
    LoadingDialog.showLoaderDialog(context);
  }

  Future<ApplicationStatus> createAdminFuture() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return ApplicationStatus.noMatch;
    }

    final snapshot = await FirebaseFirestore.instance.collection('Admin').get();

    for (var doc in snapshot.docs) {
      if (doc.data()['clientId'] == userId) {
        final status = doc.data()['applicationStatus'];
        if (status == 'verified') {
          return ApplicationStatus.verified;
        } else {
          return ApplicationStatus.unverified;
        }
      }
    }

    return ApplicationStatus.noMatch;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        reverse: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Image.asset(AppImages.vectorLogin),
                Image.asset(AppImages.daprotLogin),
                Positioned(
                  bottom: 0.5.h,
                  child: Container(
                    height: 2.5.h,
                    width: 100.w,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: const Text(''),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: ColorsManager.accentColor,
                    fontSize: 14.sp,
                  ),
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  WavyAnimatedText('Support local, enjoy fresh'),
                  WavyAnimatedText(' DAPROT connects you '),
                  WavyAnimatedText(' to your city\'s best'),
                ],
                isRepeatingAnimation: true,
                onTap: () {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 6.w, top: 4.h, right: 2.h),
              child: Text(
                'LOGIN',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            // SizedBox(height: 2.h),
            // Padding(
            //   padding: EdgeInsets.all(8.sp),
            //   child: Transform.scale(
            //     scaleY: 0.23.w,
            //     child: Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(2.w),
            //         color: ColorsManager.whiteColor,
            //         boxShadow: const [
            //           BoxShadow(),
            //         ],
            //       ),
            //       child: TextFormField(
            //         textCapitalization: TextCapitalization.sentences,
            //         textAlignVertical: TextAlignVertical.center,
            //         textAlign: TextAlign.start,
            //         cursorColor: ColorsManager.primaryColor,
            //         obscureText: false,
            //         controller: _emailContoller,
            //         validator: (value) {
            //           if (value == null || value.isEmpty) {
            //             return 'Enter the Email address';
            //           }
            //           String emailRegex =
            //               r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
            //           if (!RegExp(emailRegex).hasMatch(value)) {
            //             return 'Enter a valid Email address';
            //           }
            //           return null;
            //         },
            //         keyboardType: TextInputType.emailAddress,
            //         style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            //               fontSize: 12.sp,
            //             ),
            //         decoration: InputDecoration(
            //           labelStyle: TextStyle(
            //               fontSize: 13.sp,
            //               fontFamily: 'AppFonts',
            //               fontWeight: FontWeightManager.semiBold),
            //           labelText: 'Email',
            //           hintText: 'Type here...',
            //           disabledBorder: InputBorder.none,
            //           border: OutlineInputBorder(
            //               borderSide: const BorderSide(),
            //               borderRadius: BorderRadius.all(Radius.circular(3.w))),
            //           floatingLabelStyle: const TextStyle(
            //             color: ColorsManager.primaryColor,
            //             fontFamily: 'AppFonts',
            //           ),
            //           focusedBorder: OutlineInputBorder(
            //             borderSide: const BorderSide(
            //               color: ColorsManager.primaryColor,
            //             ),
            //             borderRadius: BorderRadius.all(Radius.circular(3.w)),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 1.h),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //       backgroundColor: ColorsManager.primaryColor,
            //       foregroundColor: const Color.fromARGB(255, 247, 241, 241),
            //       textStyle: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontSize: 15.sp)),
            //   child: const Text("Continue"),
            //   onPressed: () async {
            //     SharedPreferences preferences =
            //         await SharedPreferences.getInstance();
            //     isConnected().then((value) {
            //       if (value) {
            //         showLoading();
            //         PhoneVerificationApi.emailExists(
            //                 _emailContoller.text.trim())
            //             .then((value) {
            //           if (value) {
            //             FirebaseAuth.instance
            //                 .signInWithEmailAndPassword(
            //                     email: _emailContoller.text.trim(),
            //                     password: '1er3t4y5u67')
            //                 .then((value) {
            //               if (value.user != null) {
            //                 createAdminFuture().then((value) {
            //                   if (value == ApplicationStatus.unverified) {
            //                     preferences.setBool('isAuthenticated', true);
            //                     Navigator.pushAndRemoveUntil(
            //                       context,
            //                       MaterialPageRoute(
            //                           builder: (context) =>
            //                               const UnderReivew()),
            //                       (Route<dynamic> route) => false,
            //                     );
            //                   } else if (value == ApplicationStatus.verified) {
            //                     preferences.setBool('isAuthenticated', true);
            //                     ConnectivityHelper.replaceIfConnected(
            //                       context,
            //                       Routes.dashboard,
            //                     );
            //                   } else {
            //                     preferences.setBool('isAuthenticated', true);
            //                     Navigator.pushAndRemoveUntil(
            //                       context,
            //                       MaterialPageRoute(
            //                           builder: (context) => const HomeScreen()),
            //                       (Route<dynamic> route) => false,
            //                     );
            //                   }
            //                 });
            //               }
            //             });
            //           } else {
            //             Navigator.of(context).push(MaterialPageRoute(
            //               builder: (context) => EmailSetProfile(
            //                   email: _emailContoller.text.trim()),
            //             ));
            //           }
            //         });
            //       } else {
            //         customSnackBar(context, 'Check Your Connection', false);
            //       }
            //     });
            //   },
            // ),
            // SizedBox(height: 1.h),
            // Text(
            //   "OR",
            //   style: TextStyle(
            //       fontWeight: FontWeightManager.extraBold, fontSize: 12.sp),
            // ),
            SizedBox(height: 1.h),
            BlocConsumer<GoogleSignInBloc, GoogleSignInState>(
              listener: (context, state) {
                if (state is GoogleSignInLoading) {
                  _isLoading = true;
                  showLoading();
                }
                if (state is NavigateToHomeRoute) {
                  createAdminFuture().then((value) {
                    if (value == ApplicationStatus.unverified) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UnderReivew()),
                        (Route<dynamic> route) => false,
                      );
                    } else if (value == ApplicationStatus.verified) {
                      ConnectivityHelper.replaceIfConnected(
                        context,
                        Routes.dashboard,
                      );
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  });
                  _isLoading = false;
                }

                if (state is SetProfileState) {
                  ConnectivityHelper.naviagte(context, Routes.setProfileRoute);
                  _isLoading = false;
                }
                if (state is GoogleSignInFailure) {
                  _isLoading = false;
                  Navigator.pop(context);
                  customSnackBar(context, state.message, false);
                }
                if (state is GoogleSignInSuccess) {
                  _isLoading = false;
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                return _isLoading
                    ? const LoadingButton()
                    : Padding(
                        padding: EdgeInsets.all(8.sp),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.primaryColor,
                            foregroundColor: ColorsManager.whiteColor,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 15.sp),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundImage:
                                    AssetImage(AppImages.googleLogin),
                                backgroundColor: ColorsManager.lightGrey,
                              ),
                              SizedBox(
                                width: 1.h,
                              ),
                              const Text("Continue With Google"),
                            ],
                          ),
                          onPressed: () {
                            BlocProvider.of<GoogleSignInBloc>(context)
                                .add(GoogleSignInRequested());
                          },
                        ),
                      );
              },
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'By continuing you agree to \n',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 12.sp,
                        color: const Color.fromARGB(255, 183, 178, 178),
                      ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Terms and Conditions',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pushNamed(Routes.termsRoute);
                        },
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorsManager.primaryColor),
                    ),
                    TextSpan(
                      text: ' and ',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 12.sp, color: ColorsManager.greyColor),
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pushNamed(Routes.privacyRoute);
                        },
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorsManager.primaryColor),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InputTextField extends StatelessWidget {
  const InputTextField({
    super.key,
    required TextEditingController contactEditingController,
  }) : _contactEditingController = contactEditingController;

  final TextEditingController _contactEditingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter the Phone No.';
        }
        if (value.length != 10) {
          return 'Enter a valid Number';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixText: '+91 ',
        prefixStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
        hintText: 'Enter your phone number',
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.grey[400],
            ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorsManager.primaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 122, 119, 119), width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: TextInputType.number,
      controller: _contactEditingController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 2.h),
    );
  }
}
