import 'package:image_picker/image_picker.dart';

abstract class AppState {
  AppState();
}

class InitialState extends AppState {}

class AppStateLoading extends AppState {}

class AppStateSuccess extends AppState {}

class AppStateFailure extends AppState {
  final String errorMessage;

  AppStateFailure({required this.errorMessage});
}

class PhoneNumberExistsState extends AppState {
  final bool isExists;
  final String phoneNumber;
  PhoneNumberExistsState({required this.phoneNumber, required this.isExists});

  List<Object?> get props => [phoneNumber, isExists];
}

class OtpVerificationState extends AppState {
  final String? otp;
  final String vercode;
  final String? fullname;
  final String? email;
  final String? phoneNo;
  final String? location;
  final XFile? profilePhoto;
  OtpVerificationState(
      {required this.vercode,
      required this.otp,
      this.email,
      this.fullname,
      this.phoneNo,
      this.location,
      this.profilePhoto});
}

class OtpVerificationSuccessState extends AppState {
  final String? fullname;
  final String? email;
  final String? phoneNo;
  final String? location;
  final XFile? profilePhoto;
  OtpVerificationSuccessState(
      {this.email,
      this.fullname,
      this.phoneNo,
      this.profilePhoto,
      this.location});
}

class OtpVerificationFailureState extends AppState {
  final String errorMessage;

  OtpVerificationFailureState({
    required this.errorMessage,
  });
}
