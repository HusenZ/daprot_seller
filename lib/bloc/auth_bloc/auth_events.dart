import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AppEvents {
  const AppEvents();
}

@immutable
class CheckPhoneEvent implements AppEvents {
  final String phoneNumber;

  const CheckPhoneEvent({
    required this.phoneNumber,
  });
}

class OtpVerificationEvent extends AppEvents {
  final String otp;
  final String varcode;
  final String phoneNumber;
  final String gymName;

  const OtpVerificationEvent({
    required this.otp,
    required this.varcode,
    required this.phoneNumber,
    required this.gymName,
  });
}

class SignUpEvent extends AppEvents {
  final String fullName;
  final XFile? profile;
  final String email;
  final String phoneNumber;

  final BuildContext context;

  const SignUpEvent({
    required this.profile,
    required this.context,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });
}

class LogOutEvent extends AppEvents {}
