part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

final class UserLoggedOut extends UserState {}

final class UserLoading extends UserState {}

final class UserError extends UserState {
  final Failure failure;

  const UserError(this.failure);

  @override
  List<Object?> get props => [failure];
}

final class UserLoggedIn extends UserState {
  final User user;

  const UserLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}
