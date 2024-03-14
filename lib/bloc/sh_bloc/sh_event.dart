import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ShEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShForm1Event extends ShEvent {
  final String? shName;
  final String? location;
  final String? phoneNumber;
  final String? openTime;
  final String? closeTime;
  final bool? isParking;
  final XFile? brandlogo;

  ShForm1Event(
      {required this.shName,
      required this.location,
      required this.phoneNumber,
      required this.openTime,
      required this.closeTime,
      required this.isParking,
      required this.brandlogo});

  @override
  List<Object?> get props => [
        shName,
        location,
        phoneNumber,
        openTime,
        closeTime,
        isParking,
      ];
}

class ShForm2Event extends ShEvent {
  final XFile? fcImage;
  final XFile? ownerPhoto;
  final String? fullName;
  final String? phoneNumber;
  final String? panNumber;

  ShForm2Event({
    required this.fcImage,
    required this.ownerPhoto,
    required this.fullName,
    required this.phoneNumber,
    required this.panNumber,
  });

  @override
  List<Object?> get props => [
        fcImage,
        ownerPhoto,
        fullName,
        phoneNumber,
        panNumber,
      ];
}

class ShForm3Event extends ShEvent {
  final XFile? gstImage;
  final bool? isAccepted;

  ShForm3Event({
    required this.gstImage,
    required this.isAccepted,
  });

  @override
  List<Object?> get props => [
        gstImage,
        isAccepted,
      ];
}
