part of 'profile_bloc.dart';

enum ProfileStatus { loading, loaded }

class ProfileState extends Equatable {
  final UserModel? user;
  final ProfileStatus profileStatus;
  const ProfileState._({this.user, this.profileStatus = ProfileStatus.loading});
  const ProfileState.loading() : this._();
  const ProfileState.loaded(
      {required UserModel user, required ProfileStatus profileStatus})
      : this._(user: user, profileStatus: profileStatus);

  @override
  List<Object?> get props => [user, profileStatus];
}
