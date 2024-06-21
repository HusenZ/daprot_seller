import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_seller/bloc/auth_bloc/auth_events.dart';
import 'package:daprot_seller/bloc/auth_bloc/auth_state.dart';
import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/domain/connectivity_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBloc extends Bloc<AppEvents, AppState> {
  final SharedPreferences _preferences;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  static String gymName = "";
  bool isExists = false;

  AppBloc(this._preferences) : super(InitialState()) {
    on<CheckPhoneEvent>((event, emit) async {
      // emit(AppStateLoading());
      // isExists =
      //     await EmailVerificationRepo.checkPhoneNumberExists(event.phoneNumber);
      // print("isExists Value ------ $isExists ------");
      // emit(
      //   PhoneNumberExistsState(
      //       phoneNumber: event.phoneNumber, isExists: isExists),
      // );
      // emit(AppStateSuccess());
    });

    on<OtpVerificationEvent>(
      (event, emit) async {
        emit(AppStateLoading());
        emit(OtpVerificationState(otp: event.otp, vercode: event.varcode));
        try {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: event.varcode,
            smsCode: event.otp,
          );

          await FirebaseAuth.instance.signInWithCredential(credential);

          _preferences.setBool('isAuthenticated', true);
          emit(OtpVerificationSuccessState());
          print("preferences = ${_preferences.getBool("isAuthenticated")}");
        } on FirebaseAuthException catch (e) {
          emit(
            OtpVerificationFailureState(
              errorMessage: e.message.toString(), // proper message...
            ),
          );
        }
      },
    );

    on<SignUpEvent>(
      (event, emit) async {
        debugPrint("signupEvent is called");

        emit(AppStateLoading());
        try {
          String vercode;
          await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: event.phoneNumber,
              verificationCompleted: (PhoneAuthCredential credential) async {},
              codeSent: (String verificationId, int? resendToken) {
                vercode = verificationId;
                ConnectivityHelper.naviagte(
                  event.context,
                  Routes.otpRoute,
                  args: {
                    'name': event.fullName,
                    'email': event.email,
                    'phoneNumber': event.phoneNumber,
                    'profile': event.profile,
                    'vercode': vercode
                  },
                );
              },
              verificationFailed: (FirebaseAuthException e) {},
              codeAutoRetrievalTimeout: (String verificationId) {
                vercode = verificationId;
              },
              timeout: const Duration(seconds: 120));
        } catch (error) {
          emit(
            AppStateFailure(
              errorMessage: error.toString(),
            ),
          );
        }
      },
    );
    on<LogOutEvent>((event, emit) async {
      emit(AppStateLoading());
      try {
        await FirebaseAuth.instance.signOut();
        _preferences.setBool('isAuthenticated', false);
        print("User logged out successfully");
        emit(AppStateSuccess());
      } catch (e) {
        print("Error during logout: $e");
        emit(AppStateFailure(errorMessage: e.toString()));
      }
    });
  }
}
