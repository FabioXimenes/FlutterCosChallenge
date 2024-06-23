import 'dart:convert';

import 'package:flutter_cos_challenge/app/core/clients/local_storage_client.dart';
import 'package:flutter_cos_challenge/app/features/authentication/models/user.dart';

const key = 'user';

abstract class UserLocalDataSource {
  Future<void> cacheUser(User user);
  Future<User?> getUser();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final LocalStorageClient _localStorageClient;

  UserLocalDataSourceImpl(this._localStorageClient);

  @override
  Future<void> cacheUser(User user) {
    return _localStorageClient.set(key, jsonEncode(user.toJson()));
  }

  @override
  Future<User?> getUser() async {
    final userString = await _localStorageClient.get(key);

    if (userString != null) {
      return User.fromJson(jsonDecode(userString));
    }
    return null;
  }
}
