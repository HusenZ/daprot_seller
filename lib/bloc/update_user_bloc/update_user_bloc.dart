import 'dart:async';
import 'package:daprot_seller/bloc/update_user_bloc/update_user_state.dart';
import 'package:daprot_seller/domain/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../update_user_bloc/update_event_event.dart';

class UserUpdateBloc extends Bloc<UserUpdateEvent, UserUpdateState> {
  static final _userUpdateController = StreamController<UserModel>.broadcast();

  static Stream<UserModel>? get userUpdateStream =>
      _userUpdateController.stream;

  UserUpdateBloc() : super(UserUpdateInitial()) {
    on<UpdateUserEvent>((event, emit) async {
      try {
        emit(UserUpdateLoading());

        print("In bloc");
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        print("Updated Event value ------> ${event.name} ${event.email}");
        await firestore
            .collection('Sellers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'email': event.email,
          'name': event.name,
          'phone': event.phone,
        });
        print("User Updated!");

        emit(UserUpdateSuccess());
        @override
        Future<void> close() {
          _userUpdateController.close();
          return super.close();
        }
      } catch (e) {
        print("Some error occurred $e");
        emit(const UserUpdateFailure("Failed to update user."));
      }
    });
  }
}
