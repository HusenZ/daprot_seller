import 'package:equatable/equatable.dart';

abstract class GoogleSignInState extends Equatable {
  const GoogleSignInState();

  @override
  List<Object> get props => [];
}

class GoogleSignInInitial extends GoogleSignInState {}

class GoogleSignInLoading extends GoogleSignInState {}

class GoogleSignInSuccess extends GoogleSignInState {}

class NavigateToHomeRoute extends GoogleSignInState {}

class SetProfileState extends GoogleSignInState {}

class GoogleSignInFailure extends GoogleSignInState {
  final String message;

  const GoogleSignInFailure(this.message);

  @override
  List<Object> get props => [message];
}
