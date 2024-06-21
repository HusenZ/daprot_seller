import 'package:equatable/equatable.dart';

abstract class UserUpdateEvent extends Equatable {
  const UserUpdateEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserEvent extends UserUpdateEvent {
  final String name;
  final String email;
  final String phone;

  // final String bio;
  final String userId;

  const UpdateUserEvent({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  List<Object> get props => [
        name,
        email,
      ];
}
