import 'package:daprot_seller/bloc/auth_bloc/auth_state.dart';
import 'package:daprot_seller/bloc/google_auth_bloc/googe_auth_bloc.dart';
import 'package:daprot_seller/bloc/google_auth_bloc/google_auth_event.dart';
import 'package:daprot_seller/bloc/google_auth_bloc/google_auth_state.dart';
import 'package:daprot_seller/config/constants/app_images.dart';
import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/connectivity_helper.dart';
import 'package:daprot_seller/features/widgets/common_widgets/loading_button.dart';
import 'package:daprot_seller/features/widgets/common_widgets/snack_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(254, 233, 231, 235),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        reverse: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 15.h,
            ),
            Image.asset(AppImages.daprotLogin),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 6.w, top: 4.h, right: 2.h),
              child: Text(
                'Login',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            SizedBox(height: 2.h),
            BlocConsumer<GoogleSignInBloc, GoogleSignInState>(
              listener: (context, state) {
                if (state is GoogleSignInLoading) {
                  _isLoading = true;
                }
                if (state is NavigateToEnrollRoute) {
                  ConnectivityHelper.naviagte(context, Routes.homeRoute);
                  _isLoading = false;
                }
                if (state is SetProfileState) {
                  ConnectivityHelper.naviagte(context, Routes.setProfileRoute);
                  _isLoading = false;
                }
                if (state is GoogleSignInFailure) {
                  _isLoading = false;
                  customSnackBar(context, 'Error in signin', false);
                }
                if (state is GoogleSignInSuccess) {
                  _isLoading = false;
                }
              },
              builder: (context, state) {
                if (state is AppStateLoading) {
                  _isLoading = true;
                }
                return _isLoading
                    ? const LoadingButton()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.accentColor,
                            foregroundColor: ColorsManager.whiteColor,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 20.sp)),
                        child: const Text("Sign In With Google"),
                        onPressed: () {
                          BlocProvider.of<GoogleSignInBloc>(context)
                              .add(GoogleSignInRequested());
                        },
                      );
              },
            ),
            SizedBox(
              height: 10.h,
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
                      // recognizer: TapGestureRecognizer()..onTap = () {},
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
                      // recognizer: TapGestureRecognizer()..onTap = () {},
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
