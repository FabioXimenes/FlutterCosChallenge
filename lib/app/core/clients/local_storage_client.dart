import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class LocalStorageClient {
  Future<String?> get(String key);
  Future<void> set(String key, String value);
  Future<void> delete(String key);
}

class FlutterSecureStorageClient implements LocalStorageClient {
  final FlutterSecureStorage _flutterSecureStorage;

  FlutterSecureStorageClient(this._flutterSecureStorage);

  @override
  Future<String?> get(String key) {
    return _flutterSecureStorage.read(key: key);
  }

  @override
  Future<void> set(String key, String value) {
    return _flutterSecureStorage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) {
    return _flutterSecureStorage.delete(key: key);
  }
}
