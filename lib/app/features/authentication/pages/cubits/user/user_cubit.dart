import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cos_challenge/app/core/errors/failures.dart';
import 'package:flutter_cos_challenge/app/features/authentication/models/user.dart';
import 'package:flutter_cos_challenge/app/features/authentication/repositories/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit(this.userRepository) : super(UserLoggedOut());

  Future<void> getUser() async {
    emit(UserLoading());

    final userEither = await userRepository.getUser();

    userEither.fold(
      (failure) => emit(UserError(failure)),
      (user) => emit(UserLoggedIn(user)),
    );
  }

  Future<void> authenticate({
    required String email,
    required String password,
  }) async {
    emit(UserLoading());

    final userEither = await userRepository.authenticate(
      email: email,
      password: password,
    );

    userEither.fold(
      (failure) => emit(UserError(failure)),
      (user) => emit(UserLoggedIn(user)),
    );
  }

  Future<void> logout() async {
    emit(UserLoading());

    final logoutEither = await userRepository.logout();

    logoutEither.fold(
      (failure) => emit(UserError(failure)),
      (_) => emit(UserLoggedOut()),
    );
  }
}
