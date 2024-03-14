import 'dart:async';

import 'package:daprot_seller/bloc/auth_bloc/auth_bloc.dart';
import 'package:daprot_seller/bloc/auth_bloc/auth_events.dart';
import 'package:daprot_seller/bloc/auth_bloc/auth_state.dart';
import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/connectivity_helper.dart';
import 'package:daprot_seller/domain/sign_up_repo.dart';
import 'package:daprot_seller/features/widgets/common_widgets/delevated_button.dart';
import 'package:daprot_seller/features/widgets/common_widgets/loading_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  late Timer _timer;

  TextEditingController textEditingController = TextEditingController();

  // StreamController? errorController;

  String currentText = "";

  int _countdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ));

    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canResend = true;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    textEditingController.dispose();
    super.dispose();
  }

  Future<bool> signInWithVerificationCode(
      String verificationId, String smsCode) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true; // Sign-in successful
    } catch (e) {
      print('Error signing in with verification code: $e');
      return false; // Sign-in failed
    }
  }

  String getPhoneNumber() {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String phoneNumber = '';
    if (args.containsKey('phoneNumber') && args['phoneNumber'] != null) {
      phoneNumber = args['phoneNumber'];
      if (args.containsKey('name') && args.containsKey('email')) {
      } else {}
    }
    return phoneNumber;
  }

  String getvercode() {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String vercode = '';
    if (args.containsKey('vercode') && args["vercode"] != null) {
      vercode = args['vercode'];
    }
    // debugPrint("verification code is $vercode");
    return vercode;
  }

  @override
  Widget build(BuildContext context) {
    String phoneNumber = getPhoneNumber();

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    phoneNumber = args['phoneNumber'];
    XFile? profile = args['profile'];
    String? email = args['email'];
    String? name = args['name'];
    bool isLoading = false;

    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) async {
        if (state is AppStateLoading) {
          setState(() {
            isLoading = true;
          });
        }
        if (state is AppStateSuccess) {
          setState(() {
            isLoading = false;
          });
          ConnectivityHelper.replaceIfConnected(context, Routes.homeRoute);
        }
        if (state is OtpVerificationSuccessState) {
          await SignUpApi.addUser(
            email: email!,
            profile: profile!,
            phone: phoneNumber,
            name: name!,
          ).then((value) {
            if (value == true) {
              ConnectivityHelper.replaceIfConnected(context, Routes.homeRoute);
            } else {}
          });
        }
        if (state is OtpVerificationFailureState) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Verification Code',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 24.sp,
                  ),
            ),
            Text(
              'Please type the verification code sent to $phoneNumber',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 126, 124, 124),
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
            Container(
                margin: EdgeInsets.only(
                    left: screenWidth * 0.025, right: screenWidth * 0.025),
                child: PinCodeTextField(
                  appContext: context,
                  pastedTextStyle: const TextStyle(
                    color: ColorsManager.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 6,
                  obscureText: true,
                  blinkWhenObscuring: true,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: screenWidth * 0.13,
                    activeFillColor: const Color.fromARGB(255, 255, 255, 255),
                    activeColor: Colors.grey,
                    selectedColor: ColorsManager.secondaryColor,
                    inactiveColor: Colors.grey,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                  boxShadows: const [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                  onCompleted: (v) {
                    debugPrint("Completed");
                  },
                  onChanged: (value) {
                    debugPrint(value);
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    debugPrint("Allowing to paste $text");

                    return true;
                  },
                )),
            _canResend
                ? TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: ColorsManager.accentColor,
                        shadowColor: Colors.black),
                    onPressed: () {
                      setState(() {
                        _countdown = 60;
                        _canResend = false;
                      });
                      startTimer();
                    },
                    child: const Text('Resend OTP'),
                  )
                : Text('Didn\'t receive OTP? (Resend in $_countdown seconds))'),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            isLoading
                ? const LoadingButton()
                : DelevatedButton(
                    text: "Log In",
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(218, 30, 3, 183),
                        foregroundColor: Colors.white,
                        textStyle: Theme.of(context).textTheme.bodyLarge),
                    onTap: () {
                      setState(() {
                        isLoading = true;
                      });
                      BlocProvider.of<AppBloc>(context)
                          .add(OtpVerificationEvent(
                        otp: textEditingController.text,
                        varcode: getvercode(),
                        phoneNumber: phoneNumber,
                        gymName: '',
                      ));
                    },
                  ),
          ],
        ));
      },
    );
  }
}
