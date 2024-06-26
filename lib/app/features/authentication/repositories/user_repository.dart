import 'package:dartz/dartz.dart';
import 'package:flutter_cos_challenge/app/core/errors/failures.dart';
import 'package:flutter_cos_challenge/app/features/authentication/data_sources/user_local_data_source.dart';
import 'package:flutter_cos_challenge/app/features/authentication/errors/user_failures.dart';
import 'package:flutter_cos_challenge/app/features/authentication/models/user.dart';
import 'package:uuid/uuid.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> authenticate(
      {required String email, required String password});
  Future<Either<Failure, User>> getUser();
  Future<Either<Failure, Unit>> logout();
}

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _userLocalDataSource;

  UserRepositoryImpl(this._userLocalDataSource);

  @override
  Future<Either<Failure, User>> authenticate({
    required String email,
    required String password,
  }) async {
    // Simulate authentication request (would return a token that would be
    // used to authenticate other requests). If the "fake" request fails, it
    // would return Left(Failure).
    await Future.delayed(const Duration(seconds: 1));

    // Generate a random UUID to simulate a token. In a real app, the token
    // would probably be JWT.
    final user = User(
      email: email,
      password: password,
      token: const Uuid().v4(),
    );

    try {
      await _userLocalDataSource.cacheUser(user);
    } catch (_) {
      // If it fails to cache the user, it will not return an error because
      // the user is authenticated and we don't want to block the user
      // from using the app.
    }

    return Right(user);
  }

  @override
  Future<Either<Failure, User>> getUser() async {
    try {
      final user = await _userLocalDataSource.getUser();
      if (user == null) return Left(GetUserFailure());

      return Right(user);
    } catch (e) {
      return Left(GetUserFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _userLocalDataSource.deleteUser();
      return const Right(unit);
    } catch (e) {
      return Left(LogoutFailure());
    }
  }
}
