import 'package:equatable/equatable.dart';

abstract class LocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocationInitialState extends LocationState {}

class LocationLoadingState extends LocationState {}

class LocationLoadedState extends LocationState {
  final String placeName;
  final double latitude;
  final double longitude;

  LocationLoadedState(this.placeName, this.latitude, this.longitude);

  @override
  List<Object?> get props => [placeName, longitude, latitude];
}

class LocationErrorState extends LocationState {
  final String error;

  LocationErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
