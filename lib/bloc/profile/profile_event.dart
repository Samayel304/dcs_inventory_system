part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserModel user;

  const UpdateProfile({required this.user});

  @override
  List<Object> get props => [user];
}

class EditProfile extends ProfileEvent {
  final UserModel user;
  final BuildContext context;

  const EditProfile(this.user, this.context);

  @override
  List<Object> get props => [user, context];
}
