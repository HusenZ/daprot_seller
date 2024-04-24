import 'package:equatable/equatable.dart';

abstract class UserUpdateEvent extends Equatable {
  const UserUpdateEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserEvent extends UserUpdateEvent {
  final String name;
  final String newProfileImagePath;
  final String email;
  final String phone;
  final bool isProfileUpdated;

  // final String bio;
  final String userId;

  const UpdateUserEvent({
    required this.userId,
    required this.name,
    required this.newProfileImagePath,
    required this.email,
    required this.isProfileUpdated,
    required this.phone,
  });

  @override
  List<Object> get props =>
      [name, newProfileImagePath, email, isProfileUpdated];
}
