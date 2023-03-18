part of 'get_single_user_cubit.dart';

abstract class GetSingleUserState extends Equatable {
  final UserEntity? user;
  const GetSingleUserState(this.user);

  @override
  List<Object> get props => [];
}

class GetSingleUserInitial extends GetSingleUserState {
  GetSingleUserInitial(super.user);

  @override
  List<Object> get props => [];
}

class GetSingleUserLoading extends GetSingleUserState {
  GetSingleUserLoading(super.user);

  @override
  List<Object> get props => [];
}

class GetSingleUserLoaded extends GetSingleUserState {
  final UserEntity user;
  GetSingleUserLoaded({required this.user}) : super(user);
  @override
  List<Object> get props => [user];
}

class GetSingleUserFailure extends GetSingleUserState {
  GetSingleUserFailure(super.user);

  @override
  List<Object> get props => [];
}
