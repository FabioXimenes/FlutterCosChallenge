import 'package:flutter_cos_challenge/app/core/resources_startup/resources_startup.dart';
import 'package:flutter_cos_challenge/app/features/authentication/data_sources/user_local_data_source.dart';
import 'package:flutter_cos_challenge/app/features/authentication/repositories/user_repository.dart';
import 'package:get_it/get_it.dart';

class AuthenticationResourcesStartup extends ResourcesStartup {
  @override
  Future<void> init(GetIt sl) async {
    sl.registerSingleton<UserLocalDataSource>(
        UserLocalDataSourceImpl(sl.get()));

    sl.registerSingleton<UserRepository>(UserRepositoryImpl(sl.get()));
  }
}
