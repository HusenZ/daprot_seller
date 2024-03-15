import 'package:daprot_seller/bloc/sh_bloc/sh_event.dart';
import 'package:daprot_seller/bloc/sh_bloc/sh_state.dart';
import 'package:daprot_seller/domain/shop_form_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShBloc extends Bloc<ShEvent, ShState> {
  ShBloc() : super(ShState()) {
    on<ShForm1Event>((event, emit) {
      // Push the data to the fire base
      emit(ShForm1State(
        shName: event.shName,
        location: event.location,
        phoneNumber: event.phoneNumber,
        openTime: event.openTime,
        closeTime: event.closeTime,
        isDiliverable: event.isParking,
      ));

      ShopFormRepo.addForm1(
          shNameIn: event.shName!,
          shopLogo: event.brandlogo,
          location: event.location!,
          phoneNo: event.phoneNumber!,
          openTime: event.openTime!,
          closeTime: event.closeTime!,
          isAvailable: event.isParking!);
    });

    on<ShForm2Event>(
      (event, emit) {
        // Push the data to the fire base
        emit(ShForm2State(
          shopBanner: event.bannerImage,
          ownerPhoto: event.ownerPhoto,
          fullName: event.fullName,
          phoneNumber: event.phoneNumber,
          panNumber: event.panNumber,
        ));

        ShopFormRepo.addForm2(
            name: event.fullName!,
            shopBanner: event.bannerImage,
            ownerphoto: event.ownerPhoto,
            phoneNo: event.panNumber!,
            panNo: event.panNumber!);
      },
    );

    on<ShForm3Event>((event, emit) {
      emit(ShForm3State(
        gstCeritificate: event.gstImage,
        isAccepted: event.isAccepted,
      ));

      ShopFormRepo.addForm3(
          coditionacceptance: event.isAccepted!, gstImg: event.gstImage);
    });
  }
}
