import 'dart:convert';

import 'package:flutter_cos_challenge/app/core/clients/api_client.dart';
import 'package:flutter_cos_challenge/app/core/clients/cos_challenge_client.dart';
import 'package:flutter_cos_challenge/app/core/errors/exceptions.dart';
import 'package:flutter_cos_challenge/app/features/auction/models/vehicle.dart';

abstract class AuctionRemoteDataSource {
  Future<List<Vehicle>> getAuctionDataFromVIN(
    String vin, {
    required String authToken,
  });
}

class AuctionRemoteDataSourceImpl implements AuctionRemoteDataSource {
  // In a real application, this would be injected and would come from be an
  // environment config file.
  final String baseUrl = 'api.cos.com';
  final APIClient _apiClient;

  AuctionRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<Vehicle>> getAuctionDataFromVIN(
    String vin, {
    required String authToken,
  }) async {
    final response = await _apiClient.get(
        host: baseUrl,
        endpoint: '/vehicles/$vin',
        headers: {CosChallenge.user: authToken});

    if (response.statusCode == 200) {
      return [Vehicle.fromJson(jsonDecode(response.body))];
    }

    if (response.statusCode == 300) {
      return (jsonDecode(response.body) as List)
          .map((e) => Vehicle.fromJson(e))
          .toList();
    }

    if (response.statusCode == 400) {
      throw ServerException(jsonDecode(response.body)['message']);
    }

    throw const ServerException('Failed to get auction data from VIN.');
  }
}
