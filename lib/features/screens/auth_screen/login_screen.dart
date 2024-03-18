import 'package:daprot_seller/bloc/auth_bloc/auth_bloc.dart';
import 'package:daprot_seller/bloc/auth_bloc/auth_events.dart';
import 'package:daprot_seller/bloc/auth_bloc/auth_state.dart';
import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
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
  final _contactEditingController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        reverse: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 15.h,
            ),
            Image.asset(
              "assets/images/dp.png",
              width: 95.h,
              height: 30.h,
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 6.w, top: 4.h),
              child: Text(
                'Login',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: 88.w,
              height: 7.h,
              child: InputTextField(
                  contactEditingController: _contactEditingController),
            ),
            SizedBox(height: 2.h),
            BlocConsumer<AppBloc, AppState>(
              listener: (context, state) {
                if (state is PhoneNumberExistsState) {
                  if (state.isExists) {
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pushNamed(
                      Routes.otpRoute,
                      arguments: {
                        'phoneNumber': '+91${_contactEditingController.text}',
                      },
                    );
                  } else {
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pushNamed(
                      Routes.setProfileRoute,
                      arguments: {
                        'phoneNumber': '+91${_contactEditingController.text}',
                      },
                    );
                  }
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
                        child: const Text("Continue"),
                        onPressed: () {
                          if (_contactEditingController.text.isNotEmpty &&
                              _contactEditingController.text.length == 10) {
                            _isLoading = true;

                            BlocProvider.of<AppBloc>(context).add(
                                CheckPhoneEvent(
                                    phoneNumber:
                                        '+91${_contactEditingController.text}'));
                          } else if (_contactEditingController.text.isEmpty) {
                            customSnackBar(context,
                                "Please enter your Mobile Number", false);
                          } else if (_contactEditingController.text.length !=
                              10) {
                            customSnackBar(
                                context, "Enter a valid Mobile Number", false);
                          }
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
