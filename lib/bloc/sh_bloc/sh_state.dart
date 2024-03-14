import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:image_picker/image_picker.dart';

@immutable
class ShState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShForm1State extends ShState {
  final String? shName;
  final String? location;
  final String? phoneNumber;
  final String? openTime;
  final String? closeTime;
  final bool? isDiliverable;

  ShForm1State({
    required this.shName,
    required this.location,
    required this.phoneNumber,
    required this.openTime,
    required this.closeTime,
    required this.isDiliverable,
  });

  @override
  List<Object?> get props => [
        shName,
        location,
        phoneNumber,
        openTime,
        closeTime,
        isDiliverable,
      ];
}

class ShForm2State extends ShState {
  final XFile? shopBanner;
  final XFile? ownerPhoto;
  final String? fullName;
  final String? phoneNumber;
  final String? panNumber;

  ShForm2State({
    required this.shopBanner,
    required this.ownerPhoto,
    required this.fullName,
    required this.phoneNumber,
    required this.panNumber,
  });

  @override
  List<Object?> get props => [
        shopBanner,
        ownerPhoto,
        fullName,
        phoneNumber,
        panNumber,
      ];
}

class ShForm3State extends ShState {
  final XFile? gstCeritificate;
  final bool? isAccepted;

  ShForm3State({
    required this.gstCeritificate,
    required this.isAccepted,
  });

  @override
  List<Object?> get props => [
        gstCeritificate,
        isAccepted,
      ];
}
