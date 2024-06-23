import 'package:http/http.dart';

abstract class APIClient {
  Future<Response> get({
    required String host,
    required String endpoint,
    Map<String, String> headers = const {},
    Map<String, dynamic> queryParameters = const {},
  });
}

class MainAPIClient implements APIClient {
  final BaseClient _httpClient;

  MainAPIClient(this._httpClient);

  @override
  Future<Response> get({
    required String host,
    required String endpoint,
    Map<String, String> headers = const {},
    Map<String, dynamic> queryParameters = const {},
  }) {
    final uri = Uri.https(host, endpoint, queryParameters);
    return _httpClient.get(uri, headers: headers);
  }
}
