import 'package:flutter_cos_challenge/app/core/clients/api_client.dart';
import 'package:flutter_cos_challenge/app/core/clients/cos_challenge_client.dart';
import 'package:flutter_cos_challenge/app/core/clients/local_storage_client.dart';
import 'package:flutter_cos_challenge/app/core/resources_startup/resources_startup.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

class CoreResourcesStartup extends ResourcesStartup {
  @override
  Future<void> init(GetIt sl) async {
    sl.registerSingleton<APIClient>(MainAPIClient(CosChallenge.httpClient));
    sl.registerSingleton<LocalStorageClient>(
        FlutterSecureStorageClient(const FlutterSecureStorage()));
  }
}
